from PIL import Image,ImageDraw,ImageFont
import pilgram

caption = "                            BEFORE                                                           AFTER"
def append_images(images, direction='horizontal',
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

    return add_title(new_im,caption = caption)

def add_title(im,caption = caption):
    width, height = im.size

    cp = Image.new('RGB', (width + 10, height + (height // 5)), 'white')
    font = ImageFont.truetype("Arial.ttf", 40)
    cp.paste(im, (5, 5, width + 5, height + 5))
    draw = ImageDraw.Draw(cp)
    draw.text(((20), (height + 20)), caption, fill="black",font=font)
    return cp



def apply_inkwell(image):
    result = pilgram.inkwell(image)
    return result


def apply_lofi(image):
    result = pilgram.lofi(image)
   # BackToSwift().prepare_data(type=ResultType.image.value, node_id=id, data=result, tool_type="pil", extension="jpg")
    return result


def apply_kelvin(image):
    result = pilgram.kelvin(image)
   # BackToSwift().prepare_data(type=ResultType.image.value, node_id=id, data=result, tool_type="pil", extension="jpg")
    return result


def apply_valencia(image):
    result = pilgram.valencia(image)
   # BackToSwift().prepare_data(type=ResultType.image.value, node_id=id, data=result, tool_type="pil", extension="jpg")
    return result


def apply_gingham(image):
    result = pilgram.gingham(image)
    #a = np.asarray(copyim)[:, :, ::-1].copy()
    #BackToSwift().prepare_data(type=ResultType.image.value, node_id=id, data=result, tool_type="pil", extension="jpg")
    return result






original = Image.open("sample1.jpg")
inkwel=apply_inkwell(original)
lofi=apply_lofi(original)
gingham=apply_gingham(original)
valencia= apply_valencia(original)
kelvin=apply_kelvin(original)

inkwel = append_images([original,inkwel])
lofi =  append_images([original,lofi])
gingham = append_images([original,gingham])
valencia = append_images([original,valencia])
kelvin = append_images([original,kelvin])


inkwel.save("inkwell.jpg")
lofi.save("lofi.jpg")
gingham.save("gingham.jpg")
valencia.save("valencia.jpg")
kelvin.save("kelvin.jpg")



