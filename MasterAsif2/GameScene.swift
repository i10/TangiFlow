//
//  GameScene.swift
//  Test1
//
//  Created by Asif Mayilli on 10/30/18.
//  Copyright © 2018 Test. All rights reserved.
//

import SpriteKit
import SwiftyJSON

import MultiTouchKitSwift
class GameScene: MTKScene, MTKButtonDelegate {
    var graph:Graph2?
    var traceCall:[Int:Int] = [:]
    var projectManager:ProjectFilesManager?

    fileprivate func setEdge(from fromNode: Node, to toNode: Node) {
        guard let fromNodeArc = fromNode.arcManager?.outputArcs.first, let toNodeArc = toNode.arcManager?.inputArcs.first else { return }
        
        let edge = Edge.init(from: fromNodeArc.globalPos!, to: toNodeArc.globalPos!)
        fromNode.arcManager!.outputArcs.first!.addEdge(edge: edge)
        fromNodeArc.addEdge(edge: edge)
        toNodeArc.addEdge(edge: edge)
        
        let trace = TraceToActivity.init(from: fromNodeArc, to: toNodeArc)
        trace.edge = edge
        if let activity = TraceToActivity.getActivity(by: trace.id!) {
            activity.edge?.redrawEdge(on: scene!, from: fromNodeArc.globalPos!, to: toNodeArc.globalPos!)
        }
        
        // to
        if fromNodeArc.parentNode != toNodeArc.parentNode && fromNodeArc.isInput != toNodeArc.isInput {
            toNodeArc.parentNode?.inArgs[toNodeArc.name!] = fromNodeArc.parentNode?.id
            trace.to = toNodeArc
            trace.from = fromNodeArc
            trace.from?.addEdge(edge: trace.edge!)
            trace.to?.addEdge(edge: trace.edge!)
            trace.edge?.from = fromNodeArc
            trace.edge?.to = toNodeArc
            trace.edge?.redrawEdge(from: fromNodeArc.globalPos!, to: toNodeArc.globalPos!)
            trace.currentTrace = nil
            toNodeArc.changeArcColor()
            toNodeArc.redrawArc(with: 1)
        }
        
        // from
        fromNodeArc.changeArcColor()
        fromNodeArc.isInput = false
        self.setActivity(activity: trace, trace: MTKTrace.init(), to: toNodeArc, from: fromNodeArc, arc: fromNodeArc)
        EdgeManager().addEdge(edge: trace.edge!)
        fromNodeArc.redrawArc(with: 1)
    }
    
    override func didMove(to view: SKView) {
        self.view?.ignoresSiblingOrder = true
        graph = Graph2(scene: self)
        self.projectManager = ProjectFilesManager()
        self.projectManager?.openJson()
        
        var json: JSON!
        guard let restoreJSONPath = Bundle.main.path(forResource: "restore", ofType: "json") else { return }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: restoreJSONPath), options: .mappedIfSafe)
            
            json = try JSON(data: data)
            
            for j in json {
                if j.0 == "config" { continue }
                
                let x = CGFloat(j.1["x"].floatValue)
                let y = CGFloat(j.1["y"].floatValue)
                
                let point = CGPoint(x: x, y: y)
                
                let node = Node(id: j.0, position: point, json: j.1)
                (self.scene as! GameScene).graph?.addNode(node: node)
            }
        } catch {
            print("Error: ", error.localizedDescription)
        }
        
        guard let graphJSONPath = Bundle.main.path(forResource: "graph", ofType: "json") else { return }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: graphJSONPath), options: .mappedIfSafe)
            
            let json2 = try JSON(data: data)
            
            for j in json2["graph"] {
                let title = j.0
                let jsonPart = j.1
                
                if jsonPart.count > 0 {
                    let fromX = CGFloat(json[title]["x"].floatValue)
                    let fromY = CGFloat(json[title]["y"].floatValue)
                    
                    let toTitle = jsonPart.first!.1.stringValue
                    let toX = CGFloat(json[toTitle]["x"].floatValue)
                    let toY = CGFloat(json[toTitle]["y"].floatValue)
                    
                    let fromNode = scene?.nodes(at: CGPoint(x: fromX, y: fromY))[1] as! Node
                    let toNode = scene?.nodes(at: CGPoint(x: toX, y: toY))[1] as! Node
                    setEdge(from: fromNode, to: toNode)
                }
            }
        } catch {
            print("Error: ", error.localizedDescription)
        }
    }
    
    func setActivity(activity:TraceToActivity,trace:MTKTrace,to:Arc?,from:Arc?,arc:Arc){
        activity.edge!.zPosition = -2
        activity.edge?.to = to
        activity.edge?.from = from
        activity.fulcrum = arc
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
                print("Line: #74, File: GameScene ::: ", trace.position)
                
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
                        
                        textField.isEditable = true
                        textField.window?.makeFirstResponder(textField)
                        
                        textField.parent?.keyboard.removeFromParent()
                        textField.parent?.addChild(textField.parent!.keyboard)
                        textField.parent!.keyboard.drawKeys()
                        textField.parent?.keyboard.position = CGPoint(x: 600, y: 200)
                        
                        textField.parent!.keyboard.activeTextInput = textField
                    }
                }
            }
            self.nodes(at: trace.position!)
            
        }
        
        return traceSet
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
    }
    
}
