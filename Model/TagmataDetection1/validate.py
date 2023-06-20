import os

ABSOLUTE_DIR = os.path.dirname(os.path.realpath(__file__))
TRAINING_DIR = os.path.join(ABSOLUTE_DIR, "Training")

all_filenames = os.listdir(TRAINING_DIR)
all_filenames.sort()
x = 0
for filename in all_filenames:
    x += 1
    extension = os.path.splitext(filename)[1]
    if extension not in [".png", ".json"]:
        print("FAILED")
    else:
        print(filename)
print(x)