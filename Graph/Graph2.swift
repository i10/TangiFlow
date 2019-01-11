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
                    self.edgeManager.removeEdge(with: activity.edge!.id!)
                }
                
                TraceToActivity.activityList = TraceToActivity.activityList.filter{$0.id != trace.uuid}
                print("deleting")
                print(TraceToActivity.activityList)
                
            }
        }
        print("Edges")
        print(self.edgeManager.edgeList)

    }
    
    
    func touchMove(trace:MTKTrace){
        if let scene = self.scene {
            var allNodes = scene.nodes(at: trace.position!).filter{!($0 is MTKPassiveTangible)}
            print(TraceToActivity.activityList)
            if let activity = TraceToActivity.getActivity(by: trace.uuid)  {
                if allNodes.isEmpty{
                    if activity.edge == nil{
                        var edge = Edge(from: activity.from?.globalPos ?? (activity.to?.globalPos)!, to: trace.position!)
                        activity.edge = edge
                        self.edgeManager.addEdge(edge: edge)
                        //     scene.addChild(edge)
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
                    let arcs = allNodes.filter{$0 is Arc}
                    if !arcs.isEmpty{
                        let arc = arcs[0] as! Arc
                        if activity.firstArc == 1 && arc.parent != activity.from?.parent {
                            activity.to = arc
                            self.redrawArc(arc: activity.to, with: 1)
                        }else if activity.firstArc == 2 && arc.parent != activity.to?.parent{
                            activity.from = arc
                            self.redrawArc(arc: activity.from, with: 1)
                        }
                        
                    } else{
                        if activity.firstArc == 1 && activity.to != nil {
                            self.redrawArc(arc: activity.to, with: -1)
                            activity.to = nil
                        }else if activity.firstArc == 2 && activity.from != nil {
                            self.redrawArc(arc: activity.from, with: -1)
                            activity.from = nil
                        }
                    }
                    
                }
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
}
