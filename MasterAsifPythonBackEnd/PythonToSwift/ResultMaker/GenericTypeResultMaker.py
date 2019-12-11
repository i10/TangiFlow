import json
from ROOT import ROOT_DIR
from PythonToSwift.ResultMaker.ResultMakerBase import ResultMakerBase


class GenericResultMaker(ResultMakerBase):
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
