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
    
    override  init(){
        super.init()
    }
    
    convenience init(from:CGPoint,to:CGPoint) {
        self.init()
        self.path = pathToDraw
        self.fillColor = NSColor.white
        self.strokeColor = NSColor.white
        self.lineWidth = 2
        self.pathToDraw.move(to: from)
        self.pathToDraw.addLine(to: to)
        self.path = self.pathToDraw
        //self.from = from
        //self.to = to
        self.id = UUID().uuidString
        self.fromPoint = from
        self.toPoint = to
    }
    
    
    func redrawEdge(from:CGPoint,to:CGPoint){
        self.removeFromParent()
        self.pathToDraw  = CGMutablePath()
        //myLine = SKShapeNode(path:pathToDraw!)
        self.path = pathToDraw
        self.fillColor = NSColor.white
        self.strokeColor = NSColor.white
        self.lineWidth = 2
        self.pathToDraw.move(to: from)
        self.pathToDraw.addLine(to: to)
        self.path = self.pathToDraw
        self.fromPoint = from
        self.toPoint = to
        //            pathToDraw?.move(to: start!)
        //            pathToDraw?.addLine(to: event.location(in: self))
        //            myLine?.path = pathToDraw
        //            myLine?.strokeColor = NSColor.red
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
