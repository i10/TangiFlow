//
//  GameScene.swift
//  Test1
//
//  Created by Asif Mayilli on 10/30/18.
//  Copyright © 2018 Test. All rights reserved.
//

import SpriteKit

import MultiTouchKitSwift
class GameScene: MTKScene, MTKButtonDelegate {
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
        self.view?.ignoresSiblingOrder = true
        //let fileManager = FileManager.default
        //let currentPath = fileManager.currentDirectoryPath
        //print("Current path: \(currentPath)")
        let run = MTKButton(size: CGSize(width: 100, height: 100), image: "play.png")
        run.position = CGPoint(x: 100, y: 100 )
        run.add(target: self, action: #selector(self.run(button:)))
        self.addChild(run)
//        let barra = SKShapeNode(rectOf: CGSize(width: 70, height: 70))
//        barra.name = "bar"
//        barra.fillColor = SKColor.white
//        barra.position = CGPoint(x:0,y:0)
//        self.addChild(barra)
        graph = Graph2(scene: self)
        self.projectManager = ProjectFilesManager()
        self.projectManager?.openJson()
        let projectJson = self.projectManager?.projectFileJson
        var sideMenu = SideMenu(json: projectJson ?? [:],view:view,scene:self)
        self.addChild(sideMenu)
        
        
    }
    override func setupScene() {
        graph = Graph2(scene: self)
        MTKHub.sharedHub.traceDelegate = self
        
       
        
    }
    
    func preProcessTraceSet(traceSet: Set<MTKTrace>, node: SKNode, timestamp: TimeInterval) -> Set<MTKTrace> {
        

        for trace in traceSet{
            if trace.state == MTKUtils.MTKTraceState.beginningTrace{
                self.graph?.touchDown(trace: trace)
            }else if trace.state == MTKUtils.MTKTraceState.movingTrace{
                self.graph?.touchMove(trace: trace)
            }else{
                self.graph?.touchUp(trace: trace)

                
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
    

    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
    }
   
    @objc func run(button:MTKButton){
        let scr = ScriptRunner()
        scr.script()
        let resultMaker = ResultVisualization()
        resultMaker.getResults()
    }
    
}


