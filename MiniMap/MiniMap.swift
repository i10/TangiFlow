//
//  MiniMap.swift
//  MasterAsif2
//
//  Created by PPI on 10.06.19.
//  Copyright © 2019 RWTH Aachen University. All rights reserved.
//

import SpriteKit
import MultiTouchKitSwift

class MiniMap: SKNode {
    
    var node: Node?
    var json: JSON!
    
    override init() {
        super.init()
    }
    
    convenience init(node: Node) {
        self.init()
        
        self.node = node
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        // MiniMap Box
        let screenSize = NSScreen.screens[1].frame.size
        let boxNode = SKShapeNode(rectOf: CGSize(width: screenSize.width / 5, height: screenSize.height / 5))
        boxNode.position = CGPoint(x: boxNode.frame.width / 1.6, y: boxNode.frame.height / 1.6)
        boxNode.zPosition = 1000
        boxNode.fillColor = #colorLiteral(red: 0.1490033567, green: 0.1490303278, blue: 0.148994863, alpha: 1)
        self.addChild(boxNode)
        
        
        guard let restoreJSONPath = Bundle.main.path(forResource: "restore", ofType: "json") else { return }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: restoreJSONPath), options: .mappedIfSafe)
            
            json = try JSON(data: data)
            
            for j in json {
                let x = CGFloat(j.1["x"].floatValue)
                let y = CGFloat(j.1["y"].floatValue)
                
                var point = CGPoint(x: x / 5, y: y / 5)
                point.x = point.x - boxNode.frame.width / 2
                point.y = point.y - boxNode.frame.height / 2
                
                let node = MTKButton(size: CGSize(width: 44.0, height: 40.0), image: "circle")
                node.add(target: self, action: #selector(self.nodeTapped(node:)))
                node.name = j.0
                node.position = point
                boxNode.addChild(node)
                
                let closeButton = MTKButton(size: CGSize(width: 30.0, height: 30.0), image: "close")
                closeButton.position = CGPoint(x: boxNode.frame.width / 2, y: boxNode.frame.height / 2)
                closeButton.add(target: self, action: #selector(self.closeMiniMap))
                boxNode.addChild(closeButton)
            }
        } catch {
            print("Error: ", error.localizedDescription)
        }
        
        
        // graph
        guard let graphJSONPath =  URL(string: "file:///Users/ppi/Documents/Code/MasterAsif/ProjectFiles/graph.json") else { return }
        
        do {
            let data = try Data(contentsOf: graphJSONPath, options: .mappedIfSafe)
            
            let json2 = try JSON(data: data)
            
            for j in json2["graph"] {
                let title = j.0
                let jsonPart = j.1
                
                if jsonPart.count > 0 {
                    let fromX = CGFloat(json[title]["x"].floatValue) / 5 - (boxNode.frame.width / 2)
                    let fromY = CGFloat(json[title]["y"].floatValue) / 5 - (boxNode.frame.height / 2)
                    
                    let toTitle = jsonPart.first!.1.stringValue
                    let toX = CGFloat(json[toTitle]["x"].floatValue) / 5 - (boxNode.frame.width / 2)
                    let toY = CGFloat(json[toTitle]["y"].floatValue) / 5 - (boxNode.frame.height / 2)
                    
                    let edge = Edge(from: CGPoint(x: fromX, y: fromY), to: CGPoint(x: toX, y: toY))
                    boxNode.addChild(edge)
                }
            }
        } catch {
            print("Error: ", error.localizedDescription)
        }
    }
    
    @objc fileprivate func nodeTapped(node: MTKButton) {
        guard let fromNode = node.parent?.parent?.parent as? Node, let scene = self.scene else { return }
        
        let toX = CGFloat(json[node.name!]["x"].floatValue)
        let toY = CGFloat(json[node.name!]["y"].floatValue)
        if let toNode = scene.nodes(at: CGPoint(x: toX, y: toY)).filter({ $0 is Node }).first as? Node {
            toNode.arcManager!.addOutputArc()
            setEdge(from: toNode, to: fromNode)
        }
        self.removeFromParent()
    }
    
    @objc fileprivate func closeMiniMap() {
        self.removeFromParent()
    }
    
    @objc fileprivate func tap() {
        let newNode = self.scene!.nodes(at: CGPoint(x: 690.0, y: 1893.0)).filter({ $0 is Node }).first as! Node
        newNode.arcManager!.addOutputArc()
        setEdge(from: newNode, to: node!)
    }
    
    fileprivate func setEdge(from fromNode: Node, to toNode: Node) {
        guard let toNodeArc = toNode.arcManager?.inputArcs.first else { return }
        
        let arcs = fromNode.arcManager?.outputArcs.filter({ $0 is Arc }) as! [Arc]
        for arc in arcs {
            if arc.edges.isEmpty && toNode.arcManager!.inputArcs.first!.edges.isEmpty {
                let edge = Edge.init(from: arc.globalPos!, to: toNodeArc.globalPos!)
                arc.addEdge(edge: edge)
                arc.addEdge(edge: edge)
                toNodeArc.addEdge(edge: edge)
                
                let trace = TraceToActivity.init(from: arc, to: toNodeArc)
                trace.edge = edge
                if let activity = TraceToActivity.getActivity(by: trace.id!) {
                    activity.edge?.redrawEdge(on: scene!, from: arc.globalPos!, to: toNodeArc.globalPos!)
                }
                
                // to
                if arc.parentNode != toNodeArc.parentNode && arc.isInput != toNodeArc.isInput {
                    toNodeArc.parentNode?.inArgs[toNodeArc.name!] = arc.parentNode?.id
                    trace.to = toNodeArc
                    trace.from = arc
                    arc.addEdge(edge: trace.edge!)
                    trace.to?.addEdge(edge: trace.edge!)
                    trace.edge?.from = arc
                    trace.edge?.to = toNodeArc
                    trace.edge?.redrawEdge(from: arc.globalPos!, to: toNodeArc.globalPos!)
                    trace.currentTrace = nil
                    toNodeArc.changeArcColor()
                    toNodeArc.redrawArc(with: 1)
                }
                
                // from
                arc.changeArcColor()
                arc.isInput = false
                self.setActivity(activity: trace, trace: MTKTrace.init(), to: toNodeArc, from: arc, arc: arc)
                EdgeManager().addEdge(edge: trace.edge!)
                arc.redrawArc(with: 1)
            }
        }
    }
    
    func setActivity(activity:TraceToActivity,trace:MTKTrace,to:Arc?,from:Arc?,arc:Arc){
//        activity.currentTrace = trace.uuid
//        activity.edge = Edge(from: CGPoint.zero, to: CGPoint.zero)
        activity.edge!.zPosition = -2
        activity.edge?.to = to
        activity.edge?.from = from
        activity.fulcrum = arc
    }
    
}
