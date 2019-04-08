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
        if let scene = self.scene{
            var allNodes = scene.nodes(at:trace.position!).filter{$0 is Arc}
            if !allNodes.isEmpty{
                let arc = allNodes[0] as! Arc
                if TraceToActivity.getActivity(by: arc) == nil {
                    let to:Arc? = arc.isInput ? arc:nil
                    let from:Arc? = arc.isInput ? nil:arc
                    let activity = TraceToActivity( from:from,to:to)
                    self.setActivity(activity: activity, event: event, to: to,from:from,arc:arc)
                    self.edgeManager.addEdge(edge: activity.edge!)
                    arc.redrawArc(with: 1)
                    arc.addEdge(edge: activity.edge!)
                    //                    activity.edge?.redrawEdge(from: from, to: to)
                    arc.changeArcColor()
                } else{
                    //remove nodeid from list
                    let activity = TraceToActivity.getActivity(by: arc)
                    let to = activity?.to
                    let from = activity?.from
                    //from?.parentNode?.outArgs[from!.name!] =  nil
                    to?.parentNode?.inArgs[to!.name!] = nil
                    activity?.currentTrace = trace.uuid
                    if arc.isInput{
                        activity!.to = nil
                        activity?.fulcrum = activity!.from
                    }else{
                        activity!.from = nil
                        activity?.fulcrum = activity!.to
                    }
                    arc.removeEdge(edge: activity!.edge!)
                    arc.redrawArc(with: -1)
                    arc.changeArcColor()
                    activity?.edge?.redrawEdge(from: trace.position!, to: activity!.fulcrum!.globalPos!)
                }
            }
        }
        
    }
    
    
    func touchUp(event:NSEvent) {
        if let scene = self.scene as? GameScene{
            var allNodes = scene.nodes(at: event.location(in: scene)).filter{!($0 is Edge) && ($0 is Arc)}
            
            if let activity = TraceToActivity.getActivity(by: event.eventNumber)  {
                if allNodes.isEmpty{
                    self.edgeManager.removeEdge(with: activity.edge?.id)
                    TraceToActivity.removeActivity( activity:activity)
                } else{
                    //add nodeid to list
                    let arc = allNodes[0] as! Arc
                    let to = activity.to != nil ? activity.to:arc
                    let from = activity.from != nil ? activity.from:arc
                    if (arc.parent != to?.parent && (arc.isInput != to?.isInput)) || (arc.parent != from?.parent && (arc.isInput != from?.isInput)){
                        to?.parentNode?.inArgs[to!.name!] = from?.parentNode?.id
                        //from?.parentNode?.outArgs[from!.name!] = to?.parentNode?.id
                        activity.to = to
                        activity.from = from
                        activity.from?.addEdge(edge: activity.edge!)
                        activity.to?.addEdge(edge: activity.edge!)
                        activity.edge?.from = from
                        activity.edge?.to = to
                        activity.edge?.redrawEdge(from: from!.globalPos!, to: to!.globalPos!)
                        activity.currentTrace = nil
                        arc.changeArcColor()
                        arc.redrawArc(with: 1)
                    }
                }
            }
        }
    }
    
    
    func touchMove(event:NSEvent){
        if let scene = self.scene {
            var allNodes = scene.nodes(at: event.location(in: scene))
            if let activity = TraceToActivity.getActivity(by: event.eventNumber) {
                activity.edge?.redrawEdge(from: activity.fulcrum!.globalPos!, to: event.location(in: scene))
            }
        }
    }
    
    func redrawArc(arc:Arc?,with:Int){
//        print("i am called")
        let parent = arc?.parent!
        arc?.redrawArc(with: with)
        parent?.addChild(arc!)
    }
    
    
    func putEdge(event:NSEvent) throws{
        if let scene = self.scene as? GameScene{
            var allNodes = scene.nodes(at: event.location(in: scene)).filter{($0 is Arc)}
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
        if (abs(deltaX) > 2 || abs(deltaY) > 2) {
            node.position.x = node.position.x + deltaX
            node.position.y = node.position.y + deltaY
            self.moveArcs(node: node, deltaX: deltaX, deltaY: deltaY)
        }
        
    }
    
    func moveArcs(node:Node,deltaX:CGFloat,deltaY:CGFloat){
        for item in node.arcManager!.inputArcs + node.arcManager!.outputArcs {
            let point = CGPoint(x: (item.globalPos?.x)! + deltaX, y: (item.globalPos?.y)! + deltaY)
            item.globalPos = point
            if item.isInput{
                for item1 in item.edges{
                    item1.redrawEdge(from: (item1.fromPoint)!, to: item.globalPos!)
                }
            } else {
                for item1 in item.edges{
                    item1.redrawEdge(from: item.globalPos!, to: (item1.toPoint)!)
                }
            }
        }
    }
    
    func moveNode(node:Node?,pos:CGPoint){
        
        if let nodeToMove = node {
            self.newCoord(node: nodeToMove, pos: pos)
        }
    }

}
