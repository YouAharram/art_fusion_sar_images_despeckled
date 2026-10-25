from PIL import Image
import glob
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
from matplotlib.patches import Patch
import os 
import tifffile

CLEAN_DIR = "../imgs/clean/"
FANS_DIR = "../imgs/fans/" # BLU
SARBM3D_DIR = "../imgs/sarbm3d/" # RED
SARCAM_DIR = "../imgs/sarcam/" # GREEN
KUAN_DIR = "../imgs/kuan/" # YELLOW
GAMMA_DIR = "../imgs/gamma/" # PINK
COLOR_MAP_DIR = '../imgs/color_map'
model_names = ['FANS', 'SARBM3D', 'SARCAM', 'KUAN', 'GAMMA']


def get_images_path(path_dir):
    images_path = []
    for filename in glob.glob(f"{path_dir}/*.tif"):
        images_path.append(filename);
    return images_path


def get_images_and_name(clean_path, fans_path, sarbm3d_path, sarcam_path, kuan_path, gamma_path):
    
    img_name = os.path.basename(clean_path)
    print(img_name)
    clean_img = Image.open(clean_path)
    fans_img = Image.open(fans_path)
    sarbm3d_img = Image.open(sarbm3d_path)
    sarcam_img = Image.open(sarcam_path)
    kuan_img = Image.open(kuan_path)
    gamma_img = Image.open(gamma_path)

    return clean_img, fans_img, sarbm3d_img, sarcam_img, kuan_img, gamma_img, img_name


def calculate_color_map(clean_img, fans_img, sarbm3d_img, sarcam_img, kuan_img, gamma_img):
    clean_img = np.asarray(clean_img, dtype=float)

    imgs_array = np.asarray(
        [fans_img, sarbm3d_img, sarcam_img, kuan_img, gamma_img], dtype=float)


    distances = np.abs(imgs_array - clean_img)

    color_map = np.argmin(distances, axis=0)
    print(color_map.shape)
    return color_map

def save_color_map(output_dir, color_map, img_name):

    os.makedirs(output_dir, exist_ok=True)

    colors = np.array([
        [255, 0, 0],      # Red: FANS
        [0, 255, 0],      # Green: SARBM3D
        [0, 0, 255],      # Blue: SARCAM
        [255, 255, 0],    # Yellow: KUAN
        [255, 0, 255]     # Magenta: GAMMA
    ], dtype=np.uint8)

    model_names = ['FANS', 'SARBM3D', 'SARCAM', 'KUAN', 'GAMMA']

    # Convert indices to RGB colors
    rgb_image = colors[color_map]

    # Create figure
    fig, ax = plt.subplots(figsize=(10, 8))
    ax.imshow(rgb_image)
    ax.axis('off')

    # Create legend
    legend_elements = [
        Patch(facecolor=colors[i] / 255.0, label=model_names[i])
        for i in range(len(model_names))
    ]

    ax.legend(
        handles=legend_elements,
        loc='upper left',
        bbox_to_anchor=(1.02, 1),
        title='Models',
        fontsize=10
    )

    plt.tight_layout()

    # Save image with legend
    output_path = os.path.join(
        output_dir,
        img_name
    )

    fig.savefig(
        output_path,
        dpi=300,
        bbox_inches='tight',
        format='tiff'
    )

    plt.close(fig)
def create_color_map():
     clean_path_imgs = get_images_path(CLEAN_DIR)
     fans_path_imgs = get_images_path(FANS_DIR)
     sarbm3d_path_imgs = get_images_path(SARBM3D_DIR)
     sarcam_path_imgs = get_images_path(SARCAM_DIR)
     kuan_path_imgs = get_images_path(KUAN_DIR)
     gamma_path_imgs = get_images_path(GAMMA_DIR)

     for clean_path, fans_path, sarbm3d_path, sarcam_path, kuan_path, gamma_path in zip(clean_path_imgs, fans_path_imgs, sarbm3d_path_imgs, sarcam_path_imgs, kuan_path_imgs, gamma_path_imgs):
         clean_img, fans_img, sarbm3d_img, sarcam_img, kuan_img, gamma_img, img_name = get_images_and_name(
                                                                                    clean_path, fans_path, sarbm3d_path, 
                                                                                    sarcam_path, kuan_path, gamma_path)
         color_map = calculate_color_map(clean_img, fans_img, sarbm3d_img, sarcam_img, kuan_img, gamma_img)
         save_color_map(COLOR_MAP_DIR, color_map, img_name)




if __name__  == "__main__":
    create_color_map()


