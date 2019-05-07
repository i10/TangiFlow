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
    var keyboard:Numpad = Numpad()
    override func didMove(to view: SKView) {
        self.view?.showsFPS = true
        self.view?.ignoresSiblingOrder = true
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
        let projectJson = self.projectManager?.projectFileJson
        var sideMenu = SideMenu(json: projectJson ?? [:],view:view,scene:self)
        self.addChild(sideMenu)
        
        var slider = Slider()
        slider.position = CGPoint(x: 3000, y: 500)
        self.addChild(slider)
        
        
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
//                    let node =  NodeManager.getNode(with: "PT-127.99.89")
//                    node?.arcManager?.addOutputArc()
                    //print("ok")
                    let scr = ScriptRunner()
                    scr.script()
                    let resultMaker = ResultVisualization()
                    resultMaker.getResults()
//                    let dialogue = NSOpenPanel()
//                    dialogue.canChooseFiles = true
//                    dialogue.showsResizeIndicator = true
//                    if (dialogue.runModal() == NSApplication.ModalResponse.OK){
//                        print("MODAL")
//                    }
                    
                }
                
                let allNodes = NodeManager.nodeList
                var textFields:[CustomTextFields] = []
                for node in allNodes{
                    if let controlElements = node.controlElements {
                        textFields += textFields + controlElements.textFields
                    }
                    
                }
                for textField in textFields{
                    if textField.frame.origin.x < trace.position!.x && trace.position!.x < textField.frame.origin.x + 160 &&
                        textField.frame.origin.y < trace.position!.y && trace.position!.y < textField.frame.origin.y + 60{
//                        print(textFererwerewrerewrwerwerwerwerwerwewererewield)
                        self.keyboard.activeTextInput = textField
                        textField.isEnabled = true
                        textField.isEditable = true
                        textField.becomeFirstResponder()
                        //textField.stringValue = ""
                       // print(textField.stringValue)
                        self.keyboard.position = CGPoint(x: textField.frame.origin.x+290, y: textField.frame.origin.y)
                        if self.keyboard.parent == nil {
                            textField.parent?.keyboard.removeFromParent()
                            textField.parent?.addChild(textField.parent!.keyboard)
                            textField.parent!.keyboard.drawKeys()
                            textField.parent?.keyboard.position = CGPoint(x: 300, y: 0)
                            }
                        textField.parent!.keyboard.activeTextInput = textField
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
       
        //self.keyDown(with: )
        
    }
    override func keyDown(with event: NSEvent) {
        
        print(event.keyCode)
    }
    
    override func mouseUp(with event: NSEvent) {
        print("hello hello")
    }
    
    
}


