#!/usr/local/bin/python3
import json
import sys
from Flow.FlowManager import FlowManager
from Flow.GraphStruct import Graph
from Routines.SourceFileParser import SourceFileParser

if __name__ == "__main__":
    SourceFileParser().write_to_destination()
    with open(sys.argv[1]) as f, open(sys.argv[2]) as f1:
        data = json.load(f)
        data1 = json.load(f1)
        graph = Graph(data)
        components = graph.graph_components()
        flow_manager = FlowManager()
        flow_manager.populate_components(components,data,data1)
        flow_manager.run_components()





