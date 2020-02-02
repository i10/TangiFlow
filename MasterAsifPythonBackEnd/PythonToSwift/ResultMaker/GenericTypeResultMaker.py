import json
from ROOT import ROOT_DIR
from PythonToSwift.ResultMaker.ResultMakerBase import ResultMakerBase

class GenericResultMaker(ResultMakerBase):
    """ 
    This function is responsible for creating resulting JSON file for a node with given id 
    for generic python data type such as integer, string and etc.
  
    Parameters: 
    id (str): id of the node
    data (generic python type): result data which should be displayed. In case no data available leave it None
    error (str): in case of exception error message of exception should be provided
    project_name (str): name of the project. can be left empty. it is optional
    """
    def create_file(self,id="",data=None,error=None,project_name=""):
    
        if not error:
            json_data = {"project_name":project_name,\
                         "error":False ,\
                         "type":"generic",\
                         "data":data}
            print("i am non error",json_data)
        else:

            json_data = {"project_name":project_name,\
                         "error":True ,\
                         "data":"Error:" + str(data)}
            print("i am error",json_data)
        with open("{}/Files/Result/{}.json".format(ROOT_DIR,id), 'w+') as destination:
            json.dump(json_data,destination)
