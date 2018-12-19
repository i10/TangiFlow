//
//  EdgeManager.swift
//  Test1
//
//  Created by Asif Mayilli on 11/1/18.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import SpriteKit


class EdgeManager{
    var edgeList:[Edge] = []
    var scene:SKScene? = nil

    func addEdge(edge:Edge){
        self.edgeList.append(edge)
        self.scene?.addChild(edge)
        
    }
    
    
    func getEdge(by id:String)->Edge{
        return  self.edgeList.filter {$0.id == id}[0]
    }
    
    func removeEdge(with id:String){
        let edge = getEdge(by: id)
        edge.removeFromParent()
        self.edgeList = self.edgeList.filter {$0.id != id}
    }
}
