import json

from PythonToSwift.ResultMaker.ResultMakerBase import ResultMakerBase


class PlotTypeResultMaker(ResultMakerBase):
    def create_file(self,plot_type,id="",data=None,error=None,project_name="",x=[],y=[]):
        if not error:
            json_data = {"project_name":project_name,\
                         "error":False ,\
                         "type":"plot",\
                         "plot_type":plot_type,\
                         "data":data}
        else:
            json_data = {"project_name":project_name,\
                         "error":True ,\
                         "type":"plot",\
                         "data":error}

        with open("../Files/{}.json".format(id), 'w+') as destination:
            json.dump(json_data,destination)
