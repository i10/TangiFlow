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
            print("dead parrot")
            print(json)
            self.getContent()
            self.extractJson(nodes: nodes, path: json)
            let task = Process()
            task.launchPath = "/usr/bin/env"
            task.arguments = ["/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/main.py",json,proj]
            task.launch()
            task.waitUntilExit()
        }
    }
    
    func getContent(){
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: URL(fileURLWithPath: "/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/Files/Result"), includingPropertiesForKeys: nil)
            // process files
            for file in fileURLs{
                try fileManager.removeItem(at: file)
            }
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
    
    func extractJson(nodes:[Node],path:String){
       
        var graphStruct:[String:[String]] = [:]
        var controledArgsDict:[String:[String]] = [:]
        var projData:[String:Any] = [:]
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
                    if item == item1.placeholderString{
                        if !item1.stringValue.isEmpty{
                            controledArgs.append(item1.stringValue)
                            
                        }
                    }
                }
               
            }
            controledArgsDict[node.id!] = controledArgs
            if let imgData = node.sourceData as? ImageTypeResultNode{
                projData["imageurl"] = imgData.url
            }
            
        }
        print(controledArgsDict)
        //self.revertGraph(graph: graphStruct)
        let manager = FileManager()
        
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
