import cv2
from ultralytics import YOLO
from DetectObject import yolo_detect
from GuestAddPhoto import GuestAddPhoto
import MainFlow
from tts import start_workers,speak
from audio_player import start_audio_worker



def main():
    start_workers(n=3)
    start_audio_worker()
    MainFlow.init_pool()

    model_data = YOLO("best.pt", verbose=False)

    cap = cv2.VideoCapture(0)

    if not cap.isOpened():
        print("Camera not opened")
        return

    mode = "F"
    previous_mode = mode

    waiting_for_name = False
    captured_frame = None
    typed_name = ""
    last_spoken = ""

    while True:
        ret, frame = cap.read()
        if not ret:
            break

        # ================= REGISTER MODE =================
        if waiting_for_name:

            display = captured_frame.copy()

            cv2.putText(
                display,
                f"Enter Name: {typed_name}",
                (50, 50),
                cv2.FONT_HERSHEY_SIMPLEX,
                1,
                (0, 255, 255),
                2
            )

            cv2.imshow("Camera", display)

            key = cv2.waitKey(1) & 0xFF

            # ENTER
            if key == 13:
                if typed_name.strip():
                    result = GuestAddPhoto(
                        typed_name,
                        captured_frame,
                        MainFlow.reload_q
                    )
                    print("Saved:", typed_name)

                waiting_for_name = False
                typed_name = ""
                mode = previous_mode

            # BACKSPACE
            elif key == 8:
                typed_name = typed_name[:-1]

            # TYPE
            elif 32 <= key <= 126:
                typed_name += chr(key)

            continue

        # ================= NORMAL MODE =================

        if mode == "O":
            result = yolo_detect(frame, model_data, confidence=0.6)

        elif mode == "F":
            result = MainFlow.MainFlow(frame)

        else:
            result = "NULL"

        cv2.putText(
            frame,
            str(result),
            (50, 50),
            cv2.FONT_HERSHEY_SIMPLEX,
            1,
            (0, 255, 0),
            2
        )
        text = str(result).strip()
        if text and text not in [last_spoken, "None"]:
            speak(text)
            last_spoken = text
        cv2.imshow("Camera", frame)

        key = cv2.waitKey(1) & 0xFF

        if key == ord('O'):
            mode = "O"

        elif key == ord('F'):
            mode = "F"

        elif key == ord('R'):
            previous_mode = mode
            captured_frame = frame.copy()
            waiting_for_name = True
            typed_name = ""

        elif key == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()


if __name__ == "__main__":
    main()