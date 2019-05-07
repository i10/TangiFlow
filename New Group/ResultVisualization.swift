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
    
    
    func addResultNodes(item:URL,data:JSON){
        let lastIndex = item.lastPathComponent.lastIndex(of: ".")
        if let node = NodeManager.getNode(with: String(item.lastPathComponent[..<lastIndex!])){
            var resultNode:SKNode?
            if let error = data["error"].int {
                if  error == 0 {
                    if data["type"].stringValue == "image"{
                        resultNode = ImageTypeResultNode(data: data)
                    }else if data["type"].stringValue == "generic"{
                        resultNode = GenericTypeResultNode(data:data["data"].stringValue)
                    }
                } else {
                    resultNode = GenericTypeResultNode(data: data["data"].stringValue)
                }
                if let result = resultNode, nil == node.controlElements?.button{

                    ResultVisualization.globalResultNodes.append(result)
                    result.position = CGPoint(x: 0, y: -320)
                    node.addChild(result)
                }
            }
        }
    }
    
}

