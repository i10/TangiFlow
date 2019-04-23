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
    static var nodeList:[Node] = []
    var scene:SKScene?
    
    func addNode(node:Node){
        NodeManager.nodeList.append(node)
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
