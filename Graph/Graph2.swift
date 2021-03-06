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
    
    
    //each touch event which deals with connecting two arcs creates activity object which stores information about to which arc touch is related
    func setActivity(activity:TraceToActivity,trace:MTKTrace,to:Arc?,from:Arc?,arc:Arc){
        activity.currentTrace = trace.uuid
        activity.edge = Edge(from: CGPoint.zero, to: CGPoint.zero)
        activity.edge?.zPosition = -2
        activity.edge?.to = to
        activity.edge?.from = from
        activity.fulcrum = arc
    }
    
    //this function returns boolean value wether point is in bounds of circle with given center and radius or not
    //
    func inCircle(center:CGPoint?,point:CGPoint?,radius:CGFloat?)->Bool{
        if let center = center,let point = point,let radius = radius{
            let x2 = (center.x - point.x)*(center.x - point.x)
            let y2 = (center.y - point.y)*(center.y - point.y)
            return x2 + y2  <= radius*radius
        }
        return false
    }
    
    //this function returns boolean value wether point is in bounds of ring with given center, inner radius and outer radius
    func inRing(center:CGPoint?,point:CGPoint?,radiusIn:CGFloat?,radiusOut:CGFloat?)->Bool{
        if let center = center,let point = point,let radiusIn = radiusIn, let radiusOut = radiusOut{
            let x2 = (center.x - point.x)*(center.x - point.x)
            let y2 = (center.y - point.y)*(center.y - point.y)
            return radiusIn*radiusIn <= x2 + y2 && x2 + y2 <= radiusOut*radiusOut
        }
        return false
    }
    
    //this function handles general touch down events
    func touchDown(trace:MTKTrace){
        if let scene = self.scene{
            var allNodes = scene.nodes(at:trace.position!).filter{$0 is Node}
            var sliderButton = scene.nodes(at: trace.position!).filter{$0.name == "sliderButton"}
            print(sliderButton)
            //if we are touching slider SliderActivity should take over and handle changing the value of slider
            if !sliderButton.isEmpty{
                let activity = SliderActivity(trace: trace, slider: sliderButton[0].parent?.parent as! Slider)
                return
            }
            var node:Node? = nil
            //otherwise if we are touching body of the node we should handle node touchdown
            for item in allNodes{
                if self.inCircle(center: item.position, point: trace.position, radius: 100){
                    node = item as? Node
                }
            }
            if (node == nil ){
                //print("I AM TOUCHED")
                self.arcTouchDown(trace: trace,scene:scene)
                
            } else{
                _ = TraceToNode(node: node ?? nil, trace: trace)
            }
        }
    }
    
    //this function handles touch  down events on arcs of nodes
    func arcTouchDown(trace:MTKTrace,scene:SKScene){
        var allArcs = scene.nodes(at:trace.position!).filter{$0 is Arc}
        if !allArcs.isEmpty{
            let arc = allArcs[0] as! Arc
            //if touch down event happens on arc of the node it creates an instance of TraceToActivity 
            //or returns existing TraceToActivity event
            if  self.inRing(center: arc.parentNode?.position, point: trace.position, radiusIn: 110, radiusOut: 140){
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
    
    //this function handles general touch up events
    func touchUp(trace:MTKTrace) {
        guard let scene = self.scene as? GameScene else {return}
        guard let activity = TraceToActivity.getActivity(by: trace.uuid) else{return}
        var allNodes = scene.nodes(at: trace.position!).filter{!($0 is Edge) && ($0 is Arc)}
        var sliderButton = scene.nodes(at: trace.position!).filter{$0.name == "sliderButton"}
        //if touch up appears from slide bar it removes activities related to that slide bar
        if !sliderButton.isEmpty{
            SliderActivity.removeActivity(id: trace.uuid)
            return
        }
        //if location of touch point is empty just delete any activity
        //otherwise if it is Arc check if an edge is being dragged to that arc if yes connect edge to the arc
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
    
    //this function handles touch dragging events
    func touchMove(trace:MTKTrace){
        guard let scene = self.scene else {return}
        var allNodes = scene.nodes(at:trace.position!).filter{$0 is Node}
        
        //if move action is happening on slider button calculate the value of slider
            if let activity = SliderActivity.getActivity(by: trace.uuid){
                let deltaX = activity.oldX - activity.trace!.position!.x
               
                activity.oldX = activity.trace!.position!.x
                activity.oldY = activity.trace!.position!.y
                activity.trace = trace
                if (abs(deltaX) > 0 ) {
                    if activity.slider!.button.position.x - deltaX > -80 && activity.slider!.button.position.x - deltaX < 80{
                        activity.slider!.button.position.x = activity.slider!.button.position.x - deltaX
                        (activity.slider as! Slider).countValue()
                        
                    }
                    

                }
                return
            }

        var position:CGPoint? = nil
        if !allNodes.isEmpty{
            position = allNodes[0].position
        }
        //if finger is placed on the body of node then it is moving node action and we need to handle node movement
        if let activity = TraceToNode.getActivity(by: trace.uuid){
            self.moveNode(node: activity.node!, trace: trace)
        }
        if !self.inCircle(center: position, point: trace.position, radius: 60){
            if let activity = TraceToActivity.getActivity(by: trace.uuid) {
                activity.edge?.redrawEdge(from: activity.fulcrum?.globalPos, to: trace.position)
            }
        }
    }

    //this funtion connects two arcs if it is possible otherwise it throws ArcIsFull.CanNotAddEdge exception
    func putEdge(trace:MTKTrace) throws{
        Logger.shared.logWrite(message: "Put edge with trace id \(trace.uuid)")
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
        Logger.shared.logWrite(message: "Move node \(node.id!) with trace id \(trace.uuid)")
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
    
    //Since text fields are not MTKScene objects and are subclasses of regular NSTextField 
    //when we move nodes text fields assigned to the node does not move and we have to handle it separately
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
