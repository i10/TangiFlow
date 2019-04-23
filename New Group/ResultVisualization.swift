//
//  ResultVisualization.swift
//  backendtest
//
//  Created by Asif Mayilli on 4/13/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation
import SpriteKit
class ResultVisualization{
    static var globalResultNodes:[SKNode] = []
    
    func cleanResults(){
        for item in ResultVisualization.globalResultNodes{
            item.removeFromParent()
        }
        ResultVisualization.globalResultNodes = []
    }
    
    func getResults(){
        self.cleanResults()
        let files = FileHandler.shared.getContent(of: FileHandler.shared.resultFolderPath)
        for file in files{
            if let json = FileHandler.shared.getJsonContent(of: file.path){
                self.addResultNodes(item: file, data: json)
            }
        }
    }
    
    
    func addResultNodes(item:URL,data:Dictionary<String, AnyObject>){
        let lastIndex = item.lastPathComponent.lastIndex(of: ".")
        if let node = NodeManager.getNode(with: String(item.lastPathComponent[..<lastIndex!])){
            var resultNode:SKNode?
            if let error = data["error"] as? Int {
                if  error == 0 {
                    if data["type"] as! String == "image"{
                        resultNode = ImageTypeResultNode(data: data)
                    }else if data["type"] as! String == "generic"{
                        resultNode = GenericTypeResultNode(data:data["data"] as! String)
                    }
                } else {
                    resultNode = GenericTypeResultNode(data: data["data"] as! String)
                }
                if let result = resultNode{
                    ResultVisualization.globalResultNodes.append(result)
                    node.addChild(result)
                }
            }
        }
    }
    
}

