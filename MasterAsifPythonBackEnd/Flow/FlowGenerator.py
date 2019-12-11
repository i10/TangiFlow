#
# module = __import__(module_name)
# my_class = getattr(module, class_name)
import pythonflow as pf

def get_func_dict():
    module = __import__("Routines.FuncSource",fromlist=("Routines"))
    return module.func_dict



class FlowGenerator:
    def __init__(self,graph,proj_data):

        self.graph = graph
        self.project_data = proj_data
        self.calculated_arguments = {}
        self.source_nodes = graph.get_source_nodes()
        self.middle_nodes = graph.get_middle_nodes()
        self.terminal_nodes = graph.get_terminal_nodes()
        self.caller = graph.caller

    def get_function(self,node_id):
        if "_copy" in node_id:
            index = node_id.find("_copy")
            function_key = self.project_data[node_id[0:index]]["function"]
            return get_func_dict()[function_key]
        function_key = self.project_data[node_id]["function"]
        return get_func_dict()[function_key]

    def get_arguments(self,node_id):
        controled_arguments = self.graph.arg_data[node_id]["controled_args"]
        #data_arguments = self.graph.arg_data[node_id]["data_args"]
        return {**controled_arguments}

    def process_source_funcs(self):
        for source_node in self.source_nodes:
            function_name = self.get_function(source_node)
            arguments = self.get_arguments(source_node)
            self.calculated_arguments[source_node] = function_name(**arguments,id = source_node)

    def can_calculate_node(self,node_id):
        computed_arguments = list(self.calculated_arguments.keys())
        node_arguments = self.graph.reverse_graph[node_id]
        result = True
        for argument in node_arguments:
            if argument not in computed_arguments:
                result = result and False
                break
        return result

    def process_middle_funcs(self):
        middle_nodes_copy = self.middle_nodes
        while middle_nodes_copy:
            for node in middle_nodes_copy:
                if self.can_calculate_node(node):
                    function_name = self.get_function(node)
                    arguments = self.get_arguments(node)
                    main_args = {}
                    for key,value in self.graph.arg_data[node]["main_args"].items():
                        main_args[key] = self.calculated_arguments[value]
                    self.calculated_arguments[node] = function_name(**main_args,**arguments,id=node)
                    middle_nodes_copy = [x for x in middle_nodes_copy if x != node]


    def process_terminal_funcs(self):
        for node_id in self.terminal_nodes:
            function_name = self.get_function(node_id)
            arguments = self.get_arguments(node_id)
            main_args = self.graph.arg_data[node_id]["main_args"]
            main_args_calculated = {}
            for arg in main_args:
                main_args_calculated[arg] = self.calculated_arguments[main_args[arg]]
            self.calculated_arguments[node_id] = function_name(**main_args_calculated,**arguments,id=node_id)

    def get_flow_graph(self):
        with pf.Graph() as graph:
            self.process_source_funcs()
            self.process_middle_funcs()
            self.process_terminal_funcs()
            return graph




