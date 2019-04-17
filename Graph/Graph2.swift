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
    
    func setActivity(activity:TraceToActivity,trace:MTKTrace,to:Arc?,from:Arc?,arc:Arc){
        activity.currentTrace = trace.uuid
        activity.edge = Edge(from: CGPoint.zero, to: CGPoint.zero)
        activity.edge?.zPosition = -2
        activity.edge?.to = to
        activity.edge?.from = from
        activity.fulcrum = arc
    }
    func inCircle(center:CGPoint?,point:CGPoint?,radius:CGFloat?)->Bool{
        if let center = center,let point = point,let radius = radius{
            let x2 = (center.x - point.x)*(center.x - point.x)
            let y2 = (center.y - point.y)*(center.y - point.y)
            return x2 + y2  < radius*radius
        }
        return false
    }
    func touchDown(trace:MTKTrace){
    
        if let scene = self.scene{
            var allNodes = scene.nodes(at:trace.position!).filter{$0 is Node}
            
            var node:Node? = nil
            if !allNodes.isEmpty{
                node = allNodes[0] as? Node
            }
            if !self.inCircle(center: node?.position, point: trace.position!, radius: 80.0){
                //print("I AM TOUCHED")
                self.arcTouchDown(trace: trace,scene:scene)
                
            } else{
                let activity = TraceToNode(node: node ?? nil, trace: trace)
            }
            // self.nodeTouchDown(event:event,scene: scene)
        }
    }
    
    func arcTouchDown(trace:MTKTrace,scene:SKScene){
        //var allNodes =
        var allArcs = scene.nodes(at:trace.position!).filter{$0 is Arc}
        if !allArcs.isEmpty{
            let arc = allArcs[0] as! Arc
            if TraceToActivity.getActivity(by: arc) == nil {
                let to:Arc? = arc.isInput ? arc:nil
                let from:Arc? = arc.isInput ? nil:arc
                let activity = TraceToActivity( from:from,to:to)
                self.setActivity(activity: activity, trace: trace, to: to,from:from,arc:arc)
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
    
    
    func touchUp(trace:MTKTrace) {
        TraceToNode.removeActivity(id: trace.uuid)
        if let scene = self.scene as? GameScene{
            var allNodes = scene.nodes(at: trace.position!).filter{!($0 is Edge) && ($0 is Arc)}
            
            if let activity = TraceToActivity.getActivity(by: trace.uuid)  {
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
                    }else {
                        self.edgeManager.removeEdge(with: activity.edge?.id)
                        TraceToActivity.removeActivity( activity:activity)
                        arc.redrawArc(with: -1)
                        arc.changeArcColor()
                    }
                }
            }
        }
    }
    
    
    func touchMove(trace:MTKTrace){
        if let scene = self.scene {
            var allNodes = scene.nodes(at:trace.position!).filter{$0 is Node}
            var position:CGPoint? = nil
            if !allNodes.isEmpty{
                position = allNodes[0].position
            }
            
            if let activity = TraceToNode.getActivity(by: trace.uuid){
                self.moveNode(node: activity.node, trace: trace)
            }
            if !self.inCircle(center: position, point: trace.position, radius: 80.0){
                if let activity = TraceToActivity.getActivity(by: trace.uuid) {
                    activity.edge?.redrawEdge(from: activity.fulcrum!.globalPos!, to: trace.position!)
                }
            }
        }
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
    
    func newCoord(node:Node, trace:MTKTrace){
        if let activity = TraceToNode.getActivity(by: trace.uuid){
            let deltaX = activity.oldX - activity.trace!.position!.x
            let deltaY = activity.oldY - activity.trace!.position!.y
            activity.oldX = trace.position!.x
            activity.oldY = trace.position!.y
            activity.trace = trace
            if (abs(deltaX) > 2 || abs(deltaY) > 2) {
                node.position.x = node.position.x - deltaX
                node.position.y = node.position.y - deltaY
                self.moveArcs(node: node, deltaX: -deltaX, deltaY: -deltaY)
                self.moveTextFields(node: node, deltaX: -deltaX, deltaY: -deltaY)
            }
            
            
        }

        
        
        
    }
    
    func moveTextFields(node:Node,deltaX:CGFloat,deltaY:CGFloat){
        for item in node.controledArgsTextField{
            let point = CGPoint(x: item.frame.origin.x+deltaX, y: item.frame.origin.y+deltaY)
            item.frame.origin = point
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
    
    func moveNode(node:Node?,trace:MTKTrace){
        
        if let nodeToMove = node {
            self.newCoord(node: nodeToMove,trace: trace)
        }
    }

}
