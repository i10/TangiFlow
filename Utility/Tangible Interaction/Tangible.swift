//
//  Tangible.swift
//  MasterAsif2
//
//  Created by PPI on 05.07.19.
//  Copyright © 2019 RWTH Aachen University. All rights reserved.
//

import Foundation
import SpriteKit
import MultiTouchKitSwift

class Tangible: SKNode,MTKButtonDelegate {
    var id:String = ""
    var copyButton:MTKButton = MTKButton(size: CGSize(width: 20, height: 20), label: "")
    var cloneButton:MTKButton = MTKButton(size: CGSize(width: 20, height: 20), label: "")
    var image:String = ""
    var view:SKView? = nil
    var previousPosition:CGPoint? = nil
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init(id:String,view:SKView) {
        self.init()
        self.id = id
        let base:SKShapeNode = SKShapeNode(circleOfRadius: 100)
        base.zPosition = 20
        base.fillColor = NSColor.white
        self.addChild(base)
        var closeButton = MTKButton(size: CGSize(width: 40, height: 40), image: "close.png")
        closeButton.zPosition = 20
        closeButton.position = CGPoint(x: 0, y: 140)
        closeButton.add(target: self, action: #selector(self.close(button:)))
        self.view = view
        self.addChild(closeButton) 
    }
    
    @objc func close(button:MTKButton){
        TangibleInteraction.removeTangible(id: self.id)
    }
    
    /**
    This function adds button with label copy on it near tangible node            
    */
    func addCopy(nodes:[SKNode]){
        self.cloneButton.removeFromParent()
        self.copyButton.removeFromParent()
        self.copyButton = MTKButton(size: CGSize(width: 120, height: 40), label: "copy")
        self.copyButton.add(target: self, action: #selector(self.copyImage(button:)))
        self.copyButton.name = (nodes[0] as! ImageTypeResultNode).url
        self.addChild(self.copyButton)
        self.copyButton.position = CGPoint(x: -180, y: 0)
        self.copyButton.zPosition = 20
    }
     /**
    This function adds button with label paste on it near tangible node            
    */
    func addClone(){
        self.copyButton.removeFromParent()
        self.cloneButton.removeFromParent()
        if let name = copyButton.name{
            self.cloneButton = MTKButton(size: CGSize(width: 120, height: 40), label: "paste")
            self.cloneButton.add(target: self, action: #selector(self.cloneImage(button:)))
            self.cloneButton.name = name
            self.addChild(self.cloneButton)
            //tangible.addChild(copy)
            self.cloneButton.position = CGPoint(x: 180, y: 0)
            self.cloneButton.zPosition = 20
        }
    }
    
    @objc func copyImage(button:MTKButton){
        if let tangible = button.parent as? Tangible {
            print(button.name)
            tangible.image = button.name!
            var fileManager = FileManager.default
            button.setScale(0.6)
            do{
                try fileManager.copyItem(at: URL(fileURLWithPath: button.name!), to: URL(fileURLWithPath:"/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/Files/Copy/\(tangible.id).jpg"))
                tangible.image = "/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/Files/Copy/\(tangible.id).jpg"
            }catch{
                print("FAILED TO COPY")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Change `2.0` to the desired number of seconds.
                // Code you want to be delayed
                button.setScale(1)
            }
        }
    }
    
    
    @objc func cloneImage(button:MTKButton){
      //  var json:JSON = JSON("{\"arguments\" : { \"main_args\" : {}, \"controled_args\" : { \"controled_value\" : { \"alias\" : \"Cloned image\", \"type\" : \"button\"}}}, \"function\" : \"image_source\",\"alias\" :\"Load image\"}")
        button.setScale(0.6)
        var tangible = (button.parent as! Tangible).image
        var json:JSON = [:]
        var empty:JSON = [:]
        json["function"] = "image_sources"
        json["alias"] = "Cloned image"
        json["arguments"] = empty
        
        json["arguments"]["main_args"] = empty
        json["arguments"]["controled_args"] = empty
        json["arguments"]["controled_args"]["controled_value"] = empty
        json["arguments"]["controled_args"]["controled_value"]["alias"] = "Load image"
        json["arguments"]["controled_args"]["controled_value"]["type"] = "button"
        var position = CGPoint(x:button.parent!.position.x - 250,y:button.parent!.position.y)
        var node = Node(id: "PT-127.99.01", position: position, json: json, view: self.view!)
        node.controlElements?.button?.removeFromParent()
        node.sourceData = ImageTypeResultNode(url:tangible)
        (node.sourceData as! ImageTypeResultNode).reloadImage(zoom: node.zoomValue)
        (node.sourceData as! ImageTypeResultNode).setSlider()
        (node.sourceData as! ImageTypeResultNode).url = tangible
        //self.node?.sourceData?.position = CGPoint(x: 0, y: -370)
        node.addChild(node.sourceData!)
        node.sourceUrl = tangible
        (node.sourceData as! ImageTypeResultNode).setSlider()
        
        
        (self.scene as! GameScene).graph?.addNode(node: node)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            button.setScale(1)
        }
    }
}
