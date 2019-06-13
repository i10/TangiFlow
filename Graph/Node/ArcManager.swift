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
        for index in 0..<self.inputArcsAmount{
            let rotateAngle = CGFloat.pi + ( CGFloat(self.inputOffset) + CGFloat(spacing))*CGFloat(index)
            let section = Arc(angle: CGFloat(self.inputOffset),
                              radius: 86.0,
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
        for index in 0..<self.outputArcsAmount{
            let rotateAngle =  ( CGFloat(self.outputOffset) + CGFloat(spacing))*CGFloat(index)
            let section = Arc(angle: CGFloat(self.outputOffset),
                              radius: 86.0, isInput: false,
                              rotation: CGFloat(rotateAngle),
                              parentNode: self.node!)
            self.node?.addChild(section)
            self.outputArcs.append(section)
        }
    }
    
    
    func addOutputArc(){
        if self.outputArcsAmount < 6 {
            self.outputArcsAmount += 1
            let section = Arc(angle: CGFloat(self.outputOffset), radius: 86.0, isInput: false, parentNode: self.node!)
            self.outputArcs.append(section)
            for index in 0..<self.outputArcs.count{
                self.outputArcs[index].zRotation = ( CGFloat(self.outputOffset) + CGFloat(spacing))*CGFloat(index)
                self.outputArcs[index].redrawArc(with: CGFloat(self.outputOffset))
            }
        }
    }
    
    func removeArc(_ arc: Arc, _ activity: TraceToActivity){
        self.outputArcsAmount -= 1
//        if let activity = TraceToActivity.getActivity(by: arc){
            activity.to?.parentNode?.inArgs[activity.to!.name!] = nil
            TraceToActivity.removeActivity(activity: activity)
//        }
        
        arc.removeFromParent()
        self.outputArcs = self.outputArcs.filter{$0.id != arc.id!}

        for index in 0..<self.outputArcs.count{
            self.outputArcs[index].zRotation = ( CGFloat(self.outputOffset) + CGFloat(spacing))*CGFloat(index)
            self.outputArcs[index].redrawArc(with: CGFloat(self.outputOffset))
        }
    }
    
}
