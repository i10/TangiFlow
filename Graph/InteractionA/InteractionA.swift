//
//  InteractionA.swift
//  MasterAsif2
//
//  Created by PPI on 11.02.19.
//  Copyright © 2019 RWTH Aachen University. All rights reserved.
//

import Foundation
import MultiTouchKitSwift
class InteractionA{
    enum ArcIsFull: Error {
        case CanNotAddEdge
    }
    var nodeManager:NodeManager = NodeManager()
    var edgeManager:EdgeManager = EdgeManager()
    var scene:SKScene?
    var moveStart:Date?
    var moveEnd:Date?
    var deltaMoveT = 1.0
    
    init(scene:SKScene){
        self.scene = scene
        self.nodeManager.scene = scene
        self.edgeManager.scene = scene
    }
    
    func addNode(node: Node) {
        self.nodeManager.addNode(node: node)
    }
    
    func touchDown(trace:MTKTrace){
        if let scene = self.scene{
            var allNodes = scene.nodes(at: trace.position!).filter{!($0 is MTKPassiveTangible)}
            if !allNodes.isEmpty && allNodes[0] is Arc{
                if TraceToActivity.getActivity(by: trace.uuid) == nil {
                    if (allNodes[0] as! Arc).isInput {
                        let activity = TraceToActivity(id: trace.uuid, from: nil, to: allNodes[0] as? Arc)
                        self.redrawArc(arc: activity.to!, with: 1)
                        
                        
                    } else{
                        let activity = TraceToActivity(id: trace.uuid, from: allNodes[0] as? Arc, to: nil)
                        self.redrawArc(arc: activity.from!, with: 1)
                    }
                }
            }
        }
    }
    
    
    func touchUp(trace:MTKTrace) {
        if let scene = self.scene as? GameScene{
            var allNodes = scene.nodes(at: trace.position!).filter{!($0 is MTKPassiveTangible)}
            
            if let activity = TraceToActivity.getActivity(by: trace.uuid)  {
                if  let from = activity.from ,let to =  activity.to {
                    activity.edge?.redrawEdge(from: from.globalPos!, to: to.globalPos!)
                    do{
                        try
                            self.putEdge(trace: trace)
                    }catch{
                        print("I AM HUGE NASTY ERROR HERE")
                        self.edgeManager.removeEdge(with: activity.edge!.id!)
                    }
                    //self.putEdge(trace: trace)
                    
                } else {
                    self.redrawArc(arc: activity.from ?? activity.to, with: -1)
                    self.edgeManager.removeEdge(with: activity.edge?.id)
                }
                
                TraceToActivity.activityList = TraceToActivity.activityList.filter{$0.id != trace.uuid}
                
                
            }
        }
        
        
    }
    
    
  
    func redrawArc(arc:Arc?,with:Int){
        let parent = arc?.parent!
        arc?.redrawArc(with: with)
        parent?.addChild(arc!)
    }
    
    
    func putEdge(trace:MTKTrace) throws{
        if let scene = self.scene as? GameScene{
            if let activity = TraceToActivity.getActivity(by: trace.uuid)  {
                if activity.from!.canAdd && activity.to!.canAdd{
                    activity.from?.addEdge(edge: activity.edge!)
                    activity.to?.addEdge(edge: activity.edge!)
                    activity.edge?.to = activity.to!
                    activity.edge?.from = activity.from!
                    activity.edge?.zPosition = -2
                    scene.graph?.edgeManager.addEdge(edge: activity.edge!)
                } else {
                    throw ArcIsFull.CanNotAddEdge
                }
            }
        }
    }
    
    func newCoord(node:Node, pos:CGPoint){
        let deltaX = pos.x - node.position.x
        let deltaY = pos.y - node.position.y
        // print(CGPoint(x:deltaX,y:deltaY))
        if (abs(deltaX) > 2 || abs(deltaY) > 2) {
            node.position.x = node.position.x + deltaX
            node.position.y = node.position.y + deltaY
            self.moveArcs(node: node, deltaX: deltaX, deltaY: deltaY)
        }
        
    }
    
    func moveArcs(node:Node,deltaX:CGFloat,deltaY:CGFloat){
        for item in node.arcManager!.inputArcs + node.arcManager!.outputArcs {
            var point = CGPoint(x: (item.globalPos?.x)! + deltaX, y: (item.globalPos?.y)! + deltaY)
            item.globalPos = point
            if item.isInput{
                for item1 in item.edges{
                    item1.redrawEdge(from: (item1.fromPoint)!, to: item.globalPos!)
                    scene?.addChild(item1)
                }
            } else {
                for item1 in item.edges{
                    item1.redrawEdge(from: item.globalPos!, to: (item1.toPoint)!)
                    scene?.addChild(item1)
                }
            }
        }
    }
    
    func moveNode(node:Node?,pos:CGPoint){
        //        if self.moveStart == nil {
        //            self.moveStart = Date()
        //        }
        if let nodeToMove = node {
            
            self.newCoord(node: nodeToMove, pos: pos)
            //                if self.moveStart != nil {
            //                    self.moveEnd = Date()
            //
            //                }
            
        }
    }
}
