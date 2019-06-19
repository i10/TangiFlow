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
    let tangibleManager = TangibleManager()

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
        
        setupNodes()
    }
    
    fileprivate func setupNodes() {
        self.scene?.removeAllChildren()
        
        var json: JSON!
        guard let restoreJSONPath =  URL(string: "file:///Users/ppi/Documents/Code/MasterAsif/ProjectFiles/restore.json") else { return }
        
        do {
            let data = try Data(contentsOf: restoreJSONPath, options: .mappedIfSafe)
            
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
    
    fileprivate func getRestoreJSON() -> JSON? {
        guard let restoreJSONPath =  URL(string: "file:///Users/ppi/Documents/Code/MasterAsif/ProjectFiles/restore.json") else { return nil }
        
        do {
            let data = try Data(contentsOf: restoreJSONPath, options: .mappedIfSafe)
            
            let json = try JSON(data: data)
            
            return json
        } catch {
            print("Error: ", error.localizedDescription)
        }
        
        return nil
    }
    
    fileprivate func appendNewNode(to json: JSON, at position: CGPoint) {
        guard let restoreJSONPath =  URL(string: "file:///Users/ppi/Documents/Code/MasterAsif/ProjectFiles/restore.json") else { return }
        
        let newNode = "{\"PT-127.99.40\" : { \"x\": \"\(position.x)\", \"y\": \"\(position.y)\", \"alias\": \"Change brightness\", \"function\": \"change_brightness\", \"arguments\": { \"main_args\": { \"image\": \"Image input\" }, \"controled_args\": { \"controled_value\": { \"type\": \"slider\", \"min\": \"0\", \"max\": \"10\", \"step\": \"0.1\", \"default\": \"0\" } } }, \"group_id\": \"Change image parameters\" }}"
        
        let newJSON = JSON.init(parseJSON: newNode)
        
        let merge = json.myMerged(other: newJSON)
        FileHandler.shared.saveToFile(json: merge, to: restoreJSONPath)
        setupNodes()
    }
    
    func preProcessTraceSet(traceSet: Set<MTKTrace>, node: SKNode, timestamp: TimeInterval) -> Set<MTKTrace> {
        
//        if traceSet.count == 2 {
//            let trace1 = Array(traceSet)[0]
//            let trace2 = Array(traceSet)[1]
//
//            let simultaneousTouch = SimultaneousTouch(with: trace1.position!, and: trace2.position!, self.scene!)
//            print(simultaneousTouch)
//        }
        
        for trace in traceSet{
            if trace.state == MTKUtils.MTKTraceState.beginningTrace{
                self.graph?.touchDown(trace: trace)
                
                
                
//                if traceSet.count == 3 {
//                    if !tangibleManager.isExisting(id: "PT-127.99.40") {
//                        tangibleManager.addTangible(with: "PT-127.99.40")
//
//                        guard let json = getRestoreJSON() else { return [] }
//                        appendNewNode(to: json, at: traceSet.first!.position!)
//                    }
//                }
            }else if trace.state == MTKUtils.MTKTraceState.movingTrace{
//                if traceSet.count > 2 {
                    self.graph?.touchMove(trace: trace)
//                }
            }else{
                if traceSet.count == 2 {
                    let trace1 = Array(traceSet)[0]
                    let trace2 = Array(traceSet)[1]
                    
                    let simultaneousTouch = SimultaneousTouch(with: trace1.position!, and: trace2.position!, self.scene!)
                    print(simultaneousTouch)
                }
                
                self.graph?.touchUp(trace: trace)
                print("Line: #74, File: GameScene ::: ", trace.position)
            }
            
            self.nodes(at: trace.position!)
        }
        
        return traceSet
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
    }
    
}

extension JSON {
    mutating func myMerge(other: JSON) {
        for (key, subJson) in other {
            self[key] = subJson
        }
    }
    
    func myMerged(other: JSON) -> JSON {
        var merged = self
        merged.myMerge(other: other)
        return merged
    }
}
