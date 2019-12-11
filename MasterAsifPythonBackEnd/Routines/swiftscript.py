import ast
import json
import sys

source_file_name = sys.argv[1]
destination_file_name = sys.argv[2]

#print(inspect.getfullargspec(Subroutines.func2))
with open(source_file_name, 'r') as source, \
        open(destination_file_name, 'w') as destination:
    tree = ast.parse(source.read())
    fields = list(ast.iter_fields(tree))[0][1]
    list_of_lines = []
    for item in fields:
        func_dict = {}
        if isinstance(item, ast.FunctionDef):
            main_args = []
            control_args = []
            for item1 in item.args.args:
                #print(item1.arg)
                #print(str(item1.arg))
                if "control" in str(item1.arg):
                    control_args.append(item1.arg)
                else:
                    main_args.append(item1.arg)
            func_dict[item.name] = {"main_args":main_args,\
                                    "controled_args":control_args}
            list_of_lines.append(func_dict)
    dict_of_funcs = {"funcs":list_of_lines}
    json.dump(dict_of_funcs,destination)





{"func1":{"main_args":[],"control_args":[]}}