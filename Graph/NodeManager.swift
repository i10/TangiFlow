//
//  NodeManager.swift
//  Test1
//
//  Created by Asif Mayilli on 11/1/18.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import SpriteKit



class NodeManager{
    var copies:[String:Int] = [:]
    static var nodeList:[Node] = []
    var scene:SKScene?
    
    func addNode(node:Node){
        if self.copies.keys.contains(node.id!){
            self.copies[node.id!] =  self.copies[node.id!]! + 1
            
            
            node.label?.text = "\(node.alias)copy\(self.copies[node.id!]!)"
            node.id = "\(node.id!)_copy\(self.copies[node.id!]!)"
            
            if var contentOfProj = FileHandler.shared.getJsonContent(of: FileHandler.shared.projectDataPath){
                contentOfProj[node.id!] = node.tangibleDict as AnyObject
                print(contentOfProj)
                FileHandler.shared.writeJsonContent(data: contentOfProj, to: FileHandler.shared.copyProj)
            }
            
        }else{
            self.copies[node.id!] = 0
        }
        
        NodeManager.nodeList.append(node)
        //node.arcManager?.scene = self.scene
        
        
        
        self.scene?.addChild(node)
    }
    
    
    
    class func getNode(with id:String) -> Node?{
        if !self.nodeList.isEmpty{
            return self.nodeList.filter {$0.id == id}[0]
        }
        return nil
    }
    
    func removeNode(with id:String){
        let node = NodeManager.getNode(with: id)
        node?.removeFromParent()
        NodeManager.nodeList = NodeManager.nodeList.filter {$0.id != node?.id}
    }
}
