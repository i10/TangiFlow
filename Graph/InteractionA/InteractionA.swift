////
////  InteractionA.swift
////  MasterAsif2
////
////  Created by PPI on 11.02.19.
////  Copyright © 2019 RWTH Aachen University. All rights reserved.
////
//
//import Foundation
//import MultiTouchKitSwift
//class InteractionA{
//    enum ArcIsFull: Error {
//        case CanNotAddEdge
//    }
//    var nodeManager:NodeManager = NodeManager()
//    var edgeManager:EdgeManager = EdgeManager()
//    var scene:SKScene?
//    var traceToArc:[Int:Arc] = [:]
//    
//    init(scene:SKScene){
//        self.scene = scene
//        self.nodeManager.scene = scene
//        self.edgeManager.scene = scene
//    }
//    
//    func addNode(node: Node) {
//        self.nodeManager.addNode(node: node)
//    }
//    
//    func touchDown(trace:MTKTrace) {
//        if let scene = self.scene as? GameScene{
//            var allNodes = scene.nodes(at: trace.position!).filter{!($0 is MTKPassiveTangible)}
//            if !allNodes.isEmpty && allNodes[0] is Arc{
//                var pairable:[Arc] = []
//                let arc = allNodes[0] as! Arc
//                self.redrawArc(arc: arc, with: 1)
//                self.traceToArc[trace.uuid] = arc
//                for (key,value) in self.traceToArc{
//                    if value.parent != arc.parent {
//                        var edge = Edge(from: arc.globalPos! , to: value.globalPos!)
//                        if arc.canAdd && value.canAdd && (arc.isInput != value.isInput){
//                            arc.addEdge(edge: edge)
//                            value.addEdge(edge: edge)
//                            edge.to = arc
//                            edge.from = value
//           
//                            edge.zPosition = -2
//                            scene.graph?.edgeManager.addEdge(edge: edge)
//                        } else {
//                            print("no")
//                        }
//                    }
//                }
//                
//            }
//        }
//    }
//    
//    
//    func touchUp(trace:MTKTrace){
//        if let scene = self.scene{
////            var allNodes = scene.nodes(at: trace.position!).filter{!($0 is MTKPassiveTangible)}
////            if !allNodes.isEmpty && allNodes[0] is Arc{
//            
//                if let arc = traceToArc[trace.uuid]{
//                    self.redrawArc(arc: arc, with: -1)
//                    traceToArc[trace.uuid] = nil
//                }
//             
//                
//            //}
//        }
//    }
//    
//  
//    func redrawArc(arc:Arc?,with:Int){
//        let parent = arc?.parent!
//        arc?.redrawArc(with: with)
//        parent?.addChild(arc!)
//    }
//    
//    
//    func putEdge(trace:MTKTrace) throws{
//        if let scene = self.scene as? GameScene{
//            if let activity = TraceToActivity.getActivity(by: trace.uuid)  {
//                if activity.from!.canAdd && activity.to!.canAdd{
//                    activity.from?.addEdge(edge: activity.edge!)
//                    activity.to?.addEdge(edge: activity.edge!)
//                    activity.edge?.to = activity.to!
//                    activity.edge?.from = activity.from!
//                    activity.edge?.zPosition = -2
//                    scene.graph?.edgeManager.addEdge(edge: activity.edge!)
//                } else {
//                    throw ArcIsFull.CanNotAddEdge
//                }
//            }
//        }
//    }
//    
//   
//    
//  
//    
//
//}
