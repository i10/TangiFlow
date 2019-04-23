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
                          FileHandler.shared.projectDataPath]
        task.launch()
        task.waitUntilExit()
    }
    
    
    func extractJson(path:String){
        var graphStruct:[String:[String]] = [:]
        var projData:[String:Any] = [:]
        var argData:[String:Any] = [:]
        for node in NodeManager.nodeList{
            
            var allArgs:[String:[String:String]] = ["main_args":[:],"controled_args":[:],"data_args":[:]]
            allArgs["main_args"] = node.inArgs
            var args:[String] = []
            for item in node.inputArcNames{
                if let i = node.inArgs[item]{
                    args.append(i)
                }
            }
            graphStruct[node.id!] = args
            for item in node.controledArgsTextField{
                if !item.stringValue.isEmpty{
                    allArgs["controled_args"]![item.placeholderString!] = item.stringValue
                }
            }
            if let button = node.button{
                print("I AM THE NAME")
                print(button.name)
                allArgs["data_args"] = [button.name!:node.sourceUrl]
                
            }
            argData[node.id!] = allArgs
        }
        projData["arg_data"] = argData
        projData["graph"] = revertGraph(graph: graphStruct)
        projData["graph_reverse"] = graphStruct
        projData["type"] = "image"
        FileHandler.shared.writeJsonContent(data: projData, to: path)
    }
    
    
    func revertGraph(graph:[String:[String]])->[String:[String]]{
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
