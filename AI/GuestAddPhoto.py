import facenet_flow
import save_loop


def GuestAddPhoto(name, img, reload_q):
    embedding = facenet_flow.facenet_flow(img)

    if embedding is None:
        print("No face detected in photo.")
        return False

    save_loop.save_face(name, embedding)

    reload_q.put("reload")

    return True
