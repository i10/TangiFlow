//
//  Key.swift
//  backendtest
//
//  Created by Asif Mayilli on 4/9/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation
import SpriteKit
class Key:SKNode{
    var label = ""
    override init() {
        super.init()
        
    }
    
    convenience init(x:CGFloat,y:CGFloat,height:CGFloat,width:CGFloat,label:String) {
        self.init()
        self.position = CGPoint(x: x, y: y)
        self.label = label
        let frame = SKShapeNode(rectOf: CGSize(width: width, height: height))
        var label = SKLabelNode(text: label)
        self.addChild(label)
        label.position = CGPoint.zero
        frame.fillColor = NSColor.red
        self.addChild(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("decoder init is not implemented")
    }
}
