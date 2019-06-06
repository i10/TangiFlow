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
    var graph:Graph2?
    var traceCall:[Int:Int] = [:]
    var projectManager:ProjectFilesManager?

    
    override func didMove(to view: SKView) {
        self.view?.ignoresSiblingOrder = true
        graph = Graph2(scene: self)
        self.projectManager = ProjectFilesManager()
        self.projectManager?.openJson()
        let projectJson = self.projectManager?.projectFileJson
        var sideMenu = SideMenuTest(json: projectJson ?? [:],view:view,scene:self)
        sideMenu.right = false
        var sideMenuRight = SideMenuTest(json: projectJson ?? [:],view:view,scene:self)
        sideMenuRight.position = CGPoint(x:self.size.width - 180,y:550)
        self.addChild(sideMenu)
        self.addChild(sideMenuRight)
        
        
    }
    override func setupScene() {
        FileHandler.shared.cleanContent(of:FileHandler.shared.imagesFolderPath)
        FileHandler.shared.cleanContent(of:FileHandler.shared.resultFolderPath)
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
                    if textField.frame.origin.x < trace.position!.x && trace.position!.x < textField.frame.origin.x + 200 &&
                        textField.frame.origin.y < trace.position!.y && trace.position!.y < textField.frame.origin.y + 80{
//                        print(textFererwerewrerewrwerwerwerwerwerwewererewield)
                      
                       // textField.isEnabled = true
                        textField.isEditable = true
                        //textField.becomeFirstResponder()
                        textField.window?.makeFirstResponder(textField)
                        //textField.stringValue = ""
                       // print(textField.stringValue)

                            textField.parent?.keyboard.removeFromParent()
                            textField.parent?.addChild(textField.parent!.keyboard)
                            textField.parent!.keyboard.drawKeys()
                            textField.parent?.keyboard.position = CGPoint(x: 600, y: 200)
                            
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
   
//    @objc func run(button:MTKButton,id:String){
//        let scr = ScriptRunner()
//        scr.script(id:id)
//        let resultMaker = ResultVisualization()
//        resultMaker.getResults()
//    }
    
}


