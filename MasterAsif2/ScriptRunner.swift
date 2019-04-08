//
//  ScriptRunner.swift
//  backendtest
//
//  Created by Asif Mayilli on 3/31/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation
import SwiftyJSON
class ScriptRunner{
    //self.scriptLabel = path
    func script(nodes:[Node]){
        if  let json = Bundle.main.path(forResource: "graph", ofType: "json"),
            let proj = Bundle.main.path(forResource:"myproj",ofType: "json"){
//            if let file = FileHandle(forWritingAtPath:"/Users/asifmayilli/PycharmProjects/dataflow/main.py") {
//                file.truncateFile(atOffset: 0)
//                file.write(data)
//
//            } else{
//
//            }
            
            self.extractJson(nodes: nodes, path: json)
            let task = Process()
            task.launchPath = "/usr/bin/env"
            task.arguments = ["/Users/asifmayilli/PycharmProjects/dataflow/main.py",json,proj]
            task.launch()
            task.waitUntilExit()
        }
    }
    
    func extractJson(nodes:[Node],path:String){
       
        var graphStruct:[String:[String]] = [:]
        var controledArgsDict:[String:[String]] = [:]
        for node in nodes{
            var args:[String] = []
            //print(node.inputArcNames)
            //print(node.inArgs)
            for item in node.inputArcNames{
                //                if node.inArgs[item] != nil {}
                if let i = node.inArgs[item]{
                    args.append(i)
                }
                //args.append(node.inArgs[item] ?? "")
            }
            graphStruct[node.id!] = args
            var controledArgs:[String] = []
            for item in node.controledArgNames{
                for item1 in node.controledArgsTextField{
                    if item == item1.id{
                        if !item1.stringValue.isEmpty{
                            controledArgs.append(item1.stringValue)
                            
                        }
                    }
                }
               
            }
            controledArgsDict[node.id!] = controledArgs
            
        }
        print(controledArgsDict)
        //self.revertGraph(graph: graphStruct)
        let manager = FileManager()
        var projData:[String:Any] = [:]
        projData["graph"] = revertGraph(graph: graphStruct)
        projData["graph_reverse"] = graphStruct
        projData["type"] = "arithmetic"
        projData["controled_args"] = controledArgsDict
        print(projData)
        let json = JSON(projData)

        let str = json.description
        let data = str.data(using: String.Encoding.utf8)!
        if let file = FileHandle(forWritingAtPath:path) {
            file.truncateFile(atOffset: 0)
            file.write(data)
            
        } else{
            
        }
        
        
    }
    
    
    func revertGraph(graph:[String:[String]])->[String:[String]]{
        //print(graph)
        var result:[String:[String]] = [:]
        for key in graph.keys{
            if result[key] == nil {result[key]=[]}
            for innerkey in graph.keys{
                if graph[innerkey]?.contains(key) ?? false{
                    result[key]?.append(innerkey)
                }
            }
        }
        return result
    }
    
    
}
