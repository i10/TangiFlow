//
//  ListView.swift
//  MasterAsif2
//
//  Created by PPI on 20.06.19.
//  Copyright © 2019 RWTH Aachen University. All rights reserved.
//

import Foundation
import MultiTouchKitSwift

class ListView: SKNode {
    
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
        guard let restoreJSONPath = Bundle.main.path(forResource: "restore", ofType: "json") else { return }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: restoreJSONPath), options: .mappedIfSafe)
            
            json = try JSON(data: data)
        } catch {
            print("Error: ", error.localizedDescription)
        }
        
        for i in 0..<4 {
            let position = CGPoint(x: -180.0, y: CGFloat(i * 31))
            let row = MTKButton(size: CGSize(width: 150.0, height: 30.0), label: "\((i * 10) + 1) - \((i + 1) * 10)")
            row.name = "\((i + 1) * 10)"
            row.add(target: self, action: #selector(self.node10Tapped(_:)))
            row.titleLabel?.fontSize = 17.0
            row.set(color: .brown)
            row.position = position
            self.addChild(row)
        }
        
    }
    
    @objc fileprivate func node10Tapped(_ sender: MTKButton) {
        let upperLimit = Int(sender.name!)!
        self.removeAllChildren()
        
        for i in 1...2 {
            let value = upperLimit - (5 * i) + 1
            let position = CGPoint(x: -180.0, y: CGFloat(i * 31))
            let row = MTKButton(size: CGSize(width: 150.0, height: 30.0), label: "\(value) - \(value + 4)")
            row.name = "\(value)"
            row.add(target: self, action: #selector(self.node5Tapped(_:)))
            row.titleLabel?.fontSize = 17.0
            row.set(color: .brown)
            row.position = position
            self.addChild(row)
        }
    }
    
    @objc fileprivate func node5Tapped(_ sender: MTKButton) {
        let lowerLimit = Int(sender.name!)!
        self.removeAllChildren()
        
        for i in lowerLimit..<lowerLimit + 5 {
            let position = CGPoint(x: -180.0, y: CGFloat((i - lowerLimit) * 31))
            let row = MTKButton(size: CGSize(width: 150.0, height: 30.0), label: "\(i)")
            row.add(target: self, action: #selector(self.nodeTapped(_:)))
            row.name = "\(i)"
            row.titleLabel?.fontSize = 17.0
            row.set(color: .brown)
            row.position = position
            self.addChild(row)
        }
    }
    
    @objc fileprivate func nodeTapped(_ sender: MTKButton) {
        guard let selectedNode = self.scene?.children.filter({ $0 is Node }).filter({ ($0 as! Node).id!.contains(sender.name!) }).first as? Node else { return }
        selectedNode.arcManager!.addOutputArc()
        
//        setEdge(from: self.node!, to: selectedNode)
        setEdge(from: selectedNode, to: self.node!)
        self.removeAllChildren()
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
                    activity.edge?.redrawEdge(on: self.scene!, from: arc.globalPos!, to: toNodeArc.globalPos!)
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
