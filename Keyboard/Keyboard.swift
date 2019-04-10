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
import MultiTouchKitSwift
class Keyboard:SKNode,MTKButtonDelegate{
    var activeTextInput:NSTextField?
    override init() {
        super.init()
        var frame = SKShapeNode(rectOf: CGSize(width: 800, height: 365))
        frame.fillColor = NSColor.white
        self.drawKeys()
        self.addChild(frame)
    }
    
    
    convenience init(textField:NSTextField) {
        self.init()
        self.activeTextInput = textField
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("decoder init is not implemented")
    }
    
    @objc func buttonTapped(button: MTKButton) {
        print(button.titleLabel?.text)
        switch button.titleLabel?.text {
        case "Space":
            self.activeTextInput!.stringValue = self.activeTextInput!.stringValue + " "
        case "Ret":
            self.activeTextInput = nil
            self.removeFromParent()
        case "Del":
            var last = self.activeTextInput!.stringValue.count-1
            self.activeTextInput!.stringValue = String(self.activeTextInput!.stringValue.dropLast())
        default:
            self.activeTextInput!.stringValue = self.activeTextInput!.stringValue + button.titleLabel!.text!
        }
    }

    func drawKeys(){
        var x:CGFloat = -395 + 35
        var y:CGFloat = 140
        let keyHeight:CGFloat = 70
        let keyWidth:CGFloat = 70
        for key in KeyDictionary.layOut1[0]{
            let testButton = MTKButton(size: CGSize(width: keyWidth, height: keyHeight), label: key)
            testButton.position = CGPoint(x: x, y: y)
            self.addChild(testButton)
            testButton.add(target: self, action: #selector(self.buttonTapped(button:)))
            x = x + 80
        }
        x = -395 + 70
        y = 65
        for key in KeyDictionary.layOut1[1]{
            let testButton = MTKButton(size: CGSize(width: keyWidth, height: keyHeight), label: key)
            testButton.position = CGPoint(x: x, y: y)
            self.addChild(testButton)
            testButton.add(target: self, action: #selector(self.buttonTapped(button:)))
            x = x + 80
        }
        x = -405 + 80
        y = -10
        for key in KeyDictionary.layOut1[2]{
            let testButton = MTKButton(size: CGSize(width: keyWidth, height: keyHeight), label: key)
            testButton.position = CGPoint(x: x, y: y)
            self.addChild(testButton)
            testButton.add(target: self, action: #selector(self.buttonTapped(button:)))
            x = x + 80
        }
        x = -325
        y = -85
        //numkey
        let numkey = MTKButton(size: CGSize(width: keyWidth, height: keyHeight), label: KeyDictionary.layOut1[3][0])
        numkey.position = CGPoint(x: x, y: y)
        self.addChild(numkey)
        numkey.add(target: self, action: #selector(self.buttonTapped(button:)))
        x = x + 2*70
        //space
        let space = MTKButton(size: CGSize(width: 550, height: keyHeight), label: KeyDictionary.layOut1[3][1])
        space.position = CGPoint(x: x+180, y: y)
        self.addChild(space)
        space.add(target: self, action: #selector(self.buttonTapped(button:)))
        x = x + 180 + 10
        //return
        let returnkey = MTKButton(size: CGSize(width: keyWidth, height: keyHeight), label: KeyDictionary.layOut1[3][2])
        returnkey.position = CGPoint(x: x + 180 + 130 , y: y)
        self.addChild(returnkey)
        returnkey.add(target: self, action: #selector(self.buttonTapped(button:)))
        x = x + 2*70
        
//        for key in KeyDictionary.layOut1[3]{
//            let testButton = MTKButton(size: CGSize(width: keyWidth, height: keyHeight), label: key)
//            testButton.position = CGPoint(x: x, y: y)
//            self.addChild(testButton)
//            testButton.add(target: self, action: #selector(self.buttonTapped(button:)))
//            x = x + 3*70
//        }
    }
}
