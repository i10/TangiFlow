//
//  Disconnect.swift
//  MasterAsif2
//
//  Created by PPI on 12.06.19.
//  Copyright © 2019 RWTH Aachen University. All rights reserved.
//

import Foundation
import SpriteKit
import MultiTouchKitSwift

class Disconnect: SKNode {
    
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
        // Disconnect TableView
//        let row = MTKButton(size: CGSize(width: 200.0, height: 80.0), label: "AAA")
//        row.set(color: .brown)
//        row.position = CGPoint(x: 0, y: 0)
//        self.scene!.addChild(row)
        
        
        guard let restoreJSONPath = Bundle.main.path(forResource: "restore", ofType: "json") else { return }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: restoreJSONPath), options: .mappedIfSafe)
            
            json = try JSON(data: data)
        } catch {
            print("Error: ", error.localizedDescription)
        }
        
        
        // graph
//        guard let graphJSONPath = Bundle.main.path(forResource: "graph", ofType: "json") else { return }
        guard let graphJSONPath =  URL(string: "file:///Users/ppi/Documents/Code/MasterAsif/ProjectFiles/graph.json") else { return }
        
        do {
            let data = try Data(contentsOf: graphJSONPath, options: .mappedIfSafe)
            
            let json2 = try JSON(data: data)
            
            for (k, v) in json2["graph_reverse"][self.node!.id!].enumerated() {
                let position = CGPoint(x: -180.0, y: CGFloat(k * 80))
                let row = MTKButton(size: CGSize(width: 150.0, height: 30.0), label: v.1.stringValue)
                row.add(target: self, action: #selector(self.nodeTapped(node:)))
                row.titleLabel?.fontSize = 17.0
                row.set(color: .brown)
                row.position = position
                self.addChild(row)                
            }
        } catch {
            print("Error: ", error.localizedDescription)
        }
    }
    
    @objc fileprivate func nodeTapped(node: MTKButton) {
        guard let fromNode = node.parent?.parent?.parent as? Node, let scene = self.scene else { return }
        
        // Disconnect from here
    }
    
    @objc fileprivate func closeMiniMap() {
        self.removeFromParent()
    }
    
}
