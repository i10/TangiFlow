//
//  TraceToNode.swift
//  MasterAsif2
//
//  Created by PPI on 16.04.19.
//  Copyright © 2019 RWTH Aachen University. All rights reserved.
//

import Foundation
import MultiTouchKitSwift
class TraceToNode{
    static var nodeList:[TraceToNode] = []
    var node:Node?
    //var prevTracePosition:CGPoint?
    var oldX:CGFloat = 0.0
    var oldY:CGFloat = 0.0
    var trace:MTKTrace?
    init(node:Node?,trace:MTKTrace) {
        if let node = node{
            self.node = node
            self.trace = trace
            TraceToNode.nodeList.append(self)
            self.oldX = trace.position!.x
            self.oldY = trace.position!.y
            
        }
    }
    
    
    class func getActivity(by id:Int) -> TraceToNode?{
        let activities = TraceToNode.nodeList.filter{$0.trace?.uuid == id}
        if activities.isEmpty{return nil}
        return activities[0]
    }
    
    
    
    class func removeActivity(id:Int){
        TraceToNode.nodeList = TraceToNode.nodeList.filter{$0.trace?.uuid != id}
    }
}
