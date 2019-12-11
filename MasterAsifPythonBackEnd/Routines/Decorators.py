func_has_decorator = False
def hello_decorator(func):

    def wrapper(a):
        global func_has_decorator
        #print("horay",a)
        #print("Something is happening before the function is called.")
        func(4)
        func_has_decorator = True
        #print("Something is happening after the function is called.")
    return wrapper