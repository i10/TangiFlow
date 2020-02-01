#
# module = __import__(module_name)
# my_class = getattr(module, class_name)
import pythonflow as pf

#this function gets all available functions from Routines module
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
    
    #this function returns function which is associated with given node_id
    def get_function(self,node_id):
        if "_copy" in node_id:
            #nodes can have duplicates and they will have _copy suffix at the end but they are associated with the same function
            #e.g. change_contrast_copy and change_contrast are associated with the same function
            #this if part of code finds out if given node is a duplicate. If yes it finds and returns function associated with this node
            index = node_id.find("_copy")
            function_key = self.project_data[node_id[0:index]]["function"]
            return get_func_dict()[function_key]
        #if previous if statement did not work then we directly return the function associated with node
        function_key = self.project_data[node_id]["function"]
        return get_func_dict()[function_key]
    
    #this function goes through data about available arguments for function which is associated with given node_id
    #and returns dictionary of arguments
    def get_arguments(self,node_id):
        controled_arguments = self.graph.arg_data[node_id]["controled_args"]
        #data_arguments = self.graph.arg_data[node_id]["data_args"]
        return {**controled_arguments}
    
    #this function runs all functions related to source nodes
    def process_source_funcs(self):
        for source_node in self.source_nodes:
            function_name = self.get_function(source_node)
            arguments = self.get_arguments(source_node)
            self.calculated_arguments[source_node] = function_name(**arguments,id = source_node)
    
    #this function checks if current node is ready to be calculated. 
    #Since it is a graph to process data in some node we need to check if previous nodes have been processed.
    def can_calculate_node(self,node_id):
        computed_arguments = list(self.calculated_arguments.keys())
        node_arguments = self.graph.reverse_graph[node_id]
        result = True
        for argument in node_arguments:
            if argument not in computed_arguments:
                result = result and False
                break
        return result
    #this function runs all functions related to nodes which have inputs and outputs
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

    #this function runs all functions related to terminal nodes
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




