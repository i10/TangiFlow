import pythonflow as pf
from Routines.Decorators import hello_decorator
from PythonToSwift.BackToSwift import BackToSwift
from Enums import *
import pilgram
from PIL import ImageFilter,ImageEnhance,Image,ImageDraw,ImageFont
import numpy as np
import cv2 as cv
import  textwrap
@pf.opmethod(length=1)
def image_source(controled_value,id):
    return Image.open(controled_value)


@pf.opmethod(length=1)
def change_contrast(image,controled_value,id):
    print("ID IS:",id)
    contrast = ImageEnhance.Contrast(image)
    result = contrast.enhance(float(controled_value))
    BackToSwift().prepare_data(type=ResultType.image.value,node_id=id, data=result,tool_type="pil",extension="jpg")
    return result

@pf.opmethod(length=1)
def change_brightness(image,controled_value,id):
    brightness = ImageEnhance.Brightness(image)
    result = brightness.enhance(float(controled_value))
    BackToSwift().prepare_data(type=ResultType.image.value,node_id=id, data=result,tool_type="pil",extension="jpg")
    return result

@pf.opmethod(length=1)
def change_saturation(image,controled_value,id):
    color = ImageEnhance.Color(image)
    result = color.enhance(float(controled_value))
    BackToSwift().prepare_data(type=ResultType.image.value,node_id=id, data=result,tool_type="pil",extension="jpg")
    return result

@pf.opmethod(length=1)
def change_sharpness(image,controled_value,id):
    color = ImageEnhance.Sharpness(image)
    result = color.enhance(float(controled_value))
    BackToSwift().prepare_data(type=ResultType.image.value, node_id=id, data=result, tool_type="pil", extension="jpg")
    return result



@pf.opmethod(length=1)
def apply_gamma_correction(image,controled_gamma,id):
    lookUpTable = np.empty((1,256), np.uint8)
    for i in range(256):
        lookUpTable[0,i] = np.clip(pow(i / 255.0, controled_gamma) * 255.0, 0, 255)
    result = cv.LUT(image, lookUpTable)

    return result

@pf.opmethod(length=1)
def apply_inkwell(image,id):
    print("INKWELL")
    print(image)
    result = pilgram.inkwell(image)
    BackToSwift().prepare_data(type=ResultType.image.value, node_id=id, data=result, tool_type="pil", extension="jpg")
    return result

@pf.opmethod(length=1)
def apply_lofi(image,id):
    result = pilgram.lofi(image)
    BackToSwift().prepare_data(type=ResultType.image.value, node_id=id, data=result, tool_type="pil", extension="jpg")
    return result

@pf.opmethod(length=1)
def apply_kelvin(image,id):
    result = pilgram.lofi(image)
    BackToSwift().prepare_data(type=ResultType.image.value, node_id=id, data=result, tool_type="pil", extension="jpg")
    return result

@pf.opmethod(length=1)
def apply_valencia(image,id):
    result = pilgram.valencia(image)
    BackToSwift().prepare_data(type=ResultType.image.value, node_id=id, data=result, tool_type="pil", extension="jpg")
    return result

@pf.opmethod(length=1)
def apply_gingham(image,id):
    result = pilgram.gingham(image)
    #a = np.asarray(copyim)[:, :, ::-1].copy()
    BackToSwift().prepare_data(type=ResultType.image.value, node_id=id, data=result, tool_type="pil", extension="jpg")
    return result

@pf.opmethod(length=1)
def black_and_white(image,id):
    color = ImageEnhance.Color(image)
    result = color.enhance(0)
    BackToSwift().prepare_data(type=ResultType.image.value, node_id=id, data=result, tool_type="pil", extension="jpg")
    return result



def text_wrap(text, font, max_width):
    lines = []
    # If the width of the text is smaller than image width
    # we don't need to split it, just add it to the lines array
    # and return
    print("YELLOW!")
    print(font.getsize(text)[0])
    if font.getsize(text)[0] <= max_width:
        lines.append(text)
    else:
        # split the line by spaces to get words
        words = text.split(' ')
        i = 0
        # append every word to a line while its width is shorter than image width
        while i < len(words):
            line = ''
            while i < len(words) and font.getsize(line + words[i])[0] <= max_width:
                line = line + words[i] + " "
                i += 1
            if not line:
                line = words[i]
                i += 1
            # when the line gets longer than the max width do not append the word,
            # add the line to the lines array
            lines.append(line)
    return lines

@pf.opmethod(length=1)
def add_caption(image,id,controled_caption):
    print("HELLO ME")
    print(controled_caption)
    width, height = image.size
    print("HELLO WORLD 2")
    result = Image.new('RGB', (width + 5, height + (height // 2)), 'white')
    result.paste(image, (5, 5, width + 5, height + 5))
    font = ImageFont.truetype("/Users/ppi/Documents/Code/MaasterAsifPythonBackEnd/Arial.ttf", size=90)
    caption = controled_caption
    draw = ImageDraw.Draw(result)


    import textwrap
    lines = text_wrap(controled_caption, font,width)
    print("YELLOW")
    print(lines)
    y_text = height+20
    for line in lines:
        fwidth, fheight = font.getsize(line)
        draw.text((20 / 2, y_text), line, font=font, fill="black")
        y_text += fheight





    # draw = ImageDraw.Draw(result)
    # draw.text(((20), (height + 20)), caption, fill="black",font=font)
    BackToSwift().prepare_data(type=ResultType.image.value, node_id=id, data=result, tool_type="pil", extension="jpg")
    return result

@pf.opmethod(length=1)
def stitch_horizontal(image1,image2,id):
    print(1)
    imgs = [image1,image2]

    result = append_images(images=imgs,direction="horizontal")
    print(5)
    BackToSwift().prepare_data(type=ResultType.image.value, node_id=id, data=result, tool_type="pil", extension="jpg")
    print(6)
    return result


@pf.opmethod(length=1)
def stitch_verticaly(image1,image2,id):
    imgs = [ image1, image2]
    # pick the image which is the smallest, and resize the others to match it (can be arbitrary image shape here)

    result = append_images(images=imgs)
    BackToSwift().prepare_data(type=ResultType.image.value, node_id=id, data=result, tool_type="pil", extension="jpg")
    return result


def append_images(images, direction='vertical',
                  bg_color=(255,255,255), aligment='left'):
    """
    Appends images in horizontal/vertical direction.

    Args:
        images: List of PIL images
        direction: direction of concatenation, 'horizontal' or 'vertical'
        bg_color: Background color (default: white)
        aligment: alignment mode if images need padding;
           'left', 'right', 'top', 'bottom', or 'center'

    Returns:
        Concatenated image as a new PIL image object.
    """
    widths, heights = zip(*(i.size for i in images))

    if direction=='horizontal':
        new_width = sum(widths)
        new_height = max(heights)
    else:
        new_width = max(widths)
        new_height = sum(heights)

    new_im = Image.new('RGB', (new_width, new_height), color=bg_color)


    offset = 0
    for im in images:
        if direction=='horizontal':
            y = 0
            if aligment == 'center':
                y = int((new_height - im.size[1])/2)
            elif aligment == 'bottom':
                y = new_height - im.size[1]
            new_im.paste(im, (offset, y))
            offset += im.size[0]
        else:
            x = 0
            if aligment == 'center':
                x = int((new_width - im.size[0])/2)
            elif aligment == 'right':
                x = new_width - im.size[0]
            new_im.paste(im, (x, offset))
            offset += im.size[1]

    return new_im



