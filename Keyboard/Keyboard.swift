//
//  Keyboard.swift
//  backendtest
//
//  Created by Asif Mayilli on 4/9/19.
//  Copyright © 2019 Test. All rights reserved.
//
//28:9
import Foundation
import SpriteKit
class Keyboard:SKNode{
    override init() {
        super.init()
        var frame = SKShapeNode(rectOf: CGSize(width: 700, height: 365))
        frame.fillColor = NSColor.white
        self.drawKeys()
        self.addChild(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("decoder init is not implemented")
    }
    
    func drawKeys(){
        var x:CGFloat = -350 + 35
        var y:CGFloat = 150
        let keyHeight:CGFloat = 225 / 4
        let keyWidth:CGFloat = 700 / 10
        for key in KeyDictionary.layOut1[0]{
            var button = Key(x: x, y: y, height: keyHeight, width: keyWidth, label: key)
            self.addChild(button)
            x = x + 70
        }
        x = -350 + 35 + 35
        y = 75
        for key in KeyDictionary.layOut1[1]{
            var button = Key(x: x, y: y, height: keyHeight, width: keyWidth, label: key)
            self.addChild(button)
            x = x + 70
        }
        x = -350 + 35 + 35
        y = 0
        for key in KeyDictionary.layOut1[2]{
            var button = Key(x: x, y: y, height: keyHeight, width: keyWidth, label: key)
            self.addChild(button)
            x = x + 70
        }
        x = -350 + 35 + 35 + 70 + 70
        y = -75
        for key in KeyDictionary.layOut1[3]{
            var button = Key(x: x, y: y, height: keyHeight, width: 2*keyWidth, label: key)
            self.addChild(button)
            x = x + 2*70
        }
    }
}
