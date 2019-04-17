//
//  ResultMaker.swift
//  backendtest
//
//  Created by Asif Mayilli on 4/5/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation
import SpriteKit
class ResultMaker{
    static var globalResultNodes:[SKNode] = []
    
    init() {}
    
    
    func getResults(nodes:[Node],graph:Graph2){
        let path = "/Users/asifmayilli/PycharmProjects/dataflow/Files/Result"
        let fm = FileManager.default
        do {
            let items = try fm.contentsOfDirectory(atPath: path)
            for item in items {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path + "/" + item), options: .mappedIfSafe)
                    
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                        self.assignResults(to: nodes, item: item, data: "\(jsonResult["data"]!)" )
                    }
                } catch {}
            }
        } catch {}
    }
    
    
    func assignResults(to nodes:[Node],item:String,data:String){
        for item in ResultMaker.globalResultNodes{
            item.removeFromParent()
        }
        ResultMaker.globalResultNodes = []
        for node in nodes{
            if node.id! + ".json" == item{
                let resultNode = GenericTypeResultNode(data:data)
                ResultMaker.globalResultNodes.append(resultNode)
                node.addChild(resultNode)
            }
        }
    }
}
