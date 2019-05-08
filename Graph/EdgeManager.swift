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
    static var edgeList:Set<Edge> = Set()
     var scene:SKScene? = nil

    func addEdge(edge:Edge){
            EdgeManager.edgeList.insert(edge)
            self.scene?.addChild(edge)
    }
    
    
    class func getEdge(by id:String)->Edge{
        return  self.edgeList.filter {$0.id == id}[0]
    }
    
    class func removeEdge(with id:String?){
        if let id = id {
            
            let edge = getEdge(by: id)
            TraceToActivity.removeActivity(activity: TraceToActivity.getActivity(by: edge.from))
            TraceToActivity.removeActivity(activity: TraceToActivity.getActivity(by: edge.to))
//            edge.from?.removeEdge(edge: edge)
//            edge.to?.removeEdge(edge: edge)
//            edge.from?.redrawArc(with: -1)
//            edge.to?.redrawArc(with: -1)
            //edge.removeFromParent()
                self.edgeList = self.edgeList.filter {$0.id != id}
            
            }
    }
}
