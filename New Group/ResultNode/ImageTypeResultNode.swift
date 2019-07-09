//
//  ImageTypeResultNode.swift
//  backendtest
//
//  Created by Asif Mayilli on 4/13/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation
import SpriteKit
class ImageTypeResultNode:SKSpriteNode{
    var slider:Slider = Slider(min: 1, max: 10, step: 0.2, defaultVal: 1)
    
    var zoom:CGFloat = 1.0
    var originalHeight:CGFloat = 0
    var originalWidth:CGFloat = 0
    var id:String = ""
    var url:String = ""
    var sizeValue:CGFloat = 300
    var image:NSImage?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(texture: SKTexture?, color: NSColor, size: CGSize) {
        super.init(texture:texture,color:color,size:size)
        
    }
    
    convenience init(data:JSON,sizeValue:CGFloat = 300){
        self.init()
        self.sizeValue = sizeValue
        self.url = data["img"].stringValue
        self.image = NSImage(byReferencing: URL(fileURLWithPath: self.url))
        self.texture = SKTexture(image: image!)
        self.position = CGPoint(x: 0, y: -300)
        var factor = image!.size.height/image!.size.width
        self.scaleTo(image: image!, factor: factor)

        self.originalWidth = self.size.width
        self.originalHeight = self.size.height
        //self.position = CGPoint(x: 0, y: -self.size.height  - 100)
        self.position = CGPoint(x: 0, y: -400-100)
        self.reloadImage(zoom: zoom)
    }
    
    convenience init(url:String){
        self.init()
        self.url = url
        self.image = NSImage(byReferencing: URL(fileURLWithPath: self.url))
        self.texture = SKTexture(image: image!)
        self.position = CGPoint.zero
        var factor = image!.size.height/image!.size.width
        self.scaleTo(image: image!, factor: factor)
        self.originalWidth = self.frame.width
        self.originalHeight = self.frame.height
        //self.position = CGPoint(x: 0, y: -self.size.height  - 100)
        self.position = CGPoint(x: 0, y: -400-100)
        self.reloadImage(zoom: zoom)
    }
    
    convenience init(url:URL){
        self.init()
        //self.url = url
        self.image = NSImage(byReferencing: url)
        self.texture = SKTexture(image: image!)
        self.position = CGPoint.zero
        var factor = image!.size.height/image!.size.width
        self.scaleTo(image: image!, factor: factor)
        self.originalWidth = self.frame.width
        self.originalHeight = self.frame.height
        //self.position = CGPoint(x: 0, y: -self.size.height  - 100)
        self.position = CGPoint(x: 0, y: -400-100)
        self.reloadImage(zoom: zoom)
        
    }
    
    func reloadImage(zoom:CGFloat){
    
        self.zoom = zoom
       
        
        self.size.width = self.originalWidth*zoom
        self.size.height = self.originalHeight*zoom
       // self.position = self.position
        self.slider.position.y = self.size.height/2+50
        if zoom == 1.0{
            self.position.y = -400-100
            return
        }
        
        
       
        self.position.y =  -400-100 - (self.size.height/2 - self.originalHeight/2)
        
    }
    
    func setSlider(){
        
        self.slider.removeFromParent()
        if let node = self.parent as? Node{
            node.zoomSlider?.removeFromParent()
            node.zoomSlider = self.slider
            self.slider = Slider(min: 1, max: 10, step: 0.2, defaultVal: node.zoomValue)
        }
        slider.image = self
        var label = SKLabelNode(text: "Zoom")
        slider.addChild(label)
        label.position = CGPoint(x: -220, y: -10)
        self.addChild(slider)
//        if let node = self.parent as? Node{
//            node.zoomSlider?.removeFromParent()
//            node.zoomSlider = self.slider
//        }
        
        slider.position = CGPoint(x: 0, y: self.size.height/2+50)
    }
    
    
    
    func scaleTo(image:NSImage,factor:CGFloat){
        if image.size.width > sizeValue || image.size.height > sizeValue{
            
            if image.size.width > image.size.height {
                self.size = CGSize(width: sizeValue, height: sizeValue*factor)
            } else {
                self.size = CGSize(width: sizeValue/factor, height: sizeValue)
            }
            
        }else{
            self.size = CGSize(width: image.size.width, height: image.size.height)
        }
    }
}


