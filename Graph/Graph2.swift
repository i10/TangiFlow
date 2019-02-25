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
        node.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        node.physicsBody?.isDynamic = false
        self.nodeManager.addNode(node: node)
    }
    
    func shootRay(activity:TraceToActivity,arc:Arc){

        let rayStart = arc.globalPos!
        let phi = arc.zRotation - CGFloat.pi/2 + arc.angle!/2
        let rayEnd = CGPoint(x:rayStart.x + 4000 * cos(phi),
                             y:rayStart.y + 4000 * sin(phi))
        var found = false
        var endPoint = rayEnd
        scene?.physicsWorld.enumerateBodies(alongRayStart: rayStart, end: rayEnd){
            (body,point,vector,stop) in
            if !found{
                endPoint = point
                found = true
            }
        }
        
        var edge = Edge(from: rayStart, to: endPoint)
        edge.zPosition = -2
        if arc.isInput{
            activity.toAngle = phi
        }else{
            activity.fromAngle = phi
        }
        activity.edge = edge
        arc.tempEdge = edge
        arc.addEdge(edge: edge)
        self.edgeManager.addEdge(edge: edge)
    }
    
    func createActivity(arc:Arc) -> TraceToActivity{
        if arc.isInput{
            return TraceToActivity(id:arc.id!,from:nil,to:arc)
        }
        return TraceToActivity(id: arc.id!, from: arc, to: nil)
    }
    
    func aim(edge:Edge,angle:CGFloat,rotationPoint:Arc){
        if let activity = TraceToActivity.getActivity(by: edge){
            if rotationPoint.isInput{
                print("i work")
                var phi = activity.toAngle ?? CGFloat.pi/2-activity.fromAngle!
                let rayStart = rotationPoint.globalPos!
                
                let rayEnd = CGPoint(x:rayStart.x + 4000 * cos(phi),
                                     y:rayStart.y + 4000 * sin(phi))
                var found = false
                var endPoint = rayEnd
                scene?.physicsWorld.enumerateBodies(alongRayStart: rayStart, end: rayEnd){
                    (body,point,vector,stop) in
                    if !found{
                        endPoint = point
                        found = true
                    }
                }
                edge.redrawEdge(from: rayStart, to: endPoint)
                self.scene?.addChild(edge)
            }else{
                print("I WORK @")
                var phi = activity.fromAngle ?? CGFloat.pi/2-activity.toAngle!
                let rayStart = rotationPoint.globalPos!
                
                let rayEnd = CGPoint(x:rayStart.x + 4000 * cos(phi+angle),
                                     y:rayStart.y + 4000 * sin(phi+angle))
                var found = false
                var endPoint = rayEnd
                scene?.physicsWorld.enumerateBodies(alongRayStart: rayStart, end: rayEnd){
                    (body,point,vector,stop) in
                    if !found{
                        endPoint = point
                        found = true
                    }
                }
                edge.redrawEdge(from: rayStart, to: endPoint)
                self.scene?.addChild(edge)
            }
            
            
        }
    }
    
    func redrawArc(arc:Arc?,with:Int){
        let parent = arc?.parent!
        arc?.redrawArc(with: with)
        parent?.addChild(arc!)
        
    }
    
    func putEdge(activity:TraceToActivity) throws{
        if let scene = self.scene as? GameScene{
            var allNodes = scene.nodes(at:activity.edge!.toPoint!).filter{ $0 is Arc}
//            print("did i worked?")
//            print(allNodes[0] is Arc)
            if !allNodes.isEmpty {
                print("AND I?")
                var arc = allNodes[0] as! Arc
                print(activity.to)
                if arc.isInput && activity.from != nil && arc.canAdd {
                    print("return 1")
                    activity.to = arc
                    arc.addEdge(edge: activity.edge!)
                    arc.changeArcColor()
                    activity.edge?.to = activity.to
                    activity.edge?.from = activity.from
                    self.redrawArc(arc: activity.to, with: 1)
                    return
                } else if !arc.isInput && activity.to != nil && arc.canAdd{
                    print("return 2")
                    activity.from = arc
                    arc.addEdge(edge: activity.edge!)
                    activity.edge?.to = activity.to
                    activity.edge?.from = activity.from
                    self.redrawArc(arc: activity.from, with: 1)
                    return
                } else{
                    print("ERROR")
                    throw ArcIsFull.CanNotAddEdge
                }
                arc.changeArcColor()
                
            }
            throw ArcIsFull.CanNotAddEdge
        }
    }
    
    func removeEdge(activity:TraceToActivity,arc:Arc){
        activity.edge?.removeFromParent()
        self.edgeManager.removeEdge(with: activity.edge?.id)
        arc.removeEdge(edge: activity.edge!)
        activity.edge = nil
        arc.tempEdge = nil
        self.redrawArc(arc: activity.from , with: -1)
    }
    
    func touchDown(trace:MTKTrace){
        
        if let scene = self.scene as? GameScene{
            var allNodes = scene.nodes(at: trace.position!).filter{$0 is Arc}
            if !allNodes.isEmpty{
                let arc = allNodes[0] as! Arc
                if let activity = TraceToActivity.getActivity(by: arc.id!){
                    if self.poppedArcExists(node: arc.parent as! Node){
                        if (activity.from != nil) != (activity.to != nil ){
                            var allNodesAtEnd = scene.nodes(at: activity.edge!.toPoint!).filter{$0 is Arc}
                            if allNodesAtEnd.isEmpty {
                                self.removeEdge(activity: activity, arc: arc)
                                self.redrawArc(arc: arc, with: -1)
                                arc.changeArcColor()
                                TraceToActivity.removeActivity(by: activity.id!)
                            } else{
                                do{
                                    try self.putEdge(activity: activity)
                                    (arc.parent as! Node).rotationMode = false}
                                catch{
                                    print("having error")
                                }
                                
                            }
                        } else if activity.from != nil && activity.to != nil {
                            if arc.isInput{
                                (arc.parent as! Node).rotationMode = true
                                activity.from?.removeEdge(edge: activity.edge!)
                                activity.from?.changeArcColor()
                                self.redrawArc(arc: activity.from, with: -1)
                                activity.from?.tempEdge = nil
                                activity.from = nil
                                arc.tempEdge = activity.edge
                            }else{
                                (arc.parent as! Node).rotationMode = true
                                activity.to?.removeEdge(edge: activity.edge!)
                                activity.to?.changeArcColor()
                                self.redrawArc(arc: activity.to, with: -1)
                                activity.to?.tempEdge = nil
                                activity.to = nil
                                arc.tempEdge = activity.edge
                            }
                            
                        }
                    }
                } else{
                    let activity:TraceToActivity = self.createActivity(arc: arc)
                    self.redrawArc(arc: arc, with: 1)
                    arc.changeArcColor()
                    self.shootRay(activity: activity, arc: arc)
                    arc.changeArcColor()
                    (arc.parent as! Node).rotationMode = true
                }
            }
        }
    }
    

    
    func poppedArcExists(node:Node) -> Bool {
        var arcs = node.arcManager!.inputArcs + node.arcManager!.outputArcs
        var result = false
        for arc in arcs{
            result = result || arc.popped
        }
        return result
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
        if let nodeToMove = node {
                self.newCoord(node: nodeToMove, pos: pos)
            
        }
    }

}
