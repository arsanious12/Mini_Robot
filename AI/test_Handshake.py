import cv2

from HandShake import detect_hand

if __name__ == "__main__":



    cap = cv2.VideoCapture(0)

    if not cap.isOpened():
        print("Camera not opened")
        exit()

    while True:
        ret, frame = cap.read()
        if not ret:
            break

        result = detect_hand(frame)

        cv2.putText(frame, str(result), (50, 50),
                    cv2.FONT_HERSHEY_SIMPLEX, 1,
                    (0, 255, 0), 2)

        cv2.imshow("Camera", frame)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()
