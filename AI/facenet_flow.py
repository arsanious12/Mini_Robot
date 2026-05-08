import cv2
import numpy as np
import mediapipe as mp
import math
from FaceId import get_embedding

mp_face_mesh = mp.solutions.face_mesh

mp_face_inst = mp_face_mesh.FaceMesh(
    static_image_mode=False,   # IMPORTANT FIX
    max_num_faces=1,
    refine_landmarks=True,
    min_detection_confidence=0.5
)

LEFT_EYE_IDX = [33, 160, 158, 133, 153, 144]
RIGHT_EYE_IDX = [362, 385, 387, 263, 373, 380]


def aligned_face(landmarks, indices, w, h):
    xs = [landmarks[i].x * w for i in indices]
    ys = [landmarks[i].y * h for i in indices]
    return np.mean(xs), np.mean(ys)


def facenet_flow(rgb):

    h, w = rgb.shape[:2]

    results = mp_face_inst.process(rgb)

    if not results.multi_face_landmarks:
        return None

    landmarks = results.multi_face_landmarks[0].landmark

    xs = [lm.x * w for lm in landmarks]
    ys = [lm.y * h for lm in landmarks]

    x1, x2 = int(min(xs)), int(max(xs))
    y1, y2 = int(min(ys)), int(max(ys))

    # padding
    pad_x = int((x2 - x1) * 0.2)
    pad_y = int((y2 - y1) * 0.2)

    x1 = max(0, x1 - pad_x)
    y1 = max(0, y1 - pad_y)
    x2 = min(w, x2 + pad_x)
    y2 = min(h, y2 + pad_y)

    # safety check
    if x2 <= x1 or y2 <= y1:
        return None

    # alignment
    left_eye = aligned_face(landmarks, LEFT_EYE_IDX, w, h)
    right_eye = aligned_face(landmarks, RIGHT_EYE_IDX, w, h)

    angle = math.degrees(math.atan2(
        right_eye[1] - left_eye[1],
        right_eye[0] - left_eye[0]
    ))

    center = ((x1 + x2) / 2, (y1 + y2) / 2)
    M = cv2.getRotationMatrix2D(center, angle, 1.0)

    aligned = cv2.warpAffine(rgb, M, (w, h))

    face = aligned[y1:y2, x1:x2]

    if face.size == 0:
        return None

    face = cv2.resize(face, (160, 160))

    return get_embedding(face)
