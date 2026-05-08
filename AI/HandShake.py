import cv2
import mediapipe as mp
import math

mp_hands = mp.solutions.hands

hands = mp_hands.Hands(
    static_image_mode=False,
    max_num_hands=2,
    min_detection_confidence=0.5,
    min_tracking_confidence=0.5
)

def distance(a, b):
    return math.sqrt((a.x - b.x)**2 + (a.y - b.y)**2)

def is_high_five(hand_landmarks, hand_handedness):
    wrist = hand_landmarks.landmark[0]

    fingertips = [8, 12, 16, 20]
    mcp_joints = [5, 9, 13, 17]

    open_fingers = 0

    for tip, mcp in zip(fingertips, mcp_joints):
        if hand_landmarks.landmark[tip].y < hand_landmarks.landmark[mcp].y:
            open_fingers += 1

    index = hand_landmarks.landmark[8]
    pinky = hand_landmarks.landmark[20]

    spread = distance(index, pinky)

    label = hand_handedness.classification[0].label

    if label == 'Right':
        check = hand_landmarks.landmark[5].x - hand_landmarks.landmark[17].x < 0
    else:
        check = hand_landmarks.landmark[5].x - hand_landmarks.landmark[17].x > 0

    if open_fingers == 4 and spread > 0.08 and check:
        return True

    return False

def detect_hand(frame):
    if frame is None:
        return False

    frame = cv2.flip(frame, 1)
    rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

    result = hands.process(rgb_frame)

    if result.multi_hand_landmarks:
        for hand_landmarks, hand_handedness in zip(
            result.multi_hand_landmarks,
            result.multi_handedness
        ):
            if is_high_five(hand_landmarks, hand_handedness):
                return True

    return False

 