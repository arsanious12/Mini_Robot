import asyncio
import websockets
from gtts import gTTS
import io
import wave
import struct
import os

def text_to_wav_bytes(text, lang="ar"):
    """تحويل النص لصوت وإرجاعه كـ Raw PCM مناسب للـ ESP32 (بدون Header)"""
    
    # جيب الصوت من Google
    tts = gTTS(text=text, lang=lang)
    
    # احفظه مؤقتاً كـ MP3
    tts.save("temp.mp3")
    
    # حوّله لـ Raw PCM (s16le) بدون الـ WAV header اللي بيعمل زنة
    os.system("ffmpeg -y -i temp.mp3 -f s16le -ar 16000 -ac 1 temp.raw")
    
    # اقرأ الـ PCM
    with open("temp.raw", "rb") as f:
        wav_bytes = f.read()
    
    # امسح الملفات المؤقتة
    if os.path.exists("temp.mp3"):
        os.remove("temp.mp3")
    if os.path.exists("temp.raw"):
        os.remove("temp.raw")
    
    return wav_bytes


async def stream_audio(websocket):
    print(f"✅ Client connected!")

    # ── النص اللي عايز تحوله لصوت ──
    text =" Hi I am working"
    lang = "en" 
    

    wav_data = text_to_wav_bytes(text, lang)
    
    # ابعت الصوت للـ ESP32
    SAMPLE_RATE = 16000
    BYTES_PER_SAMPLE = 2  # 16-bit = 2 bytes
    CHUNK = 1024  # bytes

    for i in range(0, len(wav_data), CHUNK):
        chunk = wav_data[i:i + CHUNK]
        await websocket.send(chunk)
        # التوقيت الصح: عدد الـ samples ÷ sample rate
        num_samples = len(chunk) / BYTES_PER_SAMPLE
        await asyncio.sleep(num_samples / SAMPLE_RATE)

    # ابعت إشارة نهاية الصوت للـ ESP32
    await websocket.send(b"END")
    print("🔊 خلص!")

async def main():
    async with websockets.serve(stream_audio, "0.0.0.0", 8080):
        print("🚀 Server running on ws://0.0.0.0:8080")
        await asyncio.Future()

asyncio.run(main())