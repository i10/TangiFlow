//
//  TangibleInteraction.swift
//  MasterAsif2
//
//  Created by PPI on 05.07.19.
//  Copyright © 2019 RWTH Aachen University. All rights reserved.
//

import Foundation
import MultiTouchKitSwift
class TangibleInteraction:MTKButtonDelegate{
    static var tangibleList:[String] = []
    static var tangibleEntities:[Tangible] = []
    static var view:SKView? = nil
    
    
    class func addTangible(id:String,scene:MTKScene,position:CGPoint){
        if !TangibleInteraction.tangibleList.contains(id){
            TangibleInteraction.tangibleList.append(id)
            var tangibles = TangibleInteraction.tangibleEntities.filter{$0.id == id}
            var nodes = scene.nodes(at: position).filter{$0 is ImageTypeResultNode}
            if tangibles.isEmpty{
                var tangible = Tangible(id: id,view:TangibleInteraction.view!)
                TangibleInteraction.tangibleEntities.append(tangible)
                TangibleInteraction.setTangible(tangible:tangible,nodes: nodes,scene: scene,position: position)
            } else {
                tangibles[0].view = TangibleInteraction.view
                TangibleInteraction.setTangible(tangible: tangibles[0], nodes: nodes,scene: scene,position: position)
            }
            
            
            
            
            
        }
    }
    
    
    class func setTangible(tangible:Tangible,nodes:[SKNode],scene:MTKScene,position:CGPoint){
        tangible.position = position
        scene.addChild(tangible)
        if !nodes.isEmpty{
            tangible.addCopy(nodes: nodes)
            tangible.zPosition = 20
        } else {
            //tangible.copyButton.removeFromParent()
            if tangible.image != "" {tangible.addClone()}
            
//            if let image = NSImage(byReferencingFile: tangible.image){
//
//            }
        }
    }
    
    class func removeTangible(id:String){
        TangibleInteraction.tangibleList = TangibleInteraction.tangibleList.filter{$0 != id}
        var tangibles = TangibleInteraction.tangibleEntities.filter{$0.id == id}
        if !tangibles.isEmpty{
            tangibles[0].removeFromParent()
        }
        //TangibleInteraction.tangibleEntities = TangibleInteraction.tangibleEntities.filter{$0.id != id}
    }
    
    
    
//    @objc func copyImage(button:MTKButton){
//        if let tangible = button.parent as? Tangible {
//            print(button.name)
//            tangible.image = ""
//        }
//    }
    @objc func cloneImage(button:MTKButton){
        var json:JSON = "{\"arguments\" : { \"main_args\" : {}, \"controled_args\" : { \"controled_value\" : { \"alias\" : \"Cloned image\", \"type\" : \"button\"}}}, \"function\" : \"image_source\",\"alias\" :\"Load image\"}"
        
        var node = Node(id: "PT-127.99.01", position: button.parent!.position, json: json, view: TangibleInteraction.view!)
    }
    
}
