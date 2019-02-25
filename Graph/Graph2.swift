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
    
    func createActivity(arc:Arc) -> TraceToActivity{
        if arc.isInput{
            return TraceToActivity(arc: arc)
        }
        return TraceToActivity(arc: arc)
    }
    
    func createPair(arc1:Arc,arc2:Arc){
        var from = arc1.isInput ? arc2 : arc1
        var to = arc1.isInput ? arc1 : arc2
        var pair = ArcPair(from: from, to: to)
        pair.edge = self.createEdge(from:from,to:to)
        self.removeActivities(activities: [from,to])
    }
    func createEdge(from:Arc,to:Arc)->Edge{
        var edge = Edge(from: from.globalPos!, to: to.globalPos!)
        from.addEdge(edge: edge)
        to.addEdge(edge: edge)
        from.redrawArc(with: 1)
        to.redrawArc(with: 1)
        from.changeArcColor()
        to.changeArcColor()
        edge.from = from
        edge.to = to
        edge.zPosition = -2
        self.edgeManager.addEdge(edge: edge)
        return edge
    }
    func removeActivities(activities:[Arc]){
        for item in activities{
            TraceToActivity.removeActivity(by: item.id!)
        }
    }
    func removePair(pair:ArcPair){
        ArcPair.removePair(from: pair.from, to: pair.to)
        self.removeEdge(pair: pair)
    }
    func removeEdge(pair:ArcPair){
        var from = pair.from
        var to = pair.to
        var edge = pair.edge
        from.removeEdge(edge: edge!)
        to.removeEdge(edge: edge!)
        edge?.removeFromParent()
        from.redrawArc(with: -1)
        to.redrawArc(with: -1)
        from.changeArcColor()
        to.changeArcColor()
        edge = nil
    }
    func touchDown(trace:MTKTrace){
        if let scene = self.scene{
            var allNodes = scene.nodes(at: trace.position!).filter{$0 is Arc}
            if !allNodes.isEmpty {
                let arc = allNodes[0] as! Arc
                let activity = self.createActivity(arc: arc)
                print("i am working somehow")
                if arc.canAdd{
                    if let availableActivity = TraceToActivity.getAvailableActivity(isInput: !arc.isInput){
                        self.createPair(arc1: arc, arc2: availableActivity.arc)
                        print("can pair")
                    } else{
                        print("nothing to pair with")
                        print(arc.id)
                    }
                }else{
                    print("can not pair")
                    print(ArcPair.getPair(by: arc))
                    print(ArcPair.pairs)
                    if let pair = ArcPair.getPair(by:arc){
                        if let activityFrom = TraceToActivity.getActivity(by: pair.from.id!), let activityTo = TraceToActivity.getActivity(by: pair.to.id!){
                            self.removePair(pair: pair)
                            //self.removeActivities()
                            print("removing pair")
                        }                        
                    }
                }
            }
        }
    }
    
    
    func touchUp(trace:MTKTrace) {
        if let scene = self.scene as? GameScene{
            var allNodes = scene.nodes(at: trace.position!).filter{$0 is Arc}
            if !allNodes.isEmpty {
                let arc = allNodes[0] as! Arc
                if let activity = TraceToActivity.getActivity(by: arc.id!){
                    print("leftover activity")
                    TraceToActivity.removeActivity(by: arc.id!)
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
