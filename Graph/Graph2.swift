//
//  Graph2.swift
//  MasterAsif2
//
//  Created by PPI on 08.01.19.
//  Copyright © 2019 RWTH Aachen University. All rights reserved.
//

import Foundation
import SpriteKit
import MultiTouchKitSwift
class Graph2{
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
            var allNodes = scene.nodes(at: trace.position!).filter{$0 is Arc}
            if !allNodes.isEmpty{
                let arc = allNodes[0] as! Arc
                if TraceToActivity.getActivity(by: arc.id!) == nil {
                    if (allNodes[0] as! Arc).isInput {
                        let activity = TraceToActivity(id: arc.id!, from: nil, to: arc)
                        activity.currentTrace = trace.uuid
                        activity.edge = Edge(from: CGPoint.zero, to: CGPoint.zero)
                        activity.edge?.zPosition = -2
                        self.edgeManager.addEdge(edge: activity.edge!)
                        self.redrawArc(arc: activity.to!, with: 1)
                        
                        arc.addEdge(edge: activity.edge!)
                        activity.to?.changeArcColor()
                        activity.edge!.to = arc
                        activity.fulcrum = arc
                        print("put edge 1")
                       
                    } else{
                        let activity = TraceToActivity(id: arc.id!, from: allNodes[0] as? Arc, to: nil)
                        activity.currentTrace = trace.uuid
                        activity.edge = Edge(from: CGPoint.zero, to: CGPoint.zero)
                        self.edgeManager.addEdge(edge: activity.edge!)
                        activity.edge?.zPosition = -2
                        self.redrawArc(arc: activity.from!, with: 1)
                        
                        arc.addEdge(edge: activity.edge!)
                        activity.from?.changeArcColor()
                        activity.edge!.from = arc
                        activity.fulcrum = arc
                        print("put edge 2")
                    }
                } else{
                    var activity = TraceToActivity.getActivity(by: arc.id!)
                    activity?.currentTrace = trace.uuid
                    if arc.isInput{
                        activity!.to = nil
                        arc.removeEdge(edge: activity!.edge!)
                        self.redrawArc(arc: arc, with: -1)
                        arc.changeArcColor()
                        activity?.edge?.redrawEdge(from: trace.position!, to: activity!.from!.globalPos!)
                        scene.addChild(activity!.edge!)
                        activity?.fulcrum = activity!.from
                    }else{
                        activity!.from = nil
                        arc.removeEdge(edge: activity!.edge!)
                        self.redrawArc(arc: arc, with: -1)
                        arc.changeArcColor()
                        activity?.edge?.redrawEdge(from: trace.position!, to: activity!.to!.globalPos!)
                        scene.addChild(activity!.edge!)
                        activity?.fulcrum = activity!.to
                    }
                }
            }
        }
    }
    
    
    func touchUp(trace:MTKTrace) {
        if let scene = self.scene as? GameScene{
            var allNodes = scene.nodes(at: trace.position!).filter{!($0 is MTKPassiveTangible) && !($0 is Edge) && ($0 is Arc)}

            if let activity = TraceToActivity.getActivity(by: trace.uuid)  {
                if allNodes.isEmpty{
                    activity.edge?.removeFromParent()
                    activity.to?.removeEdge(edge: activity.edge!)
                    activity.from?.removeEdge(edge: activity.edge!)
                    self.edgeManager.removeEdge(with: activity.edge?.id)
                    activity.edge = nil
                    print(activity.to)
                    print(activity.from)
                    self.redrawArc(arc: activity.to, with: -1)
                    self.redrawArc(arc: activity.from, with: -1)
                    activity.to?.changeArcColor()
                    activity.from?.changeArcColor()
                    TraceToActivity.removeActivity(by:trace.uuid)
                    print("I have ")

                } else{
                    let arc = allNodes[0] as! Arc
                    
                    if let to = activity.to{
                        if arc.parent != to.parent && (arc.isInput != to.isInput){
                            activity.from = arc
                            activity.from?.addEdge(edge: activity.edge!)
                            activity.edge?.from = arc
                            activity.edge?.redrawEdge(from: activity.to!.globalPos!, to: activity.from!.globalPos!)
                            scene.addChild(activity.edge!)
                            activity.currentTrace = nil
                        }
                        
                    } else if let from = activity.from{
                        if arc.parent != from.parent && (arc.isInput != from.isInput){
                            activity.to = arc
                            activity.to?.addEdge(edge: activity.edge!)
                            activity.edge?.to = arc
                            activity.edge?.redrawEdge(from: activity.from!.globalPos!, to: activity.to!.globalPos!)
                            scene.addChild(activity.edge!)
                            activity.currentTrace = nil
                        }
                    }
                    arc.changeArcColor()
                    self.redrawArc(arc: arc, with: 1)
                }
                
                
            }
        }
        

    }
    
    
    func touchMove(trace:MTKTrace){
        if let scene = self.scene {
            var allNodes = scene.nodes(at: trace.position!).filter{!($0 is MTKPassiveTangible)}
            
            if let activity = TraceToActivity.getActivity(by: trace.uuid) {
                activity.edge?.redrawEdge(from: activity.fulcrum!.globalPos!, to: trace.position!)
                scene.addChild(activity.edge!)
            }
        }
    }
    
    func redrawArc(arc:Arc?,with:Int){
//        print("i am called")
        let parent = arc?.parent!
        arc?.redrawArc(with: with)
        parent?.addChild(arc!)
    }
    
    
    func putEdge(trace:MTKTrace) throws{
        if let scene = self.scene as? GameScene{
            var allNodes = scene.nodes(at: trace.position!).filter{($0 is Arc)}
            if let activity = TraceToActivity.getActivity(by: (allNodes[0] as! Arc).id!)  {
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
