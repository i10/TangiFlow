import cv2
from ROOT import ROOT_DIR
class ImageSaver:

    def save(self,type,name,data,extension="jpg"):

        file_name = "{}/Files/Images/{}.{}".format(ROOT_DIR,name,extension)
        print("HEYHYE",file_name)
        if type == "cv2":
            print("CV2")
            cv2.imwrite(file_name, data)
        elif type == "pil":
            print("I am working")
            print("{}/Result/Images/{}.{}".format(ROOT_DIR,name,extension))
            data.save("{}/Files/Images/{}.{}".format(ROOT_DIR,name,extension))
        else:
            pass
        return file_name
