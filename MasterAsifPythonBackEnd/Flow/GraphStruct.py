class Graph:
    def __init__(self,json_data):
        try:
            self.arg_data = json_data["arg_data"]
            self.caller = json_data["caller"]
            self.graph = json_data["graph"]
            self.reverse_graph = json_data["graph_reverse"]
        except ValueError as e:
            print(e)
            raise


    #returns all nodes of graph which don't have output edges
    def get_terminal_nodes(self)->dict:
        terminal = []
        for key,value in self.graph.items():
            if not value:
                terminal.append(key)
        return terminal

     #returns all nodes of graph which don't have input edges
    def get_source_nodes(self)->dict:
        source = []
        for key, value in self.reverse_graph.items():
            if not value:
                source.append(key)
        return source
    #returns nodes which have input and output edges
    def get_middle_nodes(self)->dict:
        terminal = self.get_terminal_nodes()
        source = self.get_source_nodes()
        middle = []
        for key, value in self.reverse_graph.items():
            if not key in terminal and not key in source:
                middle.append(key)
        return middle
    
    #implementation of Breadth First Search algorithm. Finds path from node s
    #https://en.wikipedia.org/wiki/Breadth-first_search
    def BFS(self,s,graph):
        visited = {}
        for key in self.graph.keys():
            visited[key] = False
        queue = []

        queue.append(s)
        visited[s] = True

        while queue:
            s = queue.pop(0)
            for i in graph[s]:
                if visited[i] == False:
                    queue.append(i)
                    visited[i] = True

        return visited
    
    #returns non-oriented version of the graph
    def oriented_to_non(self):
        import copy
        new_graph = copy.deepcopy(self.graph) #dict(self.graph)
        for key in self.graph.keys():
            for node in self.graph[key]:
                if key not in new_graph[node]:
                    new_graph[node].append(key)

        return new_graph

    def len_filter(self,item):
        return len(item.items()) > 1
    
    
    #this function decomposes the graph into components
    #https://en.wikipedia.org/wiki/Component_(graph_theory)
    def graph_components(self):
        components = []
        non_or_graph = self.oriented_to_non()
        nodes = list(non_or_graph.keys())
        while nodes:
            visited = self.BFS(nodes[0],non_or_graph)
            sub_graph = {}
            for key,value in visited.items():
                if value:
                    sub_graph[key] = self.graph[key]
                    nodes.remove(key)
            components.append(sub_graph)

        return components



