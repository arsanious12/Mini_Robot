import torch
from facenet_pytorch import InceptionResnetV1
import numpy as np

device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

resnet = InceptionResnetV1(pretrained='vggface2').eval().to(device)


def get_embedding(face_image):

    img = np.asarray(face_image, dtype=np.float32)

    face_tensor = torch.from_numpy(img).permute(2, 0, 1)

    face_tensor = (face_tensor - 127.5) / 128.0

    face_tensor = face_tensor.unsqueeze(0).to(device)

    with torch.no_grad():
        embedding = resnet(face_tensor)

    return embedding[0].cpu().numpy()
