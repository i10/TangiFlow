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
    var projectManager:ProjectFilesManager?
    override func didMove(to view: SKView) {
        //view.translateOrigin(to: CGPoint(x:view.frame.width/2,y:view.frame.height/2))
        //        var textFieldFrame = CGRect(origin: .zero, size: CGSize(width: 200, height: 30))
        //        var textField = NSTextField(frame: textFieldFrame)
        //        textField.setFrameOrigin(CGPoint(x:40,y:40))
        //        textField.backgroundColor = NSColor.white
        //        textField.placeholderString = "hello world"
        //        view.addSubview(textField)
        let barra = SKShapeNode(rectOf: CGSize(width: 70, height: 70))
        barra.name = "bar"
        barra.fillColor = SKColor.white
        barra.position = CGPoint(x:0,y:0)
        
        self.addChild(barra)
        graph = Graph2(scene: self)
        self.projectManager = ProjectFilesManager()
        self.projectManager?.openJson()
        // MTKHub.sharedHub.traceDelegate = self
        let offsetx =   CGPoint(x:2500,y:540)
        let offsetz =   CGPoint(x:2000,y:540)
        let offsety =  CGPoint(x:1000,y:540)
        let offsetd =  CGPoint(x:1500,y:540)
        let id1 = "PT-118.122.125"
        let id2 = "PT-127.99.88"
        let id3 = "PT-127.99.89"
        let id4 = "PT-127.99.90"
        let projectJson = self.projectManager?.projectFileJson
        // print(projectJson![id1]!["arguments"])
        if let tangibleData1 = projectJson?[id1]{
            if let args = ((tangibleData1 as! [String:Any])["arguments"]) as? [String:[String]]{
                let node1 = Node(id: id1,
                                 position: offsetx,
                                 inp:args["main_args"]!.count,
                                 out:1,
                                 tangibleDict:projectJson![id1]!,
                                 view:view)
                self.graph?.addNode(node: node1)
            }
        }
        
        if let tangibleData2 = projectJson?[id2]{
            if let args = ((tangibleData2 as! [String:Any])["arguments"]) as? [String:[String]]{
                let node2 = Node(id: id2,
                                 position: offsety,
                                 inp:args["main_args"]!.count,
                                 out:1,
                                 tangibleDict:projectJson![id2]!,
                                 view:view)
                self.graph?.addNode(node: node2)
            }
        }
        
        if let tangibleData3 = projectJson?[id3]{
            if let args = ((tangibleData3 as! [String:Any])["arguments"]) as? [String:[String]]{
                let node3 = Node(id: id3,
                                 position: offsetz,
                                 inp:args["main_args"]!.count,
                                 out:1,
                                 tangibleDict:projectJson![id3]!,
                                 view:view)
                self.graph?.addNode(node: node3)
            }
        }
        
        if let tangibleData4 = projectJson?[id4]{
            if let args = ((tangibleData4 as! [String:Any])["arguments"]) as? [String:[String]]{
                let node4 = Node(id: id4,
                                 position: offsetd,
                                 inp:args["main_args"]!.count,
                                 out:1,
                                 tangibleDict:projectJson![id4]!,
                                 view:view)
                self.graph?.addNode(node: node4)
            }
        }
    }
    
    override func setupScene() {
        graph = Graph2(scene: self)
        MTKHub.sharedHub.traceDelegate = self
       
        
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
    
    
    func crawl(node:Node,my_list:[String]=[])->[String]{
        var my_list_copy = my_list
        
        my_list_copy.append(node.id!)
        for item in node.arcManager!.inputArcs{
            if !item.edges.isEmpty{
                return crawl(node:(item.edges[0].from?.parent as! Node),my_list: my_list_copy)
            }
    
        }
        return my_list_copy
    }
}


