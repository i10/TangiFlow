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
    var id:String = ""
    var url:String = ""
    var sizeValue:CGFloat = 350
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(texture: SKTexture?, color: NSColor, size: CGSize) {
        super.init(texture:texture,color:color,size:size)
    }
    
    convenience init(data:JSON,sizeValue:CGFloat = 350){
        self.init()
        self.sizeValue = sizeValue
        self.url = data["img"].stringValue
        let image = NSImage(byReferencing: URL(fileURLWithPath: self.url))
        self.texture = SKTexture(image: image)
        self.position = CGPoint(x: 0, y: -320)
        var factor = image.size.height/image.size.width
        
        
        
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
    
    convenience init(url:String){
        self.init()
        self.url = url
        let image = NSImage(byReferencing: URL(fileURLWithPath: self.url))
        self.texture = SKTexture(image: image)
        self.position = CGPoint.zero
      //  print(image.)
        var factor = image.size.height/image.size.width
        
        
        
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
    
    convenience init(url:URL){
        self.init()
        //self.url = url
        let image = NSImage(byReferencing: url)
        self.texture = SKTexture(image: image)
        self.position = CGPoint.zero
        var factor = image.size.height/image.size.width
        
        
        
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
    
    func reloadImage(){
        
    }
}
