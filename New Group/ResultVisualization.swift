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
            print(node.name)
            var resultNode:SKNode?
            let error = data["error"].boolValue //{
                if  !error {
                    if data["type"].stringValue == "image"{
                        
                        resultNode = ImageTypeResultNode(data: data)
                    }else if data["type"].stringValue == "generic"{
                        resultNode = GenericTypeResultNode(data:data["data"].stringValue)
                    }
                    node.crawl()
                    node.status.removeFromParent()
                } else {
                    resultNode = GenericTypeResultNode(data: data["data"].stringValue)
                    node.changeBaseColor(color: SKColor(calibratedRed: 248/255.0, green: 48/255.0, blue: 56/255.0, alpha: 1.0))
                }
                if let result = resultNode, nil == node.controlElements?.button{

                    ResultVisualization.globalResultNodes.append(result)
                    node.result = result
                    if result.parent == nil {
                        node.addChild(result)
                    }
                    
                    if node.preview{
                        node.result?.isHidden = false
                        
                    } else {
                        node.result?.isHidden = true
                    }
                    
                    
                    
                    if result is ImageTypeResultNode{
                        
                        (result as! ImageTypeResultNode).reloadImage(zoom: node.zoomValue)
                        (result as! ImageTypeResultNode).setSlider()
                    } else {
                        result.position = CGPoint(x: 0, y: -370)
                    }
                    node.status.removeFromParent()
                }
            //}
        }
    }
    
}

