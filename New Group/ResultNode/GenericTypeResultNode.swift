//
//  ResultNode.swift
//  backendtest
//
//  Created by Asif Mayilli on 4/5/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation
import SpriteKit
class GenericTypeResultNode:SKShapeNode{
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init() {
        super.init()
    }
    
    convenience init(data:String){
        self.init(rectOf: CGSize(width: 300, height: 200))
        self.position = CGPoint(x:80,y:0)
        self.fillColor = SKColor(calibratedRed: 248/255.0, green: 48/255.0, blue: 56/255.0, alpha: 1.0)
        let titleLabel = SKLabelNode(text:"Result")
        titleLabel.fontSize = 40
        self.addChild(titleLabel)
        titleLabel.position = CGPoint(x:0,y:self.frame.height/2 - titleLabel.frame.height - 5)
        let resultLabel = SKLabelNode(text:String(data))
        resultLabel.fontSize = 30
        resultLabel.numberOfLines = 2
        resultLabel.lineBreakMode = .byWordWrapping
        resultLabel.fontSize = 20
        resultLabel.preferredMaxLayoutWidth = 200
        resultLabel.position = CGPoint(x:0,y:0-titleLabel.frame.height)
        self.addChild(resultLabel)

    }
}

