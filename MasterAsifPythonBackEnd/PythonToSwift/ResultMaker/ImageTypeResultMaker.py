import json
from ROOT import ROOT_DIR
from PythonToSwift.ResultMaker.ImageSaver import ImageSaver
from PythonToSwift.ResultMaker.ResultMakerBase import ResultMakerBase
class ImageTypeResultMaker(ResultMakerBase):
    """ 
    This function is responsible for creating resulting JSON file for a node with given id 
    for images
  
    Parameters: 
    id (str): id of the node
    
    data (generic python type): result data which should be displayed. In case no data available leave it None
    
    error (str): in case of exception error message of exception should be provided
    
    project_name (str): name of the project. can be left empty. it is optional
    
    tool_type (str): different libraries can have different ways of saving data. 
                     In this specific case we use cv2 and Pillow for image editing and they save files differently. 
                     To handle this we provide which tool we are using
    extension (str): extension of image to save
    """
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
