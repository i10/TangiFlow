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
        var offsetx = 100
        var offsety = 100
        
        var node1 = Node(position: CGPoint(x:500+offsetx,y:650+offsety),inp:0,out:2)
        node1.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        
        var node2 = Node(position: CGPoint(x:1000+offsetx,y:500+offsety),inp:1,out:1)
        node2.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        
        var node3 = Node(position: CGPoint(x:1000+offsetx,y:800+offsety),inp:1,out:1)
        node3.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        
        var node4 = Node(position: CGPoint(x:1600+offsetx,y:500+offsety),inp:1,out:0)
        node4.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        
        var node5 = Node(position: CGPoint(x:1600+offsetx,y:800+offsety),inp:1,out:0)
        node5.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        
        self.graph?.addNode(node: node1)
        self.graph?.addNode(node: node2)
        self.graph?.addNode(node: node3)
        self.graph?.addNode(node: node4)
        self.graph?.addNode(node: node5)
        
        node1.physicsBody?.isDynamic = false
        node2.physicsBody?.isDynamic = false
        node3.physicsBody?.isDynamic = false
        node4.physicsBody?.isDynamic = false
        node5.physicsBody?.isDynamic = false
        node4.terminal = true
        node5.terminal = true
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
//            if passiveTangible.state == .initializedAndRecognized{
//                if let tangible = PassiveTangibleEx.getTangible(by: passiveTangible.identifier){
//                    //print("===============IF BLOCK====================")
//                    tangible.checkTangibleMove()
//                    tangible.checkTraceLost()
//                    if tangible.canMove{
//                        // print("i am on move")
//                        self.graph?.moveNode(node: tangible.node, pos: passiveTangible.position)
//                        //                            self.graph?.touchMoved(toPoint: passiveTangible.position)
//                        //                            self.graph?.touchUp(atPoint: passiveTangible.position)
//                    }
//                }else{
//                    //print("===============ELSE BLOCK====================")
//                    var tangible = PassiveTangibleEx(tangible: passiveTangible)
//                    let node = Node(position: passiveTangible.position)
//                    tangible.node = node
//                    //self.tangibleToNode[passiveTangible.identifier] = node
//                    self.graph?.addNode(node: node)
//                }
//            }
            
        }
        touchTraces = traceSet.filter{!tangibleTraces.contains($0) }
        
        for trace in touchTraces{
            if trace.state == MTKUtils.MTKTraceState.beginningTrace{
                self.traceCall[trace.uuid] = 0
            }
            else if trace.state == MTKUtils.MTKTraceState.movingTrace{
                if trace.beginTimestamp!.distance(to: trace.timestamp!) > 1.0  && self.traceCall[trace.uuid] != 1{
                    graph?.touchDown(trace: trace)
                    self.traceCall[trace.uuid] = 1
                    print("worked one time")
                } else if trace.beginTimestamp!.distance(to: trace.timestamp!) > 1.0 && self.traceCall[trace.uuid] == 1{
                    graph?.touchMove(trace: trace)
                }
            } else if trace.state == MTKUtils.MTKTraceState.endingTrace{
                graph?.touchUp(trace: trace)
            }
                //           } else if trace.state == MTKUtils.MTKTraceState.movingTrace{
                //               print("")
            
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
        var nodes = self.children.filter{$0 is Node}
        nodes = nodes.filter{($0 as! Node).terminal}
        for item in nodes{
          print(crawl(node: item as! Node))
        }
        print("=============================")
        
        
    }
    
    
    func crawl(node:Node,my_list:[Node]=[])->[Node]{
        var my_list_copy = my_list
        
        my_list_copy.append(node)
        for item in node.arcManager!.inputArcs{
            if !item.edges.isEmpty{
                return crawl(node:(item.edges[0].from?.parent as! Node),my_list: my_list_copy)
            }
    
        }
        return my_list_copy
    }
}


