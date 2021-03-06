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
class SideMenuTest:SKNode,MTKButtonDelegate{
    var menuStruct:[MTKButton:[[MTKButton]]] = [:]
    var right:Bool = true
    var nodeList:[MTKButton] = []
    var tangibleData:JSON?
    var tangibleButtons:[MTKButton] = []
    var chunked:[[MTKButton]] = []
    var aliases:[String:String] = [:]
    var view:SKView?
    var page:Int = 0
    var backToMain:MTKButton =  MTKButton(size: CGSize(width: 365, height: 150), label: "← Back")
    var backButton:MTKButton = MTKButton(size: CGSize(width: 150, height: 100), label: "<")
    var forwardButton:MTKButton = MTKButton(size: CGSize(width: 150, height: 100), label: ">")
    var infoNode:SKNode?
    //    var scene:GameScene?
    override init() {
        super.init()
        let frame = SKShapeNode(rectOf: CGSize(width: 365, height: 1100))
        frame.fillColor = NSColor.gray
        self.position = CGPoint(x: 180, y: 550)
        self.addChild(frame)
    }
    
    
    convenience init(json:JSON,view:SKView,scene:GameScene) {
        self.init()
        self.backToMain.position = CGPoint(x: 0, y: 450)
        self.backToMain.add(target: self, action: #selector(self.back(button:)))
        self.tangibleData = json
        self.menuStruct = self.decomposeJSON(json:json)
        self.view = view
        //self.scene = scene
        forwardButton.set(color: NSColor(calibratedRed: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0))
        backButton.set(color: NSColor(calibratedRed: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0))
        
        forwardButton.add(target: self, action: #selector(self.forwardBack(button:)))
        backButton.add(target: self, action: #selector(self.forwardBack(button:)))
        backToMain.set(color: NSColor(calibratedRed: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0))
        forwardButton.position = CGPoint(x: 90, y: -480)
        backButton.position = CGPoint(x: -90, y: -480)
        
        self.drawMenu()
        
        var label = SKLabelNode(text: "Choose function")
        label.position = CGPoint(x: 0, y: 600)
        self.addChild(label)
        
        
    }
    
    //this function draws toolbars. 
    //In case there to many elements in menu it divides it into chunks of 6 and adds navigation button
    //argument 'item' is nil when the user in outer level of the menu. 
    //If item is not nil it means user has selected some item from the menu and drawMenu should draw inner level
    func drawMenu(item:MTKButton? = nil,chunked:Bool = false){
        self.forwardButton.removeFromParent()
        self.backButton.removeFromParent()
        self.addChild(forwardButton)
        self.addChild(backButton)
        if !chunked{
            if let item = item {
                if !menuStruct[item]!.isEmpty{
                    self.chunked = self.menuStruct[item]!
                    self.page = 0
                }
            }else{
                self.chunked = Array(self.menuStruct.keys).chunked(into: 6)
                self.page = 0
            }
        
            for item in tangibleButtons{
                item.removeFromParent()
            }
            self.tangibleButtons = []
            var y = 250
            if !self.chunked.isEmpty{
                for item in self.chunked[page]{
                    self.tangibleButtons.append(item)
                    self.addChild(item)
                    item.position = CGPoint(x: 0, y: y)
                    y=y-135
                }
                
            }
        }else{
            for item in tangibleButtons{
                item.removeFromParent()
            }
            self.tangibleButtons = []
            var y = 250
            for item in self.chunked[page]{
                self.tangibleButtons.append(item)
                self.addChild(item)
                item.position = CGPoint(x: 0, y: y)
                y=y-135
            }
        }
        if self.chunked.count == 1 {
            forwardButton.removeFromParent()
            backButton.removeFromParent()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("decoder init is not implemented")
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
        self.drawMenu(chunked: true)
    }
    /**
        Based on projects json file this function populates toolbars with functions
    */
    func decomposeJSON(json:JSON) -> [MTKButton:[[MTKButton]]]{
        //list of group titles
        var groupSets = Set<String>()
        //menu structure
        var menuStruct:[MTKButton:[[MTKButton]]] = [:]
        
        for (key,_) in json{
            if !json[key]["group_id"].stringValue.isEmpty{
                groupSets.insert(json[key]["group_id"].stringValue)
            } else{
                groupSets.insert(key)
            }
        }
        
        groupSets = groupSets.filter{$0 != "config"}
        
        for item in groupSets{
            
            var button = MTKButton(size: CGSize(width: 350, height: 130), label: "\(item)")
            
            var subMenuItems:[[MTKButton]] = []
            var tempSubmenuItems:[MTKButton] = []
            let subMenu = json.filter{key,value in
                value["group_id"].stringValue == item
            }
            for item in subMenu{
                //if item[]
                
                var button = MTKButton(size: CGSize(width: 350, height: 130), label: "\(item.1["alias"].stringValue)")
                button.add(target: self, action: #selector(self.buttonTapped(button:)))
                if !item.1["info"].isEmpty{
                    var smallButton = MTKButton(size: CGSize(width: 25, height: 25), image: "info")
                    smallButton.add(target: self, action: #selector(self.info(button:)))
                    smallButton.set(color: NSColor.red)
                    button.addChild(smallButton)
                    smallButton.position = CGPoint(x: -160, y: 50)
                }
                button.name = item.0
                tempSubmenuItems.append(button)
            }
            if tempSubmenuItems.isEmpty{
                button.titleLabel?.text = json[item]["alias"].stringValue
                button.add(target: self, action: #selector(self.buttonTapped(button:)))
                button.name = item
            }else{
                button.add(target: self, action: #selector(self.menuButtonTapped(button:)))
            }
            subMenuItems = tempSubmenuItems.chunked(into: 6)
            print(subMenuItems)
            menuStruct[button] = subMenuItems
        }
        
        return menuStruct
    }
    @objc func buttonTapped(button: MTKButton) {
        
            var point = CGPoint()
            if self.right{
                point = CGPoint(x: self.position.x-400, y: self.position.y)
            }
                
            else {
                point = CGPoint(x: self.position.x+400, y: self.position.y)
            }
            let node = Node(id: button.name!, position: point,  json: self.tangibleData![button.name!] as! JSON, view: self.view!)
            (self.scene as! GameScene).graph?.addNode(node: node)
        
    }
    
    @objc func menuButtonTapped(button: MTKButton) {
        self.drawMenu(item: button)
        self.addChild(self.backToMain)
    }
    
    @objc func back(button:MTKButton){
        self.drawMenu()
        self.backToMain.removeFromParent()
    }
    
    @objc func info(button:MTKButton){
        //var image = self.tangibleData[button.name]
        self.infoNode?.removeFromParent()
        self.infoNode = SKNode()
        let image = ImageTypeResultNode(data: self.tangibleData![button.parent!.name!]["info"])
        image.reloadImage(zoom: 1.5)
        var x:CGFloat = 0.0
        var y:CGFloat = 0.0
        if self.right{
            x = -370
            
        }else{
            x = 540}
        y = (button.parent?.position.y)! + 50
        image.position = CGPoint(x: 0, y: 0)
        self.infoNode?.position = CGPoint(x: x-80, y: y)
        self.infoNode?.addChild(image)
        var close = MTKButton(size: CGSize(width: 20, height: 20), image: "close.png")
        close.set(color: NSColor.red)
        self.infoNode?.addChild(close)
        self.addChild(self.infoNode!)
        close.position = CGPoint(x:-((self.infoNode?.calculateAccumulatedFrame().width)!/2 + 10),
                                 y:((self.infoNode?.calculateAccumulatedFrame().height)!/2 + 10))
        close.zPosition = 2
        close.add(target: self, action: #selector(self.close(button:)))
        //self.infoNode?.addChild(image)
        
    }
    
    
    @objc func close(button:MTKButton){
        self.infoNode?.removeFromParent()
    }
}





