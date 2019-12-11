from Enums import *
from PythonToSwift.ResultMaker.GenericTypeResultMaker import GenericResultMaker
from PythonToSwift.ResultMaker.PlotTypeResultMaker import PlotTypeResultMaker
from PythonToSwift.ResultMaker.TableTypeResultMaker import TableTypeResultMaker
from PythonToSwift.ResultMaker.ImageTypeResultMaker import ImageTypeResultMaker
class PlotTypeNotProvided(Exception):
    pass

class BackToSwift:
    result_maker = None
    def prepare_data(self,type=ResultType.generic_python.value,node_id="",\
                     data=None,error=None,\
                     plot_type=None,project_name="",\
                     tool_type=None,extension=None):
        if type == ResultType.generic_python.value:
            GenericResultMaker().create_file(node_id,\
                                            data=data,\
                                             error=error,\
                                             project_name=project_name)
        elif type == ResultType.plot:
            if plot_type is None:
                raise PlotTypeNotProvided
            else:
                #TODO: PlotTypeResultMaker is empty, need to finish
                PlotTypeResultMaker().create_file(data=data)
        elif type == ResultType.table.value:
            # TODO: DataTypeResultMaker is empty, need to finish
            TableTypeResultMaker().create_file(data=data)
        elif type == ResultType.image.value:
            ImageTypeResultMaker().create_file(id=node_id,data=data,error=False,project_name=project_name,tool_type=tool_type,extension=extension)

