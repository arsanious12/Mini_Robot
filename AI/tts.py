import threading
import queue
import numpy as np
from TTS.api import TTS

from audio_player import play_audio_async


DEFAULT_MODEL = "glow-tts"
SAMPLE_RATE = 22050
CACHE_LIMIT = 100

_models = {}
_audio_cache = {}
gen_queue = queue.Queue(maxsize=50)


# ================= MODEL =================
def get_model(model_name):
    if model_name not in _models:
        print(f"Loading model: {model_name}")
        _models[model_name] = TTS(f"tts_models/en/ljspeech/{model_name}")
    return _models[model_name]


# ================= GENERATE PCM =================
def _generate_pcm(text, model_name):
    if not text or not isinstance(text, str):
        return None

    text = text.strip()
    key = f"{model_name}:{text}"

    if key in _audio_cache:
        return _audio_cache[key]

    model = get_model(model_name)

    try:
        audio = model.tts(text)
    except Exception as e:
        print("TTS error:", e)
        return None

    audio = np.asarray(audio, dtype=np.float32)

    if audio.size == 0:
        return None

    audio = np.clip(audio, -1.0, 1.0)

    if len(audio.shape) > 1:
        audio = audio.mean(axis=1)

    pcm = (audio * 32767).astype(np.int16).tobytes()

    if len(_audio_cache) >= CACHE_LIMIT:
        _audio_cache.pop(next(iter(_audio_cache)))

    _audio_cache[key] = pcm
    return pcm


# ================= PUBLIC =================
def text_to_pcm(text: str, model_name: str = DEFAULT_MODEL):
    return _generate_pcm(text, model_name)


# ================= WORKER =================
def worker():
    while True:
        item = gen_queue.get()
        if item is None:
            break
        try:
            text, model_name = item
            _generate_pcm(text, model_name)
        except Exception as e:
            print("Worker error:", e)
        gen_queue.task_done()


# ================= WARM UP =================
def warm_up(text, model_name=DEFAULT_MODEL):
    if gen_queue.full():
        try:
            gen_queue.get_nowait()
        except:
            pass

    gen_queue.put((text, model_name))


# ================= START =================
def start_workers(n=1):
    for _ in range(n):
        threading.Thread(target=worker, daemon=True).start()

def speak(text: str, model_name: str = DEFAULT_MODEL):
    """
    High-level speech API:
    text -> PCM -> async audio playback
    """

    pcm = text_to_pcm(text, model_name)

    if not pcm:
        print("Speak failed: empty PCM")
        return None

    play_audio_async(pcm, SAMPLE_RATE)
    return pcm
