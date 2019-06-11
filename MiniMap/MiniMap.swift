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
        boxNode.fillColor = .brown
        self.addChild(boxNode)
        
        var json: JSON!
        guard let restoreJSONPath = Bundle.main.path(forResource: "restore", ofType: "json") else { return }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: restoreJSONPath), options: .mappedIfSafe)
            
            json = try JSON(data: data)
            
            for j in json {
                let x = CGFloat(j.1["x"].floatValue)
                let y = CGFloat(j.1["y"].floatValue)
                
                let point = CGPoint(x: x, y: y)
                
                let node = Node(id: j.0, position: point, json: j.1, isSmall: true)
                boxNode.addChild(node)
            }
        } catch {
            print("Error: ", error.localizedDescription)
        }
    }
    
    @objc fileprivate func tap() {
        let newNode = self.scene!.nodes(at: CGPoint(x: 690.0, y: 1893.0)).filter({ $0 is Node }).first as! Node
        newNode.arcManager!.addOutputArc()
        setEdge(from: newNode, to: node!)
    }
    
//    fileprivate func setEdge(from fromNode: Node, to toNode: Node) {
//        guard let fromNodeArc = fromNode.arcManager?.outputArcs[1], let toNodeArc = toNode.arcManager?.inputArcs.first else { return }
//
//        let edge = Edge.init(from: fromNodeArc.globalPos!, to: toNodeArc.globalPos!)
//        fromNodeArc.addEdge(edge: edge)
//        //        fromNodeArc.addEdge(edge: edge)
//        toNodeArc.addEdge(edge: edge)
//
//        let trace = TraceToActivity.init(from: fromNodeArc, to: toNodeArc)
//        trace.edge = edge
//        if let activity = TraceToActivity.getActivity(by: trace.id!) {
//            activity.edge?.redrawEdge(on: scene!, from: fromNodeArc.globalPos!, to: toNodeArc.globalPos!)
//        }
//
//        // to
//        if fromNodeArc.parentNode != toNodeArc.parentNode && fromNodeArc.isInput != toNodeArc.isInput {
//            toNodeArc.parentNode?.inArgs[toNodeArc.name!] = fromNodeArc.parentNode?.id
//            trace.to = toNodeArc
//            trace.from = fromNodeArc
//            trace.from?.addEdge(edge: trace.edge!)
//            trace.to?.addEdge(edge: trace.edge!)
//            trace.edge?.from = fromNodeArc
//            trace.edge?.to = toNodeArc
//            trace.edge?.redrawEdge(from: fromNodeArc.globalPos!, to: toNodeArc.globalPos!)
//            trace.currentTrace = nil
//            toNodeArc.changeArcColor()
//            toNodeArc.redrawArc(with: 1)
//        }
//
//        // from
//        fromNodeArc.changeArcColor()
//        fromNodeArc.isInput = false
//        self.setActivity(activity: trace, trace: MTKTrace.init(), to: toNodeArc, from: fromNodeArc, arc: fromNodeArc)
//        EdgeManager().addEdge(edge: trace.edge!)
//        fromNodeArc.redrawArc(with: 1)
//        //        fromNodeArc.addEdge(edge: trace.edge!)
//    }
    
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
                        trace.to?.parentNode?.inArgs[trace.to!.name!] = trace.from?.parentNode?.id
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
        activity.currentTrace = trace.uuid
        activity.edge = Edge(from: CGPoint.zero, to: CGPoint.zero)
        activity.edge!.zPosition = -2
        activity.edge?.to = to
        activity.edge?.from = from
        activity.fulcrum = arc
    }
    
}
