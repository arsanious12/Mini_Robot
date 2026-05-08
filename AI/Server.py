import cv2
import numpy as np
import asyncio
from fastapi import FastAPI, WebSocket, Request
import uvicorn
from ultralytics import YOLO

import warnings
warnings.filterwarnings("ignore")

import MainFlow
from GuestAddPhoto import GuestAddPhoto
from DetectObject import yolo_detect
from tts import start_workers, warm_up, text_to_pcm, speak
from audio_player import start_audio_worker

SERVER_PORT = 8000

app = FastAPI()

current_mode = "F"
esp_audio_sockets = set()
esp_cam_socket = None

model_data = YOLO("best.pt", verbose=False)

TTS_MODEL = "fast_pitch"

DEVICE_ONLY_MODES = {"A","I","R","T","M","D","ON","OFF","MF","MB","LU","LD","RU","RD","S"}


# ================= AUDIO STREAM =================
async def send_audio_to_esp(pcm):
    CHUNK = 2048

    if not pcm:
        print("Empty PCM")
        return

    for ws in list(esp_audio_sockets):
        try:
            await ws.send_text("START")

            for i in range(0, len(pcm), CHUNK):
                chunk = pcm[i:i + CHUNK]
                await ws.send_bytes(chunk)
                await asyncio.sleep(0.001)

            await ws.send_text("END")

        except Exception as e:
            print("Audio send error:", e)
            esp_audio_sockets.discard(ws)


# ================= HAND SIGNAL =================
async def send_hand_signal(text: str):
    if "hello" in text.lower():
        for ws in list(esp_audio_sockets):
            try:
                await ws.send_text("H")
            except:
                esp_audio_sockets.discard(ws)


# ================= SEND MODE =================
async def send_mode_to_esps(mode):
    global esp_cam_socket

    if esp_cam_socket:
        try:
            await esp_cam_socket.send_text(mode)
        except:
            esp_cam_socket = None

    for ws in list(esp_audio_sockets):
        try:
            await ws.send_text(mode)
        except:
            esp_audio_sockets.discard(ws)


# ================= ESP CAM =================
async def handle_esp_cam(websocket: WebSocket):
    global current_mode, esp_cam_socket

    await websocket.accept()
    esp_cam_socket = websocket

    print("ESP-CAM connected")

    last_spoken = None

    try:
        while True:
            frame_bytes = await websocket.receive_bytes()

            frame = cv2.imdecode(
                np.frombuffer(frame_bytes, np.uint8),
                cv2.IMREAD_COLOR
            )

            if frame is None:
                continue

            if current_mode == "F":
                result = MainFlow.MainFlow(frame)

            elif current_mode == "O":
                result = yolo_detect(frame, model_data, confidence=0.6)

            else:
                result = None

            if result and isinstance(result, str) and result != last_spoken:
                last_spoken = result

                await send_hand_signal(result)
                speak(result)


    except Exception as e:
        print("ESP-CAM disconnected:", e)
        esp_cam_socket = None


@app.websocket("/ws/esp_cam")
async def esp_cam(websocket: WebSocket):
    await handle_esp_cam(websocket)


# ================= ESP AUDIO =================
@app.websocket("/esp/ws/esp_audio")
async def esp_audio(websocket: WebSocket):
    await websocket.accept()
    esp_audio_sockets.add(websocket)

    print("ESP-AUDIO connected")

    try:
        while True:
            await websocket.receive_text()
    except:
        pass
    finally:
        esp_audio_sockets.discard(websocket)


# ================= FLUTTER =================
@app.post("/flutter")
async def flutter(request: Request):
    global current_mode

    mode = request.headers.get("mode")
    print(mode)
    if mode in ["F", "O" ,"A","I","R","T","M","D","ON","OFF","MF","MB","LU","LD","RU","RD","S"]:
        current_mode = mode
        await send_mode_to_esps(mode)
        return {"status": "mode updated"}

    if mode in DEVICE_ONLY_MODES:
        await send_mode_to_esps(mode)
        return {"status": "device mode sent"}

    img_bytes = await request.body()

    if not img_bytes:
        return {"status": "no image"}

    img = cv2.imdecode(
        np.frombuffer(img_bytes, np.uint8),
        cv2.IMREAD_COLOR
    )

    if img is None:
        return {"status": "invalid image"}

    ok = GuestAddPhoto(mode, img, MainFlow.reload_q)

    if ok:
        # pcm = text_to_pcm(f"{mode} registered successfully", TTS_MODEL)
        # await send_audio_to_esp(pcm)
        speak(f"{mode} registered successfully")

        return {"status": "registered"}

    return {"status": "failed"}


# ================= MAIN =================
if __name__ == "__main__":
    MainFlow.init_pool()
    start_workers(1)
    start_audio_worker()
    warm_up("system ready", TTS_MODEL)

    print("SERVER STARTED")

    uvicorn.run(app, host="0.0.0.0", port=SERVER_PORT)