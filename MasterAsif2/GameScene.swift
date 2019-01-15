//
//  GameScene.swift
//  Test1
//
//  Created by Asif Mayilli on 10/30/18.
//  Copyright © 2018 Test. All rights reserved.
//

import SpriteKit

import MultiTouchKitSwift
class GameScene: MTKScene {
    var angle:CGFloat = 0.0 {
        didSet {
            if angle == 0.0 {
                start = nil
            }
        }
    }
    var isRotating:Bool = false
    var start:Date?
    var endDate:Date?
    var prevZ:CGFloat? = nil
    var curZ:CGFloat? = nil
    var tangibleToNode:[String:Node] = [:]
    var drawLineMode = false
    var startArc:Arc?
    var endArc:Arc?
    var currentDrawnEdge:Edge?
    var graph:Graph2?
    var selectedArc:Arc?
    var selectedNode:Node?
    var traceAmoving:Bool?
    var traceBmoving:Bool?
    var traceCmoving:Bool?
    var APrev:CGPoint?
    var BPrev:CGPoint?
    var CPrev:CGPoint?
    
    var result:CGFloat = 0.0
    override func setupScene() {
        graph = Graph2(scene: self)
        MTKHub.sharedHub.traceDelegate = self
        var node = Node(position: CGPoint(x:1000,y:1000))
        var node1 = Node(position: CGPoint(x:1500,y:1000))
        var node2 = Node(position: CGPoint(x:2000,y:1000))
        var node3 = Node(position: CGPoint(x:3000,y:1000))
        self.graph?.addNode(node: node)
        self.graph?.addNode(node: node1)
        self.graph?.addNode(node: node2)
        self.graph?.addNode(node: node3)
        //MTKUtils.traceVisualization = true

        
    }
    
    func preProcessTraceSet(traceSet: Set<MTKTrace>, node: SKNode, timestamp: TimeInterval) -> Set<MTKTrace> {
        var touchTraces:[MTKTrace] = []
        var tangibleTraces:[MTKTrace] = []
        
        for passiveTangible in self.passiveTangibles {
//            print("+++++AM I WORKING+++++")
            if passiveTangible.state == .initializedAndRecognized{
                
                
                if let prevZ = self.prevZ {
                    let deltaZ = abs(prevZ - passiveTangible.zRotation)
                    if deltaZ > 0.1 && deltaZ < 1.0{
                        if self.start == nil {
                            self.start = Date()
                        }
                        self.angle += deltaZ
                        
                    }
                    
                    else {
                        
                        self.angle = 0
                    }
                    

                    if angle > 0.8 {
                        
                        print(" YEEEEEES CAN LIFT")
                    }else{
                        print("NOOO CAN NOT LIFT")
                    }
                    self.prevZ = passiveTangible.zRotation
                }else{
                    self.prevZ = passiveTangible.zRotation
                }
            } else {
                print("DEINIT angle")
                print(self.angle)
                
                self.prevZ = nil
                self.angle = 0
                
            }
            
            
        
            tangibleTraces += passiveTangible.usedTraces
//                if passiveTangible.state == .initializedAndRecognized{
//                    if let tangible = PassiveTangibleEx.getTangible(by: passiveTangible.identifier){
//                        //print("===============IF BLOCK====================")
//                        tangible.checkTangibleMove()
//                        tangible.checkTraceLost()
//                        if tangible.canMove{
//                            print("i am on move")
//                            self.graph?.moveNode(node: tangible.node, pos: passiveTangible.position)
////                            self.graph?.touchMoved(toPoint: passiveTangible.position)
////                            self.graph?.touchUp(atPoint: passiveTangible.position)
//                        }
//                    }else{
//                        //print("===============ELSE BLOCK====================")
//                        var tangible = PassiveTangibleEx(tangible: passiveTangible)
//                        let node = Node(position: passiveTangible.position)
//                        tangible.node = node
//                        //self.tangibleToNode[passiveTangible.identifier] = node
//                        self.graph?.addNode(node: node)
//                    }
//                }

        }
        touchTraces = traceSet.filter{!tangibleTraces.contains($0) }
        for trace in touchTraces{
            if trace.state == MTKUtils.MTKTraceState.beginningTrace{
                graph?.touchDown(trace: trace)
           } else if trace.state == MTKUtils.MTKTraceState.movingTrace{
                graph?.touchMove(trace: trace)}
             else if trace.state == MTKUtils.MTKTraceState.endingTrace{
                graph?.touchUp(trace: trace)
            }
        }
        
        
        
        
        
        
        
//        for passiveTangible in self.passiveTangibles {
//            print(passiveTangible.state)
//            print(traceSet)
//            if passiveTangible.state == .initializedAndRecognized{
//                if let tangible = PassiveTangibleEx.getTangible(by: passiveTangible.identifier){
//                        self.graph?.moveNode(node: tangible.node, pos: passiveTangible.position)
//                }else{
//                    var tangible = PassiveTangibleEx(tangible: passiveTangible)
//                    let node = Node(position: passiveTangible.position)
//                    tangible.node = node
//
//                    self.graph?.addNode(node: node)
//                }
//            }
//
//        }
        
        return traceSet
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        
        
    }
}


