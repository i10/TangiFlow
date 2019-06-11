//
//  ArcManager.swift
//  Test1
//
//  Created by Asif Mayilli on 11/9/18.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import SpriteKit
import SwiftyJSON
import MultiTouchKitSwift
class ArcManager:MTKButtonDelegate{
    var inputArcNames:[String] = []
    var inputArcs:[Arc] = []
    var outputArcs:[Arc] = []
    var node:Node?
    var spacing:CGFloat = 0.0523599
    var outputArcsAmount:Int = 1
    var inputArcsAmount:Int = 1
    var currentArc:Arc?
    var inputOffset:CGFloat {
        get { return (CGFloat.pi - CGFloat((self.inputArcsAmount+1))*self.spacing)/CGFloat(self.inputArcsAmount) }
    }
    var outputOffset:CGFloat {
        get { return (CGFloat.pi - CGFloat((self.outputArcsAmount+1))*self.spacing)/CGFloat(self.outputArcsAmount) }
    }
    
    init(node:Node,json:JSON){
        self.node = node
        self.inputArcsAmount = (self.node?.maxInput)!
        self.outputArcsAmount = (self.node?.maxOutput)!
    }
    
    func drawArcs(){
        self.drawOutputArcs()
        self.drawInputArcs()
    }
    
    func drawInputArcs(){
        let radius: CGFloat = self.node!.isSmall ? 21.0 : 86.0
        
        for index in 0..<self.inputArcsAmount{
            let rotateAngle = CGFloat.pi + ( CGFloat(self.inputOffset) + CGFloat(spacing))*CGFloat(index)
            let section = Arc(angle: CGFloat(self.inputOffset),
                              radius: radius,
                              isInput: true,
                              rotation:CGFloat(rotateAngle),
                              name:Array(self.node?.mainArgDicts.keys ?? [:].keys)[index],
                              parentNode:self.node!)
            self.node?.addChild(section)
            self.inputArcs.append(section)
            section.alias = self.node?.mainArgDicts[section.name!]?.stringValue ?? ""
        }
        
    }
    
    
    func drawOutputArcs(){
        let radius: CGFloat = self.node!.isSmall ? 21.0 : 86.0
        
        for index in 0..<self.outputArcsAmount{
                let rotateAngle =  ( CGFloat(self.outputOffset) + CGFloat(spacing))*CGFloat(index)
                let section = Arc(angle: CGFloat(self.outputOffset),
                                  radius: radius, isInput: false,
                                  rotation: CGFloat(rotateAngle),
                                  parentNode: self.node!)
                self.node?.addChild(section)
                self.outputArcs.append(section)
            let close = MTKButton(size: CGSize(width: 20, height: 20), image: "close")
            close.add(target: self, action: #selector(self.removeArc(button:)))
            if self.outputArcs.count != 1 {
                section.drawX(angle: section.polarAngle,button: close)
                
            }
        }
        
        
    }
    
    
    func addOutputArc(){
        let radius: CGFloat = self.node!.isSmall ? 21.0 : 86.0
        
        if self.outputArcsAmount < 6 {
            self.outputArcsAmount += 1
            let section = Arc(angle: CGFloat(self.outputOffset), radius: radius, isInput: false, parentNode: self.node!)
            self.outputArcs.append(section)
            for index in 0..<self.outputArcs.count{
                self.outputArcs[index].zRotation = ( CGFloat(self.outputOffset) + CGFloat(spacing))*CGFloat(index)
                self.outputArcs[index].redrawArc(with: CGFloat(self.outputOffset))
                let close = MTKButton(size: CGSize(width: 20, height: 20), image: "close")
                
                close.add(target: self, action: #selector(self.removeArc(button:)))
                self.outputArcs[index].drawX(angle: self.outputArcs[index].polarAngle ,button: close)
                }
            
        }
        //section.drawX(angle: section.angle!)
    }
    
    @objc func removeArc(button:MTKButton){
        self.outputArcsAmount -= 1
        var arc = self.outputArcs.filter{$0.id == button.name!}[0]
        if let activity = TraceToActivity.getActivity(by: arc){
            
            activity.to?.parentNode?.inArgs[activity.to!.name!] = nil
            //arc.edges[0].to?.parentNode
            TraceToActivity.removeActivity(activity: activity)
        }
        
        
        arc.closeButton?.removeFromParent()
        arc.removeFromParent()
        self.outputArcs = self.outputArcs.filter{$0.id != button.name!}
        
        for index in 0..<self.outputArcs.count{
            self.outputArcs[index].zRotation = ( CGFloat(self.outputOffset) + CGFloat(spacing))*CGFloat(index)
            self.outputArcs[index].redrawArc(with: CGFloat(self.outputOffset))
            self.outputArcs[index].closeButton?.removeFromParent()
            if self.outputArcs.count != 1 {
                let close = MTKButton(size: CGSize(width: 20, height: 20), image: "close")
                
                close.add(target: self, action: #selector(self.removeArc(button:)))
                    self.outputArcs[index].drawX(angle: self.outputArcs[index].polarAngle ,button: close)}
        }
    }
}
