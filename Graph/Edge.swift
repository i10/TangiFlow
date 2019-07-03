//
//  Edge.swift
//  Test1
//
//  Created by Asif Mayilli on 10/31/18.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import SpriteKit
class Edge:SKShapeNode{
    var from:Arc?
    var to:Arc?
    var fromPoint:CGPoint?
    var toPoint:CGPoint?
    var id:String?
    var pathToDraw:CGMutablePath = CGMutablePath()
    var offset: CGPoint?
    
    override  init(){
        super.init()
    }
    
    convenience init(from:CGPoint,to:CGPoint) {
        self.init()
        self.drawLineBasic(from: from, to: to)
        self.id = UUID().uuidString
    }
    
    
    func redrawEdge(from:CGPoint?,to:CGPoint?){
        if var from = from, let to = to{
            let parent = self.parent
            self.removeFromParent()
            self.pathToDraw  = CGMutablePath()
            
            if let offset = self.offset {
                from = CGPoint(x: from.x + offset.x, y: from.y + offset.y)
            }
            
            self.drawLineBasic(from: from, to: to)
            parent?.addChild(self)
        }
    }
    
    func redrawEdge(on scene: SKScene, from:CGPoint?,to:CGPoint?){
        if let from = from, let to = to{
            self.removeFromParent()
            self.pathToDraw  = CGMutablePath()
            self.drawLineBasic(from: from, to: to)
            scene.addChild(self)
        }
    }
    
    func drawLineBasic(from:CGPoint,to:CGPoint){
        self.path = pathToDraw
        self.fillColor = NSColor.white
//        self.strokeColor = NSColor.white
        self.lineWidth = 0.1
        self.pathToDraw.move(to: from)
        self.pathToDraw.addLine(to: to)
        self.path = self.pathToDraw
        self.fromPoint = from
        self.toPoint = to
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

