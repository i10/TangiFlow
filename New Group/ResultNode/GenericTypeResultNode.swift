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
        self.init(rectOf: CGSize(width: 200, height: 200))
        self.position = CGPoint(x:80,y:0)
        self.fillColor = SKColor.red
        let titleLabel = SKLabelNode(text:"RESULT")
        titleLabel.fontSize = 20
        self.addChild(titleLabel)
        titleLabel.position = CGPoint(x:0,y:self.frame.height/2 - titleLabel.frame.height - 5)
        let resultLabel = SKLabelNode(text:String(data))
        resultLabel.fontSize = 20
        resultLabel.numberOfLines = 2
        resultLabel.lineBreakMode = .byWordWrapping
        resultLabel.fontSize = 20
        resultLabel.preferredMaxLayoutWidth = 200
        resultLabel.position = CGPoint(x:0,y:0-titleLabel.frame.height)
        self.addChild(resultLabel)

    }
}

