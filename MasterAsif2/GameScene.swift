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
    var counter = 0
    var liftcounter = 0
    var angle:CGFloat = 0.0
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
    var rotate = false
    var traceCall:[Int:Int] = [:]
    var result:CGFloat = 0.0
    override func setupScene() {
        graph = Graph2(scene: self)
        MTKHub.sharedHub.traceDelegate = self
        
        var node2 = Node(position: CGPoint(x:1000,y:300))
        node2.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        var node3 = Node(position: CGPoint(x:500,y:300))
        node3.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        
        self.graph?.addNode(node: node2)
        self.graph?.addNode(node: node3)
        
        node2.physicsBody?.isDynamic = false
        node3.physicsBody?.isDynamic = false
        
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
                    if deltaZ > 0.1 && deltaZ < 0.5{
                        if self.start == nil {
                            self.start = Date()
                        }
                        self.angle += deltaZ
                        
                    }else {
                        self.angle = 0
                    }
                    
                    
                    if angle > 0.8 {
                        self.start = Date()
                        //                        print(" YEEEEEES CAN LIFT")
                    }
                    self.prevZ = passiveTangible.zRotation
                }else{
                    self.prevZ = passiveTangible.zRotation
                }
            } else {
                if let start = self.start{
                    //print("Start acquired")
                    let end = Date()
                    let delta = end.timeIntervalSince(start)
                    //print(delta)
                    if delta > 0.02 && delta < 2.0 {
                        //print("LIIIIIIIIFT")
                        liftcounter += 1
                        var node = PassiveTangibleEx.getTangible(by: passiveTangible.identifier)?.node
                        node?.removeFromParent()
                        
                    }
                    self.start = nil
                }
                
                self.prevZ = nil
                self.angle = 0
                
            }
            //print(liftcounter)
            
            
            tangibleTraces += passiveTangible.usedTraces
            if passiveTangible.state == .initializedAndRecognized{
                if let tangible = PassiveTangibleEx.getTangible(by: passiveTangible.identifier){
                    //print("===============IF BLOCK====================")
                    tangible.checkTangibleMove()
                    tangible.checkTraceLost()
                    if tangible.canMove{
                        // print("i am on move")
                        self.graph?.moveNode(node: tangible.node, pos: passiveTangible.position)
                        //                            self.graph?.touchMoved(toPoint: passiveTangible.position)
                        //                            self.graph?.touchUp(atPoint: passiveTangible.position)
                    }
                }else{
                    //print("===============ELSE BLOCK====================")
                    var tangible = PassiveTangibleEx(tangible: passiveTangible)
                    let node = Node(position: passiveTangible.position)
                    tangible.node = node
                    //self.tangibleToNode[passiveTangible.identifier] = node
                    self.graph?.addNode(node: node)
                }
            }
            
        }
        touchTraces = traceSet.filter{!tangibleTraces.contains($0) }
        
        for trace in touchTraces{
            if trace.state == MTKUtils.MTKTraceState.beginningTrace{
                self.traceCall[trace.uuid] = 0
            }
            else if trace.state == MTKUtils.MTKTraceState.movingTrace{
                if trace.beginTimestamp!.distance(to: trace.timestamp!) > 1.0 && self.traceCall[trace.uuid] != 1{
                    graph?.touchDown(trace: trace)
                    self.traceCall[trace.uuid] = 1
                    print("worked one time")
                }
            }
                //           } else if trace.state == MTKUtils.MTKTraceState.movingTrace{
                //               print("")
            else if trace.state == MTKUtils.MTKTraceState.endingTrace{
                // graph?.touchUp(trace: trace)
            }
        }
        
        
        
        
        
        
        
        //        for passiveTangible in self.passiveTangibles {
        //            //print(passiveTangible.state)
        //            //print(traceSet)
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


