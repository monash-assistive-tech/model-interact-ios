import os
import xml.etree.ElementTree as ET
import json

ABSOLUTE_DIR = os.path.dirname(os.path.realpath(__file__))
XML_ANNOTATIONS_DIR = os.path.join(ABSOLUTE_DIR, "AllAnnotations")

class ImageAnnotation:
    def __init__(self):
        self.file_name = ""
        self.image_width = 0
        self.image_height = 0
        self.bounding_boxes = []

    def png_name(self):
        return os.path.splitext(self.file_name)[0] + ".png"

    def to_dict(self):
        return {
            "image": self.png_name(),
            "annotations": [
                {
                    "label": obj.label,
                    "coordinates": {
                        "x": (obj.min_x + obj.max_x)/2,
                        "y": (obj.min_y + obj.max_x)/2,
                        "width": obj.max_x - obj.min_x,
                        "height": obj.max_y - obj.min_y
                    }
                } for obj in self.bounding_boxes
            ]
        }

    def print_string(self):
        print("FILENAME:", self.file_name)
        print("WIDTH:", self.image_width, "HEIGHT:", self.image_height)
        for box in self.bounding_boxes:
            print(box.label, box.min_x, box.min_y, box.max_x, box.max_y)
        print("------------")

class BoundingBox:
    def __init__(self):
        self.label = ""
        self.min_x = 0
        self.min_y = 0
        self.max_x = 0
        self.max_y = 0

def parse_xml(file_path):
    tree = ET.parse(file_path)
    root = tree.getroot()
    img_annotation = ImageAnnotation()
    img_annotation.file_name = root.find('filename').text
    img_annotation.image_width = int(root.find('size/width').text)
    img_annotation.image_height = int(root.find('size/height').text)
    for obj in root.findall('object'):
        obj_annotation = BoundingBox()
        obj_annotation.label = obj.find('name').text
        obj_annotation.min_x = int(obj.find('bndbox/xmin').text)
        obj_annotation.min_y = int(obj.find('bndbox/ymin').text)
        obj_annotation.max_x = int(obj.find('bndbox/xmax').text)
        obj_annotation.max_y = int(obj.find('bndbox/ymax').text)
        img_annotation.bounding_boxes.append(obj_annotation)
    return img_annotation

classes = []
all_image_annotations = []
all_filenames = os.listdir(XML_ANNOTATIONS_DIR)
all_filenames.sort()
for filename in all_filenames:
    extension = os.path.splitext(filename)[1]
    if extension == ".xml":
        image_annotation = parse_xml(os.path.join(XML_ANNOTATIONS_DIR, filename))
        all_image_annotations.append(image_annotation)
        for box in image_annotation.bounding_boxes:
            if box.label not in classes:
                classes.append(box.label)

assert len(classes) == 5, "ERROR: There should only be 5 classes: " + str(classes)

image_annotations_dict = [x.to_dict() for x in all_image_annotations]
json_annotations = json.dumps(image_annotations_dict, indent=4)
with open(os.path.join(ABSOLUTE_DIR, "annotations.json"), "w") as outfile:
    outfile.write(json_annotations)
        