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
        
        self.edittangible()
        
        
        
        
    }
    
    func mockinfo(){
        self.mockChart(offsetx:300,offsety:300)
        var node = SKShapeNode(rect: CGRect(x: 0.0, y: 0.0, width: 800, height: 400))
        var text1 = SKLabelNode(text: "TANGIBLE INFO")
        text1.position = CGPoint(x:400,y:350)
        node.addChild(text1)
        var text2 = SKLabelNode(text: "Name: Salary rate dataset")
        text2.position = CGPoint(x:400,y:280)
        node.addChild(text2)
        var text3 = SKLabelNode(text: "Description: Salary rate of male")
        text3.position = CGPoint(x:400,y:180)
        node.addChild(text3)
        var text4 = SKLabelNode(text: "and female workers in Germany")
        text4.position = CGPoint(x:400,y:150)
        node.addChild(text4)
        
        var text5 = SKLabelNode(text: "Parameters: No parameters")
        text5.position = CGPoint(x:400,y:80)
        node.addChild(text5)
        
        self.addChild(node)
        
    }
    
    func mockChart(offsetx:CGFloat,offsety:CGFloat){
        var node3 = Node(position: CGPoint(x:500+offsetx,y:650+offsety),inp:0,out:2)
        node3.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        var node2 = Node(position: CGPoint(x:1000+offsetx,y:500+offsety),inp:1,out:1)
        node2.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        
        var node4 = Node(position: CGPoint(x:1000+offsetx,y:800+offsety),inp:1,out:1)
        node4.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        var node5 = Node(position: CGPoint(x:1600+offsetx,y:500+offsety),inp:1,out:0)
        node5.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        
        var node6 = Node(position: CGPoint(x:1600+offsetx,y:800+offsety),inp:1,out:0)
        node6.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        self.graph?.addNode(node: node2)
        self.graph?.addNode(node: node3)
        self.graph?.addNode(node: node4)
        self.graph?.addNode(node: node5)
        self.graph?.addNode(node: node6)
        node2.physicsBody?.isDynamic = false
        node3.physicsBody?.isDynamic = false
        node4.physicsBody?.isDynamic = false
        node5.physicsBody?.isDynamic = false
        node6.physicsBody?.isDynamic = false
        
        //MTKUtils.traceVisualization = true
        
        let image = NSImage(named: "pie")
        let texture = SKTexture(image: image!)
        var player = SKSpriteNode(texture: texture)
        player.position = CGPoint(x: 2000+offsetx, y: 800+offsety)
        // 4
        self.addChild(player)
        let image1 = NSImage(named: "line")
        let texture1 = SKTexture(image: image1!)
        var player1 = SKSpriteNode(texture: texture1)
        player1.position = CGPoint(x: 2000+offsetx, y: 500+offsety)
        var edge = Edge(from: CGPoint(x:1600+offsetx,y:500+offsety), to: CGPoint(x: 2000+offsetx, y: 500+offsety))
        edge.zPosition = -5
        self.addChild(edge)
        
        var edge1 = Edge(from: CGPoint(x:1600+offsetx,y:800+offsety), to: CGPoint(x: 2000+offsetx, y: 800+offsety))
        edge1.zPosition = -5
        self.addChild(edge1)
        self.addChild(player1)
        
        
        
        var text1 = SKLabelNode(text: "Salary data")
        text1.position = CGPoint(x:500+offsetx,y:800+offsety)
        scene?.addChild(text1)
        
        var text2 = SKLabelNode(text: "Filter out male data")
        text2.position = CGPoint(x:1000+offsetx,y:930+offsety)
        scene?.addChild(text2)
        
        var text3 = SKLabelNode(text: "Filter out female data")
        text3.position = CGPoint(x:1000+offsetx,y:630+offsety)
        scene?.addChild(text3)
        
        var text4 = SKLabelNode(text: "Pie chart output")
        text4.position = CGPoint(x:1600+offsetx,y:930+offsety)
        scene?.addChild(text4)
        
        var text5 = SKLabelNode(text: "Line chart output")
        text5.position = CGPoint(x:1600+offsetx,y:630+offsety)
        scene?.addChild(text5)
    }
    
    func edittangible(){
        self.mockinfo()
        let image = NSImage(named: "screenshot")
        let texture = SKTexture(image: image!)
        var player = SKSpriteNode(texture: texture)
        player.position = CGPoint(x: 1200, y: 200)
        // 4
        self.addChild(player)
        
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
//                    let node = Node(position: passiveTangible.position,inp:0,out:2)
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


