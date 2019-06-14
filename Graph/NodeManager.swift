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
    
    func addNode(node: Node){
        if self.copies.keys.contains(node.id!){
            self.copies[node.id!] =  self.copies[node.id!]! + 1
            
            node.label?.text = "\(node.alias)copy\(self.copies[node.id!]!)"
//            node.id = "\(node.id!)_copy\(self.copies[node.id!]!)"
            if var contentOfProj = FileHandler.shared.getJsonContent(of: FileHandler.shared.projectDataPath){
                contentOfProj[node.id!] = node.json!
               
                FileHandler.shared.writeJsonContent(data: contentOfProj, to: FileHandler.shared.copyProj)
            }
        } else {
            self.copies[node.id!] = 0
            if var contentOfProj = FileHandler.shared.getJsonContent(of: FileHandler.shared.projectDataPath){
                contentOfProj[node.id!] = node.json!
               
                FileHandler.shared.writeJsonContent(data: contentOfProj, to: FileHandler.shared.copyProj)
            }
        }
        
        node.playButton.name = node.id
        NodeManager.nodeList.append(node)
        
        self.scene?.addChild(node)
    }
    
    class func getNode(with id:String) -> Node?{
        if !self.nodeList.isEmpty{
            return self.nodeList.filter {$0.id == id}[0]
        }
        return nil
    }
    
    class func removeNode(with id:String){
        FileHandler.shared.removeFile(at: URL(fileURLWithPath: FileHandler.shared.resultFolderPath + "/\(id).json"))
        let node = NodeManager.getNode(with: id)
        
        if let sibling1 = (NodeManager.getNode(with: id)?.arcManager?.inputArcs.first?.edges.first?.from?.parentNode)?.id {
            for (k, v) in NodeManager.getNode(with: sibling1)!.inArgs {
                if v == id {
                    NodeManager.getNode(with: sibling1)!.inArgs[k] = nil
                }
            }
        }
        if let sibling2 = (NodeManager.getNode(with: id)?.arcManager?.outputArcs.first?.edges.first?.to?.parentNode)?.id {
            for (k, v) in NodeManager.getNode(with: sibling2)!.inArgs {
                if v == id {
                    NodeManager.getNode(with: sibling2)!.inArgs[k] = nil
                }
            }
        }
        
        for (k, v) in NodeManager.getNode(with: id)!.inArgs {
            if let sibling1 = (NodeManager.getNode(with: id)?.arcManager?.inputArcs.first?.edges.first?.from?.parentNode)?.id {
                if v == sibling1 {
                    NodeManager.getNode(with: id)!.inArgs[k] = nil
                }
            }
            
            if let sibling2 = (NodeManager.getNode(with: id)?.arcManager?.outputArcs.first?.edges.first?.to?.parentNode)?.id {
                if v == sibling2 {
                    NodeManager.getNode(with: id)!.inArgs[k] = nil
                }
            }
        }
        
        if let input = node?.arcManager?.inputArcs, let output = node?.arcManager?.outputArcs{
            for arc in input+output{
                if !arc.edges.isEmpty{
                    EdgeManager.removeEdge(with: arc.edges[0].id)
                }
            }
        }
       // for arc in node?.arcManager?.inputArcs + node?.arcManager?.outputArcs{}
        node?.removeFromParent()
        NodeManager.nodeList = NodeManager.nodeList.filter {$0.id != node?.id}
    }
}
