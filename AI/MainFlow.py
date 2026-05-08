import multiprocessing as mp
import cv2

face_frame_q = None
hand_frame_q = None
face_q = None
hand_q = None
reload_q = None

_last_name = None
_last_hand = False


# ================= FACE WORKER =================
def face_worker(in_q, out_q, reload_q):
    from facenet_flow import facenet_flow
    from save_loop import search_face, reload_data

    reload_data()

    while True:

        img = in_q.get()

        # reload signal
        try:
            reload_q.get_nowait()
            reload_data()
            print("DB Reloaded")
        except:
            pass

        embed = facenet_flow(img)

        result = search_face(embed) if embed is not None else None
        print("face:", result)

        try:
            out_q.get_nowait()
        except:
            pass

        out_q.put(result)




# ================= HAND WORKER =================
def hand_worker(in_q, out_q):
    from HandShake import detect_hand

    while True:
        img = in_q.get()

        result = detect_hand(img)
        print("hand:", result)

        try:
            out_q.get_nowait()
        except:
            pass

        out_q.put(result)



# ================= INIT =================
def init_pool():
    global face_frame_q, hand_frame_q, face_q, hand_q, reload_q

    reload_q = mp.Queue()
    mp.set_start_method("spawn", force=True)

    face_frame_q = mp.Queue(maxsize=1)
    hand_frame_q = mp.Queue(maxsize=1)

    face_q = mp.Queue(maxsize=1)
    hand_q = mp.Queue(maxsize=1)

    mp.Process(
        target=face_worker,
        args=(face_frame_q, face_q, reload_q),
        daemon=True
    ).start()

    mp.Process(
        target=hand_worker,
        args=(hand_frame_q, hand_q),   # ← تم التعديل هنا
        daemon=True
    ).start()



# ================= MAIN FLOW =================
def MainFlow(frame):

    global _last_name, _last_hand

    rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

    # safe non-blocking push
    try:
        face_frame_q.put_nowait(rgb)
    except:
        pass

    try:
        hand_frame_q.put_nowait(rgb)
    except:
        pass

    # safe non-blocking read
    try:
        _last_name = face_q.get_nowait()
    except:
        pass

    try:
        _last_hand = hand_q.get_nowait()
    except:
        pass

    face_known = _last_name not in ["Unknown", None]

    if face_known:
        return f"Hello {_last_name}"

    elif _last_hand:
        return "Hello"

