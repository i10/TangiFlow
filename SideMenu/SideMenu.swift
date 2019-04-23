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
class SideMenu:SKNode,MTKButtonDelegate{
    var nodeList:[MTKButton] = []
    var tangibleData:[String:Any] = [:]
    var tangibleButtons:[MTKButton] = []
    var view:SKView?
//    var scene:GameScene?
    override init() {
        super.init()
        let frame = SKShapeNode(rectOf: CGSize(width: 365, height: 800))
        let openButton = MTKButton(size: CGSize(width: 50, height: 50), label: ">")
        
        openButton.add(target: self, action: #selector(self.buttonTapped(button:)))
        openButton.zPosition = 4
        self.addChild(openButton)
        openButton.position = CGPoint(x: 208, y: 30)
        
        frame.fillColor = NSColor.white
        self.position = CGPoint(x: -180, y: 500)
        self.addChild(frame)
    }
    
    
    convenience init(json:[String:Any],view:SKView,scene:GameScene) {
        self.init()
        self.tangibleData = json
        var y = -200
        self.view = view
        //self.scene = scene
        for item in self.tangibleData.keys {
            
            let openButton = MTKButton(size: CGSize(width: 365, height: 150), label: "\(item)")
            
            openButton.add(target: self, action: #selector(self.buttonTapped(button:)))
            openButton.zPosition = 4
            self.addChild(openButton)
            openButton.position = CGPoint(x: 0, y: y)
            y=y+155
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("decoder init is not implemented")
    }
    
    @objc func buttonTapped(button: MTKButton) {
        if button.titleLabel?.text == ">" {
            print("I am working")
            let action = SKAction.move(to: CGPoint(x: 180, y: 500), duration: 1)
            button.titleLabel?.text = "<"
            self.run(action)
        } else if button.titleLabel?.text == "<"{
            let action = SKAction.move(to: CGPoint(x: -180, y: 500), duration: 1)
            button.titleLabel?.text = ">"
            self.run(action)
        } else {
            let node = Node(id: button.titleLabel!.text!, position: CGPoint(x: 500, y: 500), out: 1, tangibleDict: self.tangibleData[button.titleLabel!.text!]!, view: self.view!)
            (self.scene as! GameScene).graph?.addNode(node: node)
        }
    }
    

}
