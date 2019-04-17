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
    var activeTextField:NSTextField?
    var keyboard:Keyboard = Keyboard()
    override func didMove(to view: SKView) {
        let fileManager = FileManager.default
        let currentPath = fileManager.currentDirectoryPath
        print("Current path: \(currentPath)")
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
        var node1:Node?
        var node2:Node?
        var node3:Node?
        
        
//        var mtkFileManager:MTKFileManager = MTKFileManager()
//        mtkFileManager.position = CGPoint(x: 400, y: 400)
//        self.addChild(mtkFileManager)
        // print(projectJson![id1]!["arguments"])
        if let tangibleData1 = projectJson?[id1]{
            
                node1 = Node(id: id1,
                             position: offsetz,
                             out:1,
                             tangibleDict:projectJson![id1]!,
                             view:view)
                
                self.graph?.addNode(node: node1!)
            
        }
        
        if let tangibleData2 = projectJson?[id2]{
            
                node2 = Node(id: id2,
                             position: offsetd,
                             out:1,
                             tangibleDict:projectJson![id2]!,
                             view:view)
                //node2?.addChild(source)
                self.graph?.addNode(node: node2!)
            
        }
        
        if let tangibleData3 = projectJson?[id3]{
           
                node3 = Node(id: id3,
                             position: offsety,
                             out:1,
                             tangibleDict:projectJson![id3]!,
                             view:view)
                self.graph?.addNode(node: node3!)
            
        }
        
        
        
        var sideMenu = SideMenu(json: projectJson ?? [:],view:view,scene:self)
        self.addChild(sideMenu)
        
        
    }
    override func setupScene() {
        graph = Graph2(scene: self)
        MTKHub.sharedHub.traceDelegate = self
        
       
        
    }
    
    func preProcessTraceSet(traceSet: Set<MTKTrace>, node: SKNode, timestamp: TimeInterval) -> Set<MTKTrace> {
        
//        var touchTraces:[MTKTrace] = []
//        var tangibleTraces:[MTKTrace] = []
//
//        for passiveTangible in self.passiveTangibles {
//            //            print("+++++AM I WORKING+++++")
//            if passiveTangible.state == .initializedAndRecognized{
//
//                if let prevZ = self.prevZ {
//                    let deltaZ = abs(prevZ - passiveTangible.zRotation)
//                    if deltaZ > 0.1 && deltaZ < 0.5{
//                        if self.start == nil {
//                            self.start = Date()
//                        }
//                        self.angle += deltaZ
//
//                    }else {
//                        self.angle = 0
//                    }
//
//
//                    if angle > 0.8 {
//                        self.start = Date()
//                        //                        print(" YEEEEEES CAN LIFT")
//                    }
//                    self.prevZ = passiveTangible.zRotation
//                }else{
//                    self.prevZ = passiveTangible.zRotation
//                }
//            } else {
//                if let start = self.start{
//                    //print("Start acquired")
//                    let end = Date()
//                    let delta = end.timeIntervalSince(start)
//                    //print(delta)
//                    if delta > 0.02 && delta < 2.0 {
//                        //print("LIIIIIIIIFT")
//                        liftcounter += 1
//                        var node = PassiveTangibleEx.getTangible(by: passiveTangible.identifier)?.node
//                        node?.removeFromParent()
//
//                    }
//                    self.start = nil
//                }
//
//                self.prevZ = nil
//                self.angle = 0
//
//            }
//            //print(liftcounter)
//
//
//
//            tangibleTraces += passiveTangible.usedTraces
////            if passiveTangible.state == .initializedAndRecognized{
////                if let tangible = PassiveTangibleEx.getTangible(by: passiveTangible.identifier){
////                    //print("===============IF BLOCK====================")
////                    tangible.checkTangibleMove()
////                    tangible.checkTraceLost()
////                    if tangible.canMove{
////                        // print("i am on move")
////                        self.graph?.moveNode(node: tangible.node, pos: passiveTangible.position)
////                        //                            self.graph?.touchMoved(toPoint: passiveTangible.position)
////                        //                            self.graph?.touchUp(atPoint: passiveTangible.position)
////                    }
////                }else{
////                    //print("===============ELSE BLOCK====================")
////                    var tangible = PassiveTangibleEx(tangible: passiveTangible)
////                    let node = Node(position: passiveTangible.position)
////                    tangible.node = node
////                    //self.tangibleToNode[passiveTangible.identifier] = node
////                    self.graph?.addNode(node: node)
////                }
////            }
//
//        }
//        touchTraces = traceSet.filter{!tangibleTraces.contains($0) }
//
//        for trace in touchTraces{
//            if trace.state == MTKUtils.MTKTraceState.beginningTrace{
//                self.traceCall[trace.uuid] = 0
//            }
//            else if trace.state == MTKUtils.MTKTraceState.movingTrace{
//                if trace.beginTimestamp!.distance(to: trace.timestamp!) > 1.0  && self.traceCall[trace.uuid] != 1{
//                    graph?.touchDown(trace: trace)
//                    self.traceCall[trace.uuid] = 1
//                    print("worked one time")
//                } else if trace.beginTimestamp!.distance(to: trace.timestamp!) > 1.0 && self.traceCall[trace.uuid] == 1{
//                    graph?.touchMove(trace: trace)
//                }
//            } else if trace.state == MTKUtils.MTKTraceState.endingTrace{
//                graph?.touchUp(trace: trace)
//            }
//                //           } else if trace.state == MTKUtils.MTKTraceState.movingTrace{
//                //               print("")
//
//        }
        
        
        
        
        
        
//
//              //  for passiveTangible in self.passiveTangibles {
//              //      //print(passiveTangible.state)
//              //      //print(traceSet)
//              //      if passiveTangible.state == .initializedAndRecognized{
//              //          if let tangible = PassiveTangibleEx.getTangible(by: passiveTangible.identifier){
//              //                  self.graph?.moveNode(node: tangible.node, pos: passiveTangible.position)
//              //          }else{
//              //              var tangible = PassiveTangibleEx(tangible: passiveTangible)
//              //              let node = Node(position: passiveTangible.position)
//              //              tangible.node = node
//        
//              //             self.graph?.addNode(node: node)
//              //          }
//              //      }
//
//              //  }
        for trace in traceSet{
            if trace.state == MTKUtils.MTKTraceState.beginningTrace{
                self.graph?.touchDown(trace: trace)
            }else if trace.state == MTKUtils.MTKTraceState.movingTrace{
                self.graph?.touchMove(trace: trace)
            }else{
                self.graph?.touchUp(trace: trace)
                var nodes = self.nodes(at: trace.position!)
                if !nodes.isEmpty && nodes[0].name == "bar"{
                    //print("ok")
                    let scr = ScriptRunner()
                    scr.script(nodes: self.graph?.nodeManager.nodeList ?? [])
                    let resultMaker = ResultVisualization()
                    resultMaker.getResults(graph:self.graph!)
//                    let dialogue = NSOpenPanel()
//                    dialogue.canChooseFiles = true
//                    dialogue.showsResizeIndicator = true
//                    if (dialogue.runModal() == NSApplication.ModalResponse.OK){
//                        print("MODAL")
//                    }
                    
                }
                
                let allNodes = self.graph!.nodeManager.nodeList
                var textFields:[NSTextField] = []
                for node in allNodes{
                    textFields += textFields + node.controledArgsTextField
                }
                for textField in textFields{
                    if textField.frame.origin.x < trace.position!.x && trace.position!.x < textField.frame.origin.x + 160 &&
                        textField.frame.origin.y < trace.position!.y && trace.position!.y < textField.frame.origin.y + 60{
//                        print(textFererwerewrerewrwerwerwerwerwerwewererewield)
                        self.keyboard.activeTextInput = textField
                        textField.isEnabled = true
                        textField.isEditable = true
                        textField.becomeFirstResponder()
                        textField.stringValue = ""
                        print(textField.stringValue)
                        self.keyboard.position = CGPoint(x: 1000, y: 300)
                        if self.keyboard.parent == nil {
                            self.addChild(self.keyboard)
                            self.keyboard.drawKeys()}
                            self.activeTextField = textField
                    }
                }
                //print(tf)
            }
                self.nodes(at: trace.position!)
                
        }
        
        return traceSet
    }
    
//    override func mouseDown(with event: NSEvent) {
//        print("hey")
//    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if let at = self.activeTextField{
            print(at.stringValue)
        }
        //self.keyDown(with: )
        
    }
    override func keyDown(with event: NSEvent) {
        
        print(event.keyCode)
    }
    
    override func mouseUp(with event: NSEvent) {
        print("hello hello")
    }
    
    
}


