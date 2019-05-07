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
    func script(){
        FileHandler.shared.cleanContent(of:FileHandler.shared.resultFolderPath)
        self.extractJson(path: FileHandler.shared.graphDataPath)
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = [FileHandler.shared.mainScriptpath,
                          FileHandler.shared.graphDataPath,
                          FileHandler.shared.copyProj]
        task.launch()
        task.waitUntilExit()
    }
    
    
    func extractJson(path:String){
        var graphStruct:JSON = [:]
        var projData:JSON = [:]
        var argData:JSON = [:]
        for node in NodeManager.nodeList{
            
            var allArgs:JSON = [:]
            allArgs["main_args"] = JSON(node.inArgs)
            allArgs["controled_args"] =  (node.controlElements?.retrieveJSON()) ?? [:]
            var args:[String] = []
            for item in node.inputArcNames{
                if let i = node.inArgs[item]{
                    args.append(i)
                }
            }
            graphStruct[node.id!] = JSON(args)
//            for item in node.controledArgsTextField{
//                if !item.stringValue.isEmpty{
//                //    allArgs["controled_args"]![item.id!] = item.stringValue
//                }
//            }
//            if let button = node.button{
//                print("I AM THE NAME")
//                print(button.name)
//                allArgs["data_args"] = [button.name!:node.sourceUrl]
//
//            }
            argData[node.id!] = allArgs
        }
        projData["arg_data"] = argData
        projData["graph"] = JSON(revertGraph(graph: graphStruct))
        projData["graph_reverse"] = graphStruct
        projData["type"] = "image"
        FileHandler.shared.writeJsonContent(data: projData, to: path)
    }
    
    
    func revertGraph(graph:JSON)->JSON{
        var result:JSON = [:]
        for key in graph.dictionary!.keys{
            if !result[key].exists() {
                print("HELLO!")
                result[key]=[]
                
                
            }
            for innerkey in graph.dictionary!.keys{
                if graph[innerkey].arrayValue.contains(JSON(key)) {
                    print("HELLO")
                    result[key].arrayObject?.append(innerkey)
                    //result[key].append(innerkey)
                }
            }
        }
        return result
    }
    
    
}
