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
            print("Got nodes")
            print(TraceToActivity.activityList)
            if let activity = TraceToActivity.getActivity(by: trace.uuid)  {
                print("got activity")
                if activity.from != nil && activity.to != nil {
                    self.putEdge(trace: trace)
                }else {
                    self.redrawArc(arc: activity.from, with: -1)
                    self.redrawArc(arc: activity.to, with: -1)
                }
                
                
                
                
//                if let from = activity.from{
//                    self.redrawArc(arc: from, with: -1)
//                    print("either this")
//                }else{
//                    self.redrawArc(arc: activity.to, with: -1)
//                    print("or this")
//                }
            }
        }
    }
    
    
    func touchMove(trace:MTKTrace){
        if let scene = self.scene {
            var allNodes = scene.nodes(at: trace.position!).filter{!($0 is MTKPassiveTangible)}
            print(TraceToActivity.activityList)
            if let activity = TraceToActivity.getActivity(by: trace.uuid)  {
                print("I got activities")
                if allNodes.isEmpty{
                    print("I HAVE TO DRAW")
                    if activity.edge == nil{
                        var edge = Edge(from: activity.from?.globalPos ?? (activity.to?.globalPos)!, to: trace.position!)
                        activity.edge = edge
                        scene.addChild(edge)
                        activity.fromPoint = activity.from?.globalPos
                        activity.toPoint = activity.to?.globalPos
                    }else{
                        if activity.from != nil && activity.to != nil{
                            if activity.firstArc == 1{
                                activity.edge?.redrawEdge(from: activity.from!.globalPos! , to: trace.position!)
                                scene.addChild(activity.edge!)
                            }else if activity.firstArc == 2 {
                                activity.edge?.redrawEdge(from: activity.to!.globalPos! , to: trace.position!)
                                scene.addChild(activity.edge!)
                            }
                        } else{
                            activity.edge?.redrawEdge(from: activity.to?.globalPos ?? activity.from!.globalPos! , to: trace.position!)
                            scene.addChild(activity.edge!)
                        }
                    }
                
                } else {
                    if activity.edge != nil{
                    activity.edge?.redrawEdge(from: activity.fromPoint ?? activity.toPoint!, to: trace.position!)
                        scene.addChild(activity.edge!)}
//                    if allNodes.count == 1 {
//                        print("I should wotk")
//                        print(allNodes[0])
//                        activity.edge?.redrawEdge(from: activity.fromPoint ?? activity.toPoint!, to: trace.position!)
//                        scene.addChild(activity.edge!)
//                        //                    if !(allNodes[0] is Arc) && !(allNodes[0] is Node){
//                        //                        activity.edge?.redrawEdge(from: activity.fromPoint ?? activity.toPoint!, to: trace.position!)
//                        //                        scene.addChild(activity.edge!)
//                        //                    }
//
//                    } else if allNodes.count > 1{
//                        print("I am wirking")
//                        if (allNodes[1] is Arc) {
//                            if activity.from != nil {
//                                if (allNodes[1] as! Arc).isInput{
//                                    activity.to = allNodes[1] as! Arc
//                                    self.redrawArc(arc: activity.to, with: 1)
//                                }
//                            } else{
//
//                            }
//                        }
//                    }
                    
                }
                
                
                
                
               
            }
        }
    }
    
    func redrawArc(arc:Arc?,with:Int){
                let parent = arc?.parent!
                arc?.redrawArc(with: with)
                parent?.addChild(arc!)
            }
    
    
    func putEdge(trace:MTKTrace){
        if let scene = self.scene as? GameScene{
            if let activity = TraceToActivity.getActivity(by: trace.uuid)  {
                activity.from?.addEdge(edge: activity.edge!)
                activity.to?.addEdge(edge: activity.edge!)
                activity.edge?.to = activity.to!
                activity.edge?.from = activity.from!
                activity.edge?.zPosition = -2
                scene.graph?.edgeManager.addEdge(edge: activity.edge!)
            }
        }
    }
}
