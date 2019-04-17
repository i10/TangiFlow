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
    var capsLock:Bool = false
    var activeTextInput:NSTextField?
    var keys:[MTKButton] = []
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
        //print(button.titleLabel?.text)
        switch button.titleLabel?.text {
        case "Space":
            self.activeTextInput!.stringValue = self.activeTextInput!.stringValue + " "
        case "Ret":
            self.activeTextInput = nil
            self.removeFromParent()
        case "Del":
            var last = self.activeTextInput!.stringValue.count-1
            self.activeTextInput!.stringValue = String(self.activeTextInput!.stringValue.dropLast())
        case "Caps":
            self.capsLock = !self.capsLock
        case "123":
            //self.children.removeAll()
            self.drawSpecialKeys1()
        case "#+=":
            self.drawSpecialKeys2()
        case "ABC":
            self.capsLock = false
            self.drawKeys()
        default:
            if self.capsLock{
                self.activeTextInput!.stringValue = self.activeTextInput!.stringValue + button.titleLabel!.text!.uppercased()
            }else{
                self.activeTextInput!.stringValue = self.activeTextInput!.stringValue + button.titleLabel!.text!
                
            }
        }
    }

    func drawKeys(){
        for key in self.keys {
            key.removeFromParent()
        }
        self.keys = []
        var x:CGFloat = -395 + 35
        var y:CGFloat = 140
        let keyHeight:CGFloat = 70
        let keyWidth:CGFloat = 70
        for key in KeyDictionary.layout1[0]{
            
            let testButton = MTKButton(size: CGSize(width: keyWidth, height: keyHeight), label: key)
            testButton.position = CGPoint(x: x, y: y)
            self.addChild(testButton)
            self.keys.append(testButton)
            testButton.add(target: self, action: #selector(self.buttonTapped(button:)))
            x = x + 80
        }
        x = -395 + 70
        y = 65
        for key in KeyDictionary.layout1[1]{
            let testButton = MTKButton(size: CGSize(width: keyWidth, height: keyHeight), label: key)
            testButton.position = CGPoint(x: x, y: y)
            self.keys.append(testButton)
            self.addChild(testButton)
            testButton.add(target: self, action: #selector(self.buttonTapped(button:)))
            x = x + 80
        }
        x = -405 + 80
        y = -10
        for key in KeyDictionary.layout1[2]{
            let testButton = MTKButton(size: CGSize(width: keyWidth, height: keyHeight), label: key)
            testButton.position = CGPoint(x: x, y: y)
            self.keys.append(testButton)
            self.addChild(testButton)
            testButton.add(target: self, action: #selector(self.buttonTapped(button:)))
            x = x + 80
        }
        x = -325
        y = -85
        //numkey
        let numkey = MTKButton(size: CGSize(width: keyWidth, height: keyHeight), label: KeyDictionary.layout1[3][0])
        numkey.position = CGPoint(x: x, y: y)
        self.keys.append(numkey)
        self.addChild(numkey)
        numkey.add(target: self, action: #selector(self.buttonTapped(button:)))
        x = x + 2*70
        //space
        let space = MTKButton(size: CGSize(width: 550, height: keyHeight), label: KeyDictionary.layout1[3][1])
        space.position = CGPoint(x: x+180, y: y)
        self.keys.append(space)
        
        self.addChild(space)
        space.add(target: self, action: #selector(self.buttonTapped(button:)))
        x = x + 180 + 10
        //return
        let returnkey = MTKButton(size: CGSize(width: keyWidth, height: keyHeight), label: KeyDictionary.layout1[3][2])
        returnkey.position = CGPoint(x: x + 180 + 130 , y: y)
        self.keys.append(returnkey)
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
    
    
    
    func drawSpecialKeys1(){
        for key in self.keys {
            key.removeFromParent()
        }
        self.keys = []
        var x:CGFloat = -395 + 35
        var y:CGFloat = 140
        let keyHeight:CGFloat = 70
        let keyWidth:CGFloat = 70
        for key in KeyDictionary.layout2[0]{
            let testButton = MTKButton(size: CGSize(width: keyWidth, height: keyHeight), label: key)
            testButton.position = CGPoint(x: x, y: y)
            self.keys.append(testButton)
            self.addChild(testButton)
            testButton.add(target: self, action: #selector(self.buttonTapped(button:)))
            x = x + 80
        }
        x = -395 + 35
        y = 65
        for key in KeyDictionary.layout2[1]{
            let testButton = MTKButton(size: CGSize(width: keyWidth, height: keyHeight), label: key)
            testButton.position = CGPoint(x: x, y: y)
            self.keys.append(testButton)
            self.addChild(testButton)
            testButton.add(target: self, action: #selector(self.buttonTapped(button:)))
            x = x + 80
        }
        x = -245
        y = -10
        for key in KeyDictionary.layout2[2]{
            let testButton = MTKButton(size: CGSize(width: keyWidth, height: keyHeight), label: key)
            testButton.position = CGPoint(x: x, y: y)
            self.keys.append(testButton)
            self.addChild(testButton)
            testButton.add(target: self, action: #selector(self.buttonTapped(button:)))
            x = x + 80
        }
        x = -325
        y = -85
        //numkey
        let numkey = MTKButton(size: CGSize(width: keyWidth, height: keyHeight), label: KeyDictionary.layout2[3][0])
        numkey.position = CGPoint(x: x, y: y)
        self.addChild(numkey)
        numkey.add(target: self, action: #selector(self.buttonTapped(button:)))
        self.keys.append(numkey)
        x = x + 2*70
        //space
        let space = MTKButton(size: CGSize(width: 550, height: keyHeight), label: KeyDictionary.layout2[3][1])
        space.position = CGPoint(x: x+180, y: y)
        self.addChild(space)
        self.keys.append(space)
        space.add(target: self, action: #selector(self.buttonTapped(button:)))
        x = x + 180 + 10
        //return
        let returnkey = MTKButton(size: CGSize(width: keyWidth, height: keyHeight), label: KeyDictionary.layout2[3][2])
        returnkey.position = CGPoint(x: x + 180 + 130 , y: y)
        self.addChild(returnkey)
        self.keys.append(returnkey)
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
    
    func drawSpecialKeys2(){
        for key in self.keys {
            key.removeFromParent()
        }
        self.keys = []
        var x:CGFloat = -395 + 35
        var y:CGFloat = 140
        let keyHeight:CGFloat = 70
        let keyWidth:CGFloat = 70
        for key in KeyDictionary.layout3[0]{
            let testButton = MTKButton(size: CGSize(width: keyWidth, height: keyHeight), label: key)
            testButton.position = CGPoint(x: x, y: y)
            self.addChild(testButton)
            self.keys.append(testButton)
            testButton.add(target: self, action: #selector(self.buttonTapped(button:)))
            x = x + 80
        }
        x = -395 + 35
        y = 65
        for key in KeyDictionary.layout3[1]{
            let testButton = MTKButton(size: CGSize(width: keyWidth, height: keyHeight), label: key)
            testButton.position = CGPoint(x: x, y: y)
            self.addChild(testButton)
            self.keys.append(testButton)
            testButton.add(target: self, action: #selector(self.buttonTapped(button:)))
            x = x + 80
        }
        x = -245
        y = -10
        for key in KeyDictionary.layout3[2]{
            let testButton = MTKButton(size: CGSize(width: keyWidth, height: keyHeight), label: key)
            testButton.position = CGPoint(x: x, y: y)
            self.addChild(testButton)
            self.keys.append(testButton)
            testButton.add(target: self, action: #selector(self.buttonTapped(button:)))
            x = x + 80
        }
        x = -325
        y = -85
        //numkey
        let numkey = MTKButton(size: CGSize(width: keyWidth, height: keyHeight), label: KeyDictionary.layout3[3][0])
        numkey.position = CGPoint(x: x, y: y)
        self.addChild(numkey)
        self.keys.append(numkey)
        numkey.add(target: self, action: #selector(self.buttonTapped(button:)))
        x = x + 2*70
        //space
        let space = MTKButton(size: CGSize(width: 550, height: keyHeight), label: KeyDictionary.layout3[3][1])
        space.position = CGPoint(x: x+180, y: y)
        self.addChild(space)
        self.keys.append(space)
        space.add(target: self, action: #selector(self.buttonTapped(button:)))
        x = x + 180 + 10
        //return
        let returnkey = MTKButton(size: CGSize(width: keyWidth, height: keyHeight), label: KeyDictionary.layout3[3][2])
        returnkey.position = CGPoint(x: x + 180 + 130 , y: y)
        self.addChild(returnkey)
        self.keys.append(returnkey)
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
