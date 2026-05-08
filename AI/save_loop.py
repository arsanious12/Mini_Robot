import json
import numpy as np
from Compare import compare_embeddings

# =========================
# Load data once
# =========================
try:
    with open("faces.json", "r") as f:
        raw_data = json.load(f)
except:
    raw_data = []

FACE_DATA = []

for person in raw_data:
    FACE_DATA.append({
        "name": person["name"],
        "array": np.array(person["array"], dtype=np.float32)
    })


# =========================
# Save face
# =========================
def save_face(name, array):

    arraylist = array.tolist()

    # update file only
    try:
        with open("faces.json", "r") as f:
            data = json.load(f)
    except:
        data = []

    data.append({
        "name": name,
        "array": arraylist
    })

    with open("faces.json", "w") as f:
        json.dump(data, f, indent=4)

    print("Saved:", name)

# =========================
# Search face
# =========================
def search_face(new_embedding):
    print(f"Memory Address: {id(FACE_DATA)} | Size: {len(FACE_DATA)}")
    for person in FACE_DATA:
        result = compare_embeddings(new_embedding, person["array"])
        if result:
            return person["name"]

    return "Unknown"

def reload_data():
    global FACE_DATA

    try:
        with open("faces.json", "r") as f:
            raw_data = json.load(f)
    except:
        raw_data = []

    FACE_DATA = [
        {
            "name": p["name"],
            "array": np.array(p["array"], dtype=np.float32)
        }
        for p in raw_data
    ]
