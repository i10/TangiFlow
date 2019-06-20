//
//  StarView.swift
//  MasterAsif2
//
//  Created by PPI on 20.06.19.
//  Copyright © 2019 RWTH Aachen University. All rights reserved.
//

import Foundation
import MultiTouchKitSwift

class StarView: SKNode {
    
    var json: JSON!
    var node: Node!
    
    override init() {
        super.init()
    }
    
    convenience init(with node: Node) {
        self.init()
        
        self.node = node
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        guard let restoreJSONPath = Bundle.main.path(forResource: "restore", ofType: "json") else { return }
        
        self.node.playButton.isHidden = true
        self.node.addButton.isHidden = true
        self.node.deleteButton.isHidden = true
        self.node.listButton.isHidden = true
        self.node.assignButton.isHidden = true
        self.node.starButton.isHidden = true
        
        for sub in self.node.children {
            if sub is Slider {
                sub.isHidden = true
            }
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: restoreJSONPath), options: .mappedIfSafe)
            
            json = try JSON(data: data)
            
            for j in json {
                if j.0 == self.node.id! { continue }
                
                let x = CGFloat(j.1["x"].floatValue)
                let y = CGFloat(j.1["y"].floatValue)
                
                var newX = (x - self.node.position.x) / 15
                var newY = (y - self.node.position.y) / 15
                
                if y > self.node.position.y + 450.0 {
                    newY = newY + 60.0
                } else {
                    if x > self.node.position.x + 100 {
                        newX = newX + 80.0
                    } else {
                        newX = newX - 90.0
                    }
                }
                
                let newPosition = CGPoint(x: newX, y: newY)
                
                let starNode = MTKButton(size: CGSize(width: 12.0, height: 12.0), image: "circleGlyph")
                starNode.name = j.0
                starNode.add(target: self, action: #selector(self.nodeTapped(_:)))
                starNode.position = newPosition
                self.addChild(starNode)
            }
        } catch {
            print("Error: ", error.localizedDescription)
        }
    }
    
    @objc fileprivate func nodeTapped(_ sender: MTKButton) {
        guard let title = sender.name, let scene = self.scene else { return }
        
        let x = CGFloat(json[title]["x"].floatValue)
        let y = CGFloat(json[title]["y"].floatValue)
        
        if let toNode = scene.nodes(at: CGPoint(x: x, y: y)).first?.parent?.parent as? Node {
            toNode.arcManager!.addOutputArc()
            setEdge(from: toNode, to: self.node)
            
            self.removeAllChildren()
            
            self.node.playButton.isHidden = false
            self.node.addButton.isHidden = false
            self.node.deleteButton.isHidden = false
            self.node.listButton.isHidden = false
            self.node.assignButton.isHidden = false
            self.node.starButton.isHidden = false
            
            for sub in self.node.children {
                if sub is Slider {
                    sub.isHidden = false
                }
            }
        }
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
        activity.edge!.zPosition = -2
        activity.edge?.to = to
        activity.edge?.from = from
        activity.fulcrum = arc
    }
    
}
