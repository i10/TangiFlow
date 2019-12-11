import json
from ROOT import ROOT_DIR
from PythonToSwift.ResultMaker.ImageSaver import ImageSaver
from PythonToSwift.ResultMaker.ResultMakerBase import ResultMakerBase
class ImageTypeResultMaker(ResultMakerBase):
    def create_file(self,id="",data=None,error=None,\
                    project_name="",tool_type="",extension="jpeg"):
        image_saver = ImageSaver()
        if not error:
            name = image_saver.save(type=tool_type,name=id,data=data,extension=extension)
            json_data = {"project_name":project_name,\
                         "error":False ,\
                         "type":"image",\
                         "extension":extension,\
                         "img":name}
        else:

            json_data = {"project_name":project_name,\
                         "error":True ,\
                         "data":"ERROR:" + str(data)}
        with open("{}/Files/Result/{}.json".format(ROOT_DIR,id), 'w+') as destination:
            json.dump(json_data,destination)
