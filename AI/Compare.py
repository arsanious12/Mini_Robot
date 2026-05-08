import numpy as np

def compare_embeddings(embedding_one, embedding_two, method="l2", threshold=0.8):
    """
    Compare two FaceNet embeddings and decide if they belong to the same person.

    Parameters:
    - embedding_one: first embedding (numpy array)
    - embedding_two: second embedding (numpy array)
    - method: "l2" or "cosine"
    - threshold: decision threshold

    Returns:
    - True  -> same person
    - False -> different person
    """

    embedding_one = np.array(embedding_one)
    embedding_two = np.array(embedding_two)

    # -------------------------
    # L2 (Euclidean Distance)
    # -------------------------
    if method == "l2":
        distance = np.linalg.norm(embedding_one - embedding_two)
        return distance < threshold

    # -------------------------
    # Cosine Similarity
    # -------------------------
    elif method == "cosine":
        dot_product = np.dot(embedding_one, embedding_two)
        norm_product = np.linalg.norm(embedding_one) * np.linalg.norm(embedding_two)

        if norm_product == 0:
            return False  # safety check

        cosine_similarity = dot_product / norm_product

        return cosine_similarity > threshold

    else:
        raise ValueError("Method must be 'l2' or 'cosine'")
