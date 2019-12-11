
from Routines.Decorators import hello_decorator
from Enums import *
import pilgram
from PIL import ImageFilter,ImageEnhance,Image
import numpy as np
import cv2 as cv


def image_source(controled_value):
    return np.array(Image.open(controled_value))



def change_contrast(image,controled_value):
    copyim = Image.fromarray(image)
    contrast = ImageEnhance.Contrast(copyim)
    result = contrast.enhance(float(controled_value))
    imcv = np.array(result)
    return imcv


def change_brightness(image,controled_value):
    copyim = Image.fromarray(image)
    brightness = ImageEnhance.Brightness(copyim)
    result = brightness.enhance(float(controled_value))
    imcv = np.array(result)
    return imcv


def change_saturation(image,controled_value):
    copyim = Image.fromarray(image)
    color = ImageEnhance.Color(copyim)
    result = color.enhance(float(controled_value))
    imcv = np.array(result)
    return imcv


def change_sharpness(image,controled_value):
    copyim = Image.fromarray(image)
    color = ImageEnhance.Sharpness(copyim)
    result = color.enhance(float(controled_value))
    imcv = np.array(result)
    return imcv


def change_rgb(image,controled_red,controled_green,controled_blue):




def apply_gamma_correction(image,controled_gamma):
    lookUpTable = np.empty((1,256), np.uint8)
    for i in range(256):
        lookUpTable[0,i] = np.clip(pow(i / 255.0, controled_gamma) * 255.0, 0, 255)
    result = cv.LUT(image, lookUpTable)

    return result


def apply_inkwell(image):
    print("APPLYING INKWELL")
    copyim = Image.fromarray(image)
    filtered = pilgram.inkwell(copyim)
    imcv = np.asarray(filtered)[:, :, ::-1].copy()
    return imcv


def apply_lofi(image):
    copyim = Image.fromarray(image)
    filtered = pilgram.inkwell(copyim)
    imcv = np.asarray(filtered)[:, :, ::-1].copy()
    return imcv


def apply_kelvin(image):
    copyim = Image.fromarray(image)
    filtered = pilgram.lofi(copyim)
    imcv = np.asarray(filtered)[:, :, ::-1].copy()
    return imcv


def apply_valencia(image):

    copyim = Image.fromarray(image)
    filtered = pilgram.valencia(copyim)
    imcv = np.asarray(filtered)[:, :, ::-1].copy()
    return imcv


def apply_gingham(image):
    copyim = Image.fromarray(image)
    filtered = pilgram.gingham(copyim)
    imcv = np.asarray(filtered)[:, :, ::-1].copy()
    return imcv



im = image_source("/Users/ppi/Desktop/ImageSource/mercedes.jpg")
new_img = change_rgb(im,0,20,0)

cv.imwrite("new.jpg", new_img)