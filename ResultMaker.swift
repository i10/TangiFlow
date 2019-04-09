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
    
    func getResults(nodes:[Node]){
        var path = "/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/Files/Result"
        let fm = FileManager.default
        do {
            let items = try fm.contentsOfDirectory(atPath: path)
            for item in items {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path + "/" + item), options: .mappedIfSafe)
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                        //print(jsonResult)
                        self.assignResults(to: nodes, item: item, data: jsonResult["data"] as? String ?? "")
                    }
                } catch {}
            }
        } catch {}
    }
    
    func assignResults(to nodes:[Node],item:String,data:String){
        for node in nodes{
            if node.id! + ".json" == item{
                var resultNode = GenericTypeResultNode(data:data)
                node.addChild(resultNode)
            }
        }
    }
    
    
}
