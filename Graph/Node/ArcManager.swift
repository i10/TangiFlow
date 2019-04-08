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
    var inputArcNames:[String] = []
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
    
    init(node:Node,tangibleDict:Any){
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
            section.parentNode = node
            if !node!.funcName.contains("terminal"){
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
        }
        if(self.rotateAngle==0){
            self.rotateAngle =  CGFloat.pi
        }
        
        self.rotateAngle = self.rotateAngle + self.spacing
        for index in 0..<self.inputArcsAmount{
            let section = Arc(angle: CGFloat(self.inputOffset), radius: 110, isInput: true, rotation:CGFloat(rotateAngle))
            section.name = self.inputArcNames[index]
            section.parentNode = node
            
            let angle = section.angle!/2.0 + self.rotateAngle + section.startAngle
            
            section.localPos = self.polarToDecart(radius: section.radius!, angle: angle)
            section.globalPos = self.localToGlobal(node: self.node!, coords: section.localPos!)
            rotateAngle = rotateAngle + CGFloat(self.inputOffset) + CGFloat(spacing)
            self.node?.addChild(section)
            self.inputArcs.append(section)
            if(self.node?.maxInput == Int.max){
                section.multipleEdges = true
            }
            
            //section.drawLabel(name: section.name ?? "")
            let label:SKLabelNode = SKLabelNode()
            label.position = self.polarToDecart(radius: section.radius!+90, angle: angle+0.1)
            label.zRotation = angle + CGFloat.pi
            label.zPosition = 4
            label.fontSize = 30
            //        label.zRotation = 3*CGFloat.pi/2 + self.angle!
            label.text = section.name
            self.node?.addChild(label)
        }
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
}
