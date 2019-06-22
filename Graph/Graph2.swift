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
            return x2 + y2  <= radius*radius
        }
        return false
    }
    
    func inRing(center:CGPoint?,point:CGPoint?,radiusIn:CGFloat?,radiusOut:CGFloat?)->Bool{
        if let center = center,let point = point,let radiusIn = radiusIn, let radiusOut = radiusOut{
            let x2 = (center.x - point.x)*(center.x - point.x)
            let y2 = (center.y - point.y)*(center.y - point.y)
            return radiusIn*radiusIn <= x2 + y2 && x2 + y2 <= radiusOut*radiusOut
        }
        return false
    }
    
    
    func touchDown(trace:MTKTrace){
    
        if let scene = self.scene{
            var allNodes = scene.nodes(at:trace.position!).filter{$0 is Node}
            var sliderButton = scene.nodes(at: trace.position!).filter{$0.name == "sliderButton"}
            if !sliderButton.isEmpty{
                let activity = SliderActivity(trace: trace, slider: sliderButton[0].parent?.parent as! Slider)
                return
            }
            var node:Node? = nil
//            if !allNodes.isEmpty{
//                node = allNodes[0] as? Node
//            }
            
            for item in allNodes{
                if self.inCircle(center: item.position, point: trace.position, radius: 60){
                    node = item as? Node
                }
            }
            if (node == nil ){
                //print("I AM TOUCHED")
                self.arcTouchDown(trace: trace,scene:scene)
                
            } else{
                _ = TraceToNode(node: node ?? nil, trace: trace)
            }
            // self.nodeTouchDown(event:event,scene: scene)
        }
    }
    
    func arcTouchDown(trace:MTKTrace,scene:SKScene){
        
        var allArcs = scene.nodes(at:trace.position!).filter{$0 is Arc}
        if !allArcs.isEmpty{
            let arc = allArcs[0] as! Arc
            if  self.inRing(center: arc.parentNode?.position, point: trace.position, radiusIn: 60, radiusOut: 90){
                if TraceToActivity.getActivity(by: arc) == nil {
                    let to:Arc? = arc.isInput ? arc:nil
                    let from:Arc? = arc.isInput ? nil:arc
                    let activity = TraceToActivity( from:from,to:to)
                    self.setActivity(activity: activity, trace: trace, to: to,from:from,arc:arc)
                    self.edgeManager.addEdge(edge: activity.edge!)
                    arc.redrawArc(with: 1)
                    arc.addEdge(edge: activity.edge!)
                    arc.changeArcColor()
                } else{
                    let activity = TraceToActivity.getActivity(by: arc)
                    let to = activity?.to
                    let from = activity?.from
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
                    activity?.edge?.redrawEdge(from: trace.position, to: activity?.fulcrum?.globalPos ?? nil)
                }
            }
            
        }
    }
    
    
    func touchUp(trace:MTKTrace) {
        guard let scene = self.scene as? GameScene else {return}
        guard let activity = TraceToActivity.getActivity(by: trace.uuid) else{return}
        var allNodes = scene.nodes(at: trace.position!).filter{!($0 is Edge) && ($0 is Arc)}
        var sliderButton = scene.nodes(at: trace.position!).filter{$0.name == "sliderButton"}
        if !sliderButton.isEmpty{
            SliderActivity.removeActivity(id: trace.uuid)
            return
        }
        if allNodes.isEmpty{
            EdgeManager.removeEdge(with: activity.edge?.id)
            TraceToActivity.removeActivity( activity:activity)
        } else{
            let arc = allNodes[0] as! Arc
            let to = activity.to != nil ? activity.to:arc
            let from = activity.from != nil ? activity.from:arc
            if from?.parentNode != to?.parentNode && from?.isInput != to?.isInput && arc.canAdd{
                to?.parentNode?.inArgs[to!.name!] = from?.parentNode?.id
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
            } else {
                EdgeManager.removeEdge(with: activity.edge?.id)
                TraceToActivity.removeActivity( activity:activity)
                arc.redrawArc(with: -1)
                arc.changeArcColor()
            }
        }
    }
    
    
    func touchMove(trace:MTKTrace){
        guard let scene = self.scene else {return}
        var allNodes = scene.nodes(at:trace.position!).filter{$0 is Node}
        
        //if !sliderButton.isEmpty{
            if let activity = SliderActivity.getActivity(by: trace.uuid){
                let deltaX = activity.oldX - activity.trace!.position!.x
               
                activity.oldX = activity.trace!.position!.x
                activity.oldY = activity.trace!.position!.y
                activity.trace = trace
                if (abs(deltaX) > 0 ) {
                    if activity.slider!.button.position.x - deltaX > -60 && activity.slider!.button.position.x - deltaX < 60{
                        activity.slider!.button.position.x = activity.slider!.button.position.x - deltaX
                        (activity.slider as! Slider).countValue()
                        
                        if let node = (activity.slider!.parent as? Node), let assignedTo = node.assignedTo {
                            for sub in assignedTo.children {
                                if sub is Slider {
                                    (sub as! Slider).button.position.x = activity.slider!.button.position.x
                                    (sub as! Slider).countValue()
                                }
                            }
                        }
                        
                    }
                    
                    //sliderButton[0].position.y = sliderButton[0].position.y - deltaY
                    //self.moveArcs(node: node, deltaX: -deltaX, deltaY: -deltaY)
                    //self.moveTextFields(node: node, deltaX: -deltaX, deltaY: -deltaY)
                }
                return
            }
          //  return
        //}
        var position:CGPoint? = nil
        if !allNodes.isEmpty{
            position = allNodes[0].position
        }
//        if let activity = TraceToNode.getActivity(by: trace.uuid){
//            self.moveNode(node: activity.node!, trace: trace)
//        }
        if !self.inCircle(center: position, point: trace.position, radius: 60){
            if let activity = TraceToActivity.getActivity(by: trace.uuid) {
                activity.edge?.redrawEdge(from: activity.fulcrum?.globalPos, to: trace.position)
            }
        }
    }

    
    func putEdge(trace:MTKTrace) throws{
        guard let scene = self.scene as? GameScene else {return}
        var allNodes = scene.nodes(at: trace.position!).filter{($0 is Arc)}
        guard let activity = TraceToActivity.getActivity(by: (allNodes[0] as! Arc).id!) else { return }
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
    
    func moveNode(node:Node, trace:MTKTrace){
        guard let activity = TraceToNode.getActivity(by: trace.uuid) else {return}
        let deltaX = activity.oldX - activity.trace!.position!.x
        let deltaY = activity.oldY - activity.trace!.position!.y
        activity.oldX = activity.trace!.position!.x
        activity.oldY = activity.trace!.position!.y
        activity.trace = trace
        if (abs(deltaX) > 0 || abs(deltaY) > 0) {
            node.position.x = node.position.x - deltaX
            node.position.y = node.position.y - deltaY
            self.moveArcs(node: node, deltaX: -deltaX, deltaY: -deltaY)
            self.moveTextFields(node: node, deltaX: -deltaX, deltaY: -deltaY)
        }
    }
    
    func moveTextFields(node:Node,deltaX:CGFloat,deltaY:CGFloat){
        if let controlElements = node.controlElements {
            for item in (controlElements.textFields){
                let point = CGPoint(x: item.frame.origin.x+deltaX, y: item.frame.origin.y+deltaY)
                item.frame.origin = point
            }
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

}
