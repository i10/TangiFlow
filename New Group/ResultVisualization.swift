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
    
    init() {
    }
    
    func cleanResults(){
        for item in ResultMaker.globalResultNodes{
            item.removeFromParent()
        }
        ResultMaker.globalResultNodes = []
    }
    
    func getResults(graph:Graph2){
        let nodes = graph.nodeManager.nodeList
        self.cleanResults()
        
        let path = "/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/Files/Result"
        let fm = FileManager.default
        do {
            let directory = try fm.contentsOfDirectory(atPath: path)
            for file in directory {
                let data = try Data(contentsOf: URL(fileURLWithPath: path + "/" + file), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                       // self.assignResults(to: nodes, item: file, data: "\(jsonResult["data"]!)" )
                    //print(jsonResult["type"])
                    self.addResultNodes(to: nodes,item: file,data: jsonResult)
                    
                }
            }
        } catch {}
    }
    
    
    func addResultNodes(to nodes:[Node],item:String,data:Dictionary<String, AnyObject>){
       if  data["error"] as! Int == 0 {
            if data["type"] as! String == "image"{
                self.assignImageResults(to: nodes, item: item, data: data)
            }else if data["type"] as! String == "generic"{
                self.assignGenericResults(to: nodes, item: item, data: data["data"]! as! String)
            }
        } else {
            self.assignGenericResults(to: nodes, item: item, data: data["data"]! as! String)
        }
    }
    
    func assignGenericResults(to nodes:[Node],item:String,data:String){
        for node in nodes{
            if node.id! + ".json" == item{
                let resultNode = GenericTypeResultNode(data:data)
                ResultMaker.globalResultNodes.append(resultNode)
                node.addChild(resultNode)
            }
        }
    }
    
    func assignImageResults(to nodes:[Node],item:String,data:Dictionary<String, AnyObject>){
        for node in nodes{
            if node.id! + ".json" == item{
                let resultNode = ImageTypeResultNode(data: data)
                resultNode.position = CGPoint(x: 300, y: 0)
                ResultMaker.globalResultNodes.append(resultNode)
                node.addChild(resultNode)
            }
        }
    }
    
    
}
