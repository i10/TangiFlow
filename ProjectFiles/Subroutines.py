import pythonflow as pf

from Enums import *
@pf.opmethod(length=1)
def func1():
    return 1


@pf.opmethod(length=1)
def func2(argument1=4):
    result = argument1
    return {"output_type":ResultType.generic_python,"data":result}

@pf.opmethod(length=1)
def func3(argument1):
    result = argument1
    return result*3

@pf.opmethod(length=1)
def func4(argument1=2):
    
    return argument1*2

@pf.opmethod(length=1)
def func5():
    print("I work alone")


