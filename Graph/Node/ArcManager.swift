//
//  ArcManager.swift
//  Test1
//
//  Created by Asif Mayilli on 11/9/18.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import SpriteKit
class ArcManager{
    var counter = 0
    var inputArcs:[Arc] = []
    var outputArcs:[Arc] = []
    var node:Node?
    var scene:SKScene?
    var inputOffset:CGFloat = CGFloat.pi
    var outputOffset:CGFloat = CGFloat.pi
    var spacing:CGFloat = 0.0523599
    var rotateAngle:CGFloat = 0
    var outputArcsAmount:Int = 1
    var inputArcsAmount:Int = 1
    var currentArc:Arc?
    
    init(node:Node){
        self.node = node
        if self.node?.maxInput != Int.max{
            self.inputArcsAmount = (self.node?.maxInput)!
        }
        if self.node?.maxOutput != Int.max{
            self.outputArcsAmount = (self.node?.maxOutput)!
            
        }
        
        self.inputOffset = (CGFloat.pi - CGFloat((self.inputArcsAmount+1))*self.spacing)/CGFloat(self.inputArcsAmount)
        self.outputOffset = (CGFloat.pi - CGFloat((self.outputArcsAmount+1))*self.spacing)/CGFloat(self.outputArcsAmount)
        
    }
    
    func drawArcs(){
        for _ in 0..<self.outputArcsAmount{
            let section = Arc(angle: CGFloat(self.outputOffset), radius: 110, isInput: false,rotation:CGFloat(rotateAngle))
            let angle = section.angle!/2.0 + self.rotateAngle + section.startAngle
            section.localPos = self.polarToDecart(radius: section.radius!, angle: angle)
            section.globalPos = self.localToGlobal(node: self.node!, coords: section.localPos!)
            self.rotateAngle = self.rotateAngle + CGFloat(self.outputOffset) + CGFloat(spacing)
            self.node?.addChild(section)
            self.outputArcs.append(section)
            
            if(self.node?.maxOutput == Int.max){
                section.multipleEdges = true
            }
        }
        if(self.rotateAngle==0){
            self.rotateAngle =  CGFloat.pi
        }
        
        self.rotateAngle = self.rotateAngle + self.spacing
        for _ in 0..<self.inputArcsAmount{
            let section = Arc(angle: CGFloat(self.inputOffset), radius: 110, isInput: true, rotation:CGFloat(rotateAngle))
            let angle = section.angle!/2.0 + self.rotateAngle + section.startAngle
            
            section.localPos = self.polarToDecart(radius: section.radius!, angle: angle)
            section.globalPos = self.localToGlobal(node: self.node!, coords: section.localPos!)
            rotateAngle = rotateAngle + CGFloat(self.inputOffset) + CGFloat(spacing)
            self.node?.addChild(section)
            self.inputArcs.append(section)
            if(self.node?.maxInput == Int.max){
                section.multipleEdges = true
            }
        }
    }
    
    func getArc(with id:String)->Arc?{
        let arcs = self.inputArcs + self.outputArcs
        if !arcs.isEmpty{
            return arcs.filter {$0.id == id}[0]
        }
        return nil
    }
    
    func getArc(with coord:CGPoint)->Arc{
        return Arc()
    }
    
    
    func polarToDecart(radius:CGFloat,angle:CGFloat)->CGPoint{
        let x = radius*cos(angle)
        let y = radius*sin(angle)
        return CGPoint(x: x, y: y)
        
    }
    
    func localToGlobal(node:SKNode,coords:CGPoint) -> CGPoint{
        let x = node.position.x + coords.x
        let y = node.position.y + coords.y
        return CGPoint(x:x,y:y)
    }
    
    func popArc(at position:CGPoint){
        if !(self.scene?.nodes(at: position).isEmpty)!{
            if let a = self.scene?.nodes(at: position)[0] as? Arc{
                var parent = a.parent
                var currentParent = self.currentArc?.parent
                if self.currentArc != nil{
                    if a.id != self.currentArc?.id{
                        self.currentArc?.redrawArc(with: -1)
                        currentParent?.addChild(self.currentArc!)
                        a.redrawArc(with: 1)
                        parent?.addChild(a)
                        self.currentArc = a
                    }
                }else {
                    self.currentArc = a
                    a.redrawArc(with: 1)
                    parent?.addChild(a)
                }
            }
        }else {
            let parent = self.currentArc?.parent
            self.currentArc?.redrawArc(with: -1)
            parent?.addChild(self.currentArc!)
            self.currentArc = nil
        }
        
        
        
        
    }
    
    func getArc(at position:CGPoint)->Arc?{
        if !(self.scene?.nodes(at: position).isEmpty)!{
            if let a = self.scene?.nodes(at: position)[0] as? Arc{
                return a
            }
        }
        return nil
    }
    
}
