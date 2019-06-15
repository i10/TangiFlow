//
//  AssignMap.swift
//  MasterAsif2
//
//  Created by PPI on 15.06.19.
//  Copyright © 2019 RWTH Aachen University. All rights reserved.
//

import Foundation
import MultiTouchKitSwift

class AssignMap: SKNode {
    
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
            fromNode.base.fillColor = .green
            toNode.base.fillColor = .green
            
            fromNode.assignedTo = toNode
            fromNode.assignButton.zRotation = CGFloat.pi
        }
        self.removeFromParent()
    }
    
    @objc fileprivate func closeMiniMap() {
        self.removeFromParent()
    }
    
}
