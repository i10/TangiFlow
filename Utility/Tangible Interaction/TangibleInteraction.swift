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
    //tangibleList contains ids of all instantiated tangible nodes in the scene
    static var tangibleList:[String] = []
    //tangibleEntities contains all instantiated tangible objects in the scene
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
            
            
            
            
            
        } else{
            var tangibles = TangibleInteraction.tangibleEntities.filter{$0.id == id}
            var nodes = scene.nodes(at: position).filter{$0 is ImageTypeResultNode}
           tangibles[0].view = TangibleInteraction.view
            TangibleInteraction.setTangible(tangible: tangibles[0], nodes: nodes,scene: scene,position: position)
        }
    }
    
    
    class func setTangible(tangible:Tangible,nodes:[SKNode],scene:MTKScene,position:CGPoint){
        if tangible.previousPosition == nil {
            tangible.previousPosition = position
            tangible.position = position
        } else {
            if TangibleInteraction.distance(start: tangible.previousPosition, end: position) > 100 {
                tangible.previousPosition = tangible.position
                tangible.position = position
            }
        }
        
//        tangible.previousPosition = tangible.position
//        tangible.position = position
        tangible.removeFromParent()
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
        var json:JSON = "{\"arguments\" : { \"main_args\" : {}, \"controled_args\" : { \"controled_value\" : { \"alias\" : \"Pasted image\", \"type\" : \"button\"}}}, \"function\" : \"image_source\",\"alias\" :\"Load image\"}"
        
        var node = Node(id: "PT-127.99.01", position: button.parent!.position, json: json, view: TangibleInteraction.view!)
    }
    
    
    class func distance(start:CGPoint?,end:CGPoint?)->CGFloat{
        if let start = start, let end = end {
            let deltax = (start.x - end.x)
            let deltay = (start.y - end.y)
            let distance =  sqrtf(Float(deltax*deltax + deltay*deltay))
            return CGFloat(distance)
        }
       
        return 0.0
    }
}
