//
//  Numpad.swift
//  MasterAsif2
//
//  Created by PPI on 25.04.19.
//  Copyright © 2019 RWTH Aachen University. All rights reserved.
//

import Foundation
import SpriteKit
import MultiTouchKitSwift

class Numpad:SKNode, MTKButtonDelegate{
    var activeTextInput:NSTextField?
    var keys:[MTKButton] = []
    override init() {
        super.init()
        var frame = SKShapeNode(rectOf: CGSize(width: 250, height: 370))
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
    
    func drawKeys(){
        var x = -125
        var y = 125
        for index in 0 ..< KeyDictionary.numpad.count{
            var i = index%3
            var j = index/3
            var x = -70 + i*70
            var y = 140 - j*70
            var button = MTKButton(size: CGSize(width: 70, height: 70), label: KeyDictionary.numpad[index])
            button.add(target: self, action: #selector(self.tapButton(button:)))
            button.position = CGPoint(x: x, y: y)
            self.addChild(button)
            self.keys.append(button)
        }
        var returnButton = MTKButton(size: CGSize(width: 210, height: 70), label: "CONFIRM")
        self.addChild(returnButton)
        returnButton.add(target: self, action: #selector(self.tapButton(button:)))
        returnButton.position = CGPoint(x: 0, y: -150)
    }
    
    @objc func tapButton(button:MTKButton){
        
        switch button.titleLabel!.text {
            case "←":
                var last = self.activeTextInput!.stringValue.count-1
                self.activeTextInput!.stringValue = String(self.activeTextInput!.stringValue.dropLast())
                (self.activeTextInput as! CustomTextFields).parent?.changeBaseColor(color: NSColor(calibratedRed: 255.0/255.0, green: 230.0/255.0, blue: 77.0/255.0, alpha: 1.0))
            case "CONFIRM":
                self.activeTextInput = nil
                self.removeFromParent()
            default:
                if (self.activeTextInput?.stringValue.count)! < 10 {
                    (self.activeTextInput as! CustomTextFields).parent?.changeBaseColor(color: NSColor(calibratedRed: 255.0/255.0, green: 230.0/255.0, blue: 77.0/255.0, alpha: 1.0))
                    let a = self.activeTextInput!.stringValue
                    let b =  button.titleLabel!.text!
                    
                    let c = a + b
                    let d: Float? = Float(c) ?? nil
                    if d != nil {
                        self.activeTextInput!.stringValue = self.activeTextInput!.stringValue + button.titleLabel!.text!
                    } else {
                        print("provide proper float value")
                    }
            }
        }
    }
}
