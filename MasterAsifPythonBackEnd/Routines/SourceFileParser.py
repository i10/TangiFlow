import ast
import os
#import FuncSource
from ROOT import ROOT_DIR
class SourceFileParser:
    def __init__(self):
        #dir_path = os.path.dirname(os.path.realpath(__file__))
        self.source_file_name = "{}/Routines/Subroutines.py".format(ROOT_DIR)
        self.destination_file_name = "{}/Routines/FuncSource.py".format(ROOT_DIR)
    
    """ 
    This function creates dictionary of available function which can be used through UI using Abstract Syntax Tree of python.
    https://docs.python.org/3/library/ast.html
    
  
    Parameters: 
    fields (list): list of abstrax syntax tree elements
    
    """
    def create_dict_line(self,fields):
        line = ""
        for field in fields:
            if isinstance(field, ast.FunctionDef):
                func_name = field.__dict__['name']
                line = line + '"{}":Subroutines.{},'.format(func_name,func_name)
        return "func_dict = {{{}}}".format(line[0:-1])

    """ 
    This function writes list of functions to a dictionary in FuncSource.py file. From that file later backend calls functions
    
    """
    def write_to_destination(self):

        with open(self.destination_file_name, 'w') as destination, \
                open(self.source_file_name, 'r') as source:
            tree = ast.parse(source.read())
            fields = list(ast.iter_fields(tree))[0][1]
            destination.write("from Routines import Subroutines\n")
            destination.write(self.create_dict_line(fields))


if __name__ == "__main__":
    generate = SourceFileParser()
    generate.write_to_destination()
    #FuncSource.func_dict["func1"]("hi")
