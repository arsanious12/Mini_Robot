def yolo_detect(frame, model, confidence=0.6):
    results = model(frame, stream=True, conf=confidence) # stream=True is faster for video
    label = {}

    for r in results:
        if r.boxes is not None:
            for box in r.boxes:
                cls_id = int(box.cls[0])
                class_name = model.names[cls_id]
                label[class_name] = label.get(class_name, 0) + 1

    # Format the dictionary into a string
    labels_str = " and ".join([f"{count} {name}" for name, count in label.items()])
    return labels_str