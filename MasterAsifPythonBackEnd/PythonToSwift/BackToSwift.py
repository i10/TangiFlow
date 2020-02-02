from Enums import *
from PythonToSwift.ResultMaker.GenericTypeResultMaker import GenericResultMaker
from PythonToSwift.ResultMaker.PlotTypeResultMaker import PlotTypeResultMaker
from PythonToSwift.ResultMaker.TableTypeResultMaker import TableTypeResultMaker
from PythonToSwift.ResultMaker.ImageTypeResultMaker import ImageTypeResultMaker
class PlotTypeNotProvided(Exception):
    pass

class BackToSwift:
    result_maker = None
    """ 
    This function handles file creation for all data types
  
    Parameters: 
    node_id (str): id of the node
    
    type (ResultType): which type of data node represents
    
    data: result data which should be displayed. In case no data available leave it None
    
    error (str): in case of exception error message of exception should be provided
    
    tool_type (str): different libraries can have different ways of saving data. 
                     In our base app  we use cv2 and Pillow for image editing and they save files differently. 
                     To handle this we provide which tool we are using. 
    extension (str): extension of the result image, audio or other media file
    """
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

