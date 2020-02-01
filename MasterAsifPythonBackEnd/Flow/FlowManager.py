from Flow.FlowGenerator import FlowGenerator
from Flow.GraphStruct import Graph
from Routines import Decorators
from PythonToSwift.BackToSwift import BackToSwift
import Config

class FlowManager:
    #this function creates smaller graph structures from components of graph
    def populate_components(self,components,graph_data,project_data):
        self.components_flows = []
        for component in components:
            #we iterate through all smaller components of graph and create dictionary which stores all information about that smaller graph
            sub_graph = {"graph": {}, "graph_reverse": {}, "type": "","arg_data":{},"caller":""}
            for key in component.keys():
                sub_graph["graph"][key] = graph_data["graph"][key]
                sub_graph["graph_reverse"][key] = graph_data["graph_reverse"][key]
                sub_graph["caller"] = graph_data["caller"]
                #sub_graph["config"] = data["config"]
                sub_graph["arg_data"] = graph_data["arg_data"]
                Config.Config.project_type = project_data["config"]["type"]
                Config.Config.data_processing_tool = project_data["config"]["tool_type"]
            self.components_flows.append(FlowGenerator(Graph(sub_graph), project_data))

    #this function runs components of graph which processes data passing through graph
    def run_components(self):
        for flow in self.components_flows:
            #we iterate through components and find out which component was called by user from UI
            #Then using BackToSwift module we create results as JSON files
            terminal = flow.terminal_nodes
            middle = flow.middle_nodes
            start = flow.source_nodes
            if flow.caller in terminal + middle + start:
                graph = flow.get_flow_graph()
                try:
                    graph(flow.calculated_arguments[flow.caller])
                except AttributeError as e:
                    print("___________")
                    print(e.__class__)
                    BackToSwift().prepare_data(error=True, data="No image chosen for source node! Please choose image!", node_id=flow.caller)
                    raise
                except TypeError as e:
                    BackToSwift().prepare_data(error=True, data="There is no input image to this node!", node_id=flow.caller)
                    raise

            # terminal = flow.terminal_nodes
            # middle = flow.middle_nodes
            # start = flow.source_nodes
            # config = flow.project_data["config"]
            # for item in terminal + middle + start:
            #     graph = flow.get_flow_graph()
            #     try:
            #         result = graph(flow.calculated_arguments[item])
            #         back_to_swift = BackToSwift()
            #         back_to_swift.prepare_data(**config,\
            #                                    data=result,\
            #                                    node_id=item,\
            #                                    extension="jpg")
            #     except Exception as e:
            #         raise
            #         if item in terminal:
            #             BackToSwift().prepare_data(error=True, data=e.__doc__, node_id=item)





