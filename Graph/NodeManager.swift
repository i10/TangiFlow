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
    var counter = 0
    var nodeList:[Node] = []
    var selectedNode:Node?
    var movingMode:Bool = false
    var selectedArc:Arc?
    var scene:SKScene?
    var curEdge:Edge?

    
    func addNode(node:Node){
        self.nodeList.append(node)
        node.arcManager?.scene = self.scene
        self.scene?.addChild(node)
    }
    
    func removeNode(from pos:CGPoint){
        let node = getNode(at: pos)
        node?.removeFromParent()
        self.nodeList = self.nodeList.filter {$0.id != node?.id}
    }
    
    func getNode(with id:String) -> Node?{
        if !self.nodeList.isEmpty{
            return self.nodeList.filter {$0.id == id}[0]
            
        }
        return nil
    }
    
    func removeNode(with id:String){
        let node = getNode(with: id)
        node?.removeFromParent()
        self.nodeList = self.nodeList.filter {$0.id != node?.id}
    }
    
    func getNode(at pos:CGPoint)->Node?{
        if let scene = self.scene {
            for item in scene.nodes(at:pos){
                if item.parent is Node {
                        let node =  item.parent as! Node
                        return node
                }
            }
        }
        return nil
    }
    
}
