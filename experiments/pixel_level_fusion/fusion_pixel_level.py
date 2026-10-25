from PIL import Image
import numpy as np
import glob
import os

CLEAN_DIR = "../imgs/clean/"
FANS_DIR = "../imgs/fans/" # BLU
SARBM3D_DIR = "../imgs/sarbm3d/" # RED
SARCAM_DIR = "../imgs/sarcam/" # GREEN
KUAN_DIR = "../imgs/kuan/" # YELLOW
GAMMA_DIR = "../imgs/gamma/" # PINK
OUTPUT_DIR = "results/"

def get_images_paths(folder_path):
    images_paths_list = []
    for filename in glob.glob(f"{folder_path}*.tif"):
        images_paths_list.append(filename)
    return images_paths_list

def get_images_from_path(images_paths):
    images = []
    for image_path in images_paths:
        images.append(Image.open(image_path))
    return np.asarray(images, dtype=float)

def make_fusion_and_save(clean_img, images, img_name):
    distances = np.abs(images - clean_img)
    map_for_fusion = np.argmin(distances, axis=0)

    rows, cols = np.indices(map_for_fusion.shape)    
    img_fused = images[map_for_fusion, rows,cols]
    
    Image.fromarray(img_fused.astype(np.uint8)).save(f"results/{img_name}")




def fusion_pixel_level():
    clean_images_paths = get_images_paths(CLEAN_DIR)
    fans_images_paths = get_images_paths(FANS_DIR)
    sarbm3d_images_paths = get_images_paths(SARBM3D_DIR)
    sarcam_images_paths = get_images_paths(SARCAM_DIR)
    kuan_images_paths = get_images_paths(KUAN_DIR)
    gamma_images_paths = get_images_paths(GAMMA_DIR)

    for clean_image_path,fans_image_path,sarbm3d_image_path,sarcam_image_path,kuan_image_path,gamma_image_path in zip(
            clean_images_paths,fans_images_paths,sarbm3d_images_paths,sarcam_images_paths,kuan_images_paths,gamma_images_paths):

            img_name = os.path.basename(clean_image_path)
        
            clean_img = get_images_from_path([clean_image_path])

            
            images = get_images_from_path([
                fans_image_path, sarbm3d_image_path, sarcam_image_path, 
                kuan_image_path, gamma_image_path])
            
            img_fused = make_fusion_and_save(clean_img, images, img_name)


                                  

if __name__ == '__main__':
    fusion_pixel_level()










