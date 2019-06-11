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
    var right:Bool = true
    var nodeList:[MTKButton] = []
    var tangibleData:JSON?
    var tangibleButtons:[MTKButton] = []
    var chunked:[[String]] = []
    var aliases:[String:String] = [:]
    var view:SKView?
    var page:Int = 0
//    var scene:GameScene?
    override init() {
        super.init()
        let frame = SKShapeNode(rectOf: CGSize(width: 365, height: 1100))
        let openButton = MTKButton(size: CGSize(width: 50, height: 50), label: ">")
        
        //openButton.add(target: self, action: #selector(self.buttonTapped(button:)))
        //openButton.zPosition = 4
        //self.addChild(openButton)
      //  openButton.position = CGPoint(x: 208, y: 30)
        
        frame.fillColor = NSColor.gray
        self.position = CGPoint(x: 180, y: 800)
        self.addChild(frame)
    }
    
    
    convenience init(json:JSON,view:SKView,scene:GameScene) {
        self.init()
        
        self.tangibleData = json
        var keys = Array((self.tangibleData?.dictionaryValue.keys)!).filter{$0 != "config"}
        for item in keys{
            aliases[item] = json[item]["alias"].stringValue
        }
        self.chunked = Array(aliases.keys).chunked(into: 6)
        self.view = view
        //self.scene = scene
        var forvardButton = MTKButton(size: CGSize(width: 150, height: 100), label: ">")
        var backButton = MTKButton(size: CGSize(width: 150, height: 100), label: "<")
        forvardButton.add(target: self, action: #selector(self.forwardBack(button:)))
        backButton.add(target: self, action: #selector(self.forwardBack(button:)))
        forvardButton.position = CGPoint(x: 90, y: -480)
        backButton.position = CGPoint(x: -90, y: -480)
        self.addChild(forvardButton)
        self.addChild(backButton)
        self.drawMenu()
        self.decomposeJSON(json:json)
        
        
        
        var label = SKLabelNode(text: "Choose Function")
        label.position = CGPoint(x: 0, y: 600)
        self.addChild(label)
        
        
    }
    
    func drawMenu(){
        for item in tangibleButtons{
            item.removeFromParent()
        }
        self.tangibleButtons = []
        var y = 450
        if !self.chunked.isEmpty{
            for item in self.chunked[page] {
                
                let openButton = MTKButton(size: CGSize(width: 365, height: 150), label: "\(self.aliases[item]!)")
                openButton.name = item
                openButton.add(target: self, action: #selector(self.buttonTapped(button:)))
                openButton.zPosition = 4
                self.tangibleButtons.append(openButton)
                self.addChild(openButton)
                openButton.position = CGPoint(x: 0, y: y)
                y=y-155
                
                
                }
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("decoder init is not implemented")
    }
    
    @objc func buttonTapped(button: MTKButton) {
        if button.titleLabel!.text == ">" {
            let action = SKAction.move(to: CGPoint(x: 180, y: 500), duration: 1)
            button.titleLabel!.text = "<"
            self.run(action)
        } else if button.titleLabel!.text == "<"{
            let action = SKAction.move(to: CGPoint(x: -180, y: 500), duration: 1)
            button.titleLabel!.text = ">"
            self.run(action)
        } else {
            var point = CGPoint()
            if self.right{
                point = CGPoint(x: self.position.x-400, y: self.position.y)
            }
            
            else {
                point = CGPoint(x: self.position.x+400, y: self.position.y)
            }
            let node = Node(id: button.name!, position: point,  json: self.tangibleData![button.name!])
            (self.scene as! GameScene).graph?.addNode(node: node)
        }
    }
    
    
    @objc func forwardBack(button:MTKButton){
        if button.titleLabel?.text == ">"{
            if self.chunked.count-1 == self.page {
                self.page = 0
            } else {
                self.page += 1}
        }else {
            if 0 == self.page {
                self.page = self.chunked.count-1
            }else{
                self.page -= 1}
        }
        self.drawMenu()
    }

    func decomposeJSON(json:JSON) -> [String:[String]]{
        var groupSets = Set<String>()
        var menuStruct:[String:[String]] = [:]
        
        for (key,_) in json{
            if !json[key]["group_id"].stringValue.isEmpty{
                groupSets.insert(json[key]["group_id"].stringValue)
            } else{
                groupSets.insert(json[key]["alias"].stringValue)
            }
        }
        
        groupSets = groupSets.filter{$0 != ""}
        
        for item in groupSets{
            var subMenuItems:[String] = []
            let subMenu = json.filter{key,value in
                value["group_id"].stringValue == item
            }
            for item in subMenu{
                subMenuItems.append(item.0)
            }
            menuStruct[item] = subMenuItems
        }
        
        return menuStruct
    }
}




extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
