//
//  SimultaneousTouch.swift
//  MasterAsif2
//
//  Created by PPI on 19.06.19.
//  Copyright © 2019 RWTH Aachen University. All rights reserved.
//

import Foundation
import MultiTouchKitSwift

class SimultaneousTouch: SKNode {
    
    var touch1: CGPoint!
    var touch2: CGPoint!
    var theScene: SKScene!
    
    var json: JSON!
    
    override init() {
        super.init()
    }
    
    convenience init(with touch1: CGPoint, and touch2: CGPoint, _ scene: SKScene) {
        self.init()
        
        self.touch1 = touch1
        self.touch2 = touch2
        self.theScene = scene
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        guard let restoreJSONPath = Bundle.main.path(forResource: "restore", ofType: "json") else { return }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: restoreJSONPath), options: .mappedIfSafe)
            
            json = try JSON(data: data)
        } catch {
            print("Error: ", error.localizedDescription)
        }
        
        
        guard let node1 = self.theScene.nodes(at: touch1).first?.parent as? Node, let node2 = self.theScene.nodes(at: touch2).first?.parent as? Node else { return }
        
        setEdge(from: node1, to: node2)
        
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
                    activity.edge?.redrawEdge(on: self.theScene, from: arc.globalPos!, to: toNodeArc.globalPos!)
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
