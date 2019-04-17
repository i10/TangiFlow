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
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(texture: SKTexture?, color: NSColor, size: CGSize) {
        super.init(texture:texture,color:color,size:size)
    }
    
    convenience init(data:Dictionary<String, AnyObject>){
        self.init()
//        backgroundColor = SKColor.white
//        // 3
//        let image = UIImage(named: "player")
//        let texture = SKTexture(image: image!)
//        player = SKSpriteNode(texture: texture)
//        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        self.url = data["img"] as! String
        let image = NSImage(byReferencing: URL(fileURLWithPath: self.url))
        self.texture = SKTexture(image: image)
        self.position = CGPoint.zero
        var factor = image.size.height/image.size.width
        
        
        
        if image.size.width > 500 || image.size.height > 500{
            
            if image.size.width > image.size.height {
                self.size = CGSize(width: 500, height: 500*factor)
            } else {
                self.size = CGSize(width: 500/factor, height: 500)
            }
            
        }else{
            self.size = CGSize(width: image.size.width, height: image.size.height)
        }
    }
    
    convenience init(url:String){
        self.init()
        //        backgroundColor = SKColor.white
        //        // 3
        //        let image = UIImage(named: "player")
        //        let texture = SKTexture(image: image!)
        //        player = SKSpriteNode(texture: texture)
        //        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        self.url = url
        let image = NSImage(byReferencing: URL(fileURLWithPath: self.url))
        self.texture = SKTexture(image: image)
        self.position = CGPoint.zero
      //  print(image.)
        var factor = image.size.height/image.size.width
        
        
        
        if image.size.width > 500 || image.size.height > 500{
            
            if image.size.width > image.size.height {
                self.size = CGSize(width: 500, height: 500*factor)
            } else {
                self.size = CGSize(width: 500/factor, height: 500)
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
        
        
        
        if image.size.width > 500 || image.size.height > 500{
        
            if image.size.width > image.size.height {
                self.size = CGSize(width: 500, height: 500*factor)
            } else {
                self.size = CGSize(width: 500/factor, height: 500)
                }
            
        }else{
            self.size = CGSize(width: image.size.width, height: image.size.height)
        }
//        if image.size.width > 500 || image.size.height > 500{
//
//            self.size = CGSize(width: image.size.width/2, height: image.size.height/2)
//        } else {
//            self.size = CGSize(width: image.size.width, height: image.size.height)
//        }
        
    }
    
    func reloadImage(){
        
    }
}
