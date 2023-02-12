'''check if image files are broken. Ex: There are a few broken imgs in imagenet'''
from PIL import Image
import os 

def is_valid(file):
    valid = True
    try:
        Image.open(file).load()
    except OSError:
        valid = False
    return valid

check_folder = '/scratch/PI/tongzhang/tl/datasets/imagenet/val'
classes = os.listdir(check_folder)
for _cls in classes:
    all_imgs = os.listdir(check_folder + '/' + _cls)
    for img in all_imgs:
        img_path = check_folder + '/' + _cls + '/' + img
        if not is_valid(img_path):
            print(img_path)
        
