//
//  Arc.swift
//  Test1
//
//  Created by Asif Mayilli on 11/9/18.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import SpriteKit

class Arc:SKShapeNode{
    var pathToDraw:CGMutablePath = CGMutablePath()
    var startAngle:CGFloat = CGFloat(3.0 * Double.pi/2)
    var isInput:Bool = false
    let angleFactor:[Bool:CGFloat] = [true:-1.0,false:1.0]
    let colors:[Bool:NSColor] = [true:.green,false:.red]
    var isAvailable:Bool = true
    var width:CGFloat = 1
    var segmentRadius:CGFloat = 20
    var angle:CGFloat?
    var radius:CGFloat?
    var localPos:CGPoint?
    var globalPos:CGPoint?
    var id:String?
    var edges:[Edge] = []
    var multipleEdges:Bool = false
    var popped:Bool = false
    var canAdd:Bool {
        get{
            if multipleEdges {
                return true
                
            }else if edges.isEmpty{
                return true
            }
            return false
        }
    }
    
    override init() {
        super.init()
        
    }
    
    init(angle:CGFloat,radius:CGFloat,isInput:Bool,rotation:CGFloat){
        super.init()
        self.id = UUID().uuidString
        self.angle = angle
        self.radius = radius
        self.isInput = isInput
        self.drawArc(angle: angle, radius: radius, isInput: isInput, rotation: rotation)
        self.position = CGPoint(x: 0, y: 0)
        self.strokeColor = colors[self.isAvailable]!
        self.fillColor = colors[self.isAvailable]!
        self.lineWidth = self.width
        self.zRotation = rotation
        self.zPosition = -1
    }
    
    convenience init(position:CGPoint,angle:CGFloat,radius:CGFloat,isInput:Bool,rotation:CGFloat){
        self.init(angle:angle,radius:radius,isInput:isInput,rotation:rotation)
        self.globalPos = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func redrawArc(with factor:Int){
       
        self.removeFromParent()
        if(factor==1 && !popped){
            
            self.radius = self.radius! + self.segmentRadius
            self.segmentRadius = 2*self.segmentRadius
            self.popped = true
        } else if(factor == -1 && popped && self.edges.isEmpty){

            self.radius = self.radius! - self.segmentRadius/2
            self.segmentRadius = self.segmentRadius/2
            self.popped = false
        }
        
        self.drawArc(angle: self.angle!, radius: self.radius!, isInput: self.isInput, rotation: self.zRotation)

    }
    
    
    func drawArc(angle:CGFloat,radius:CGFloat,isInput:Bool,rotation:CGFloat){
        self.pathToDraw  = CGMutablePath()
        self.pathToDraw.move(to: CGPoint(x: 0, y: -radius))
        self.pathToDraw.addLine(to: CGPoint(x:0,y:-radius+self.segmentRadius))
        
        self.pathToDraw.addArc(center: CGPoint.zero,
                          radius: radius-self.segmentRadius,
                          startAngle: startAngle,
                          endAngle: startAngle + angle,
                          clockwise: false)
        self.pathToDraw.addLine(to: CGPoint(x:radius*cos(startAngle+angle),y:radius*sin(startAngle+angle)))
        self.pathToDraw.addArc(center: CGPoint.zero,
                          radius: radius,
                          startAngle: startAngle + angle,
                          endAngle: startAngle,
                          clockwise: true)
        self.path = self.pathToDraw
    }
    
    func addEdge(edge:Edge){
        if self.multipleEdges  {
            self.edges.append(edge)
        }else{
            if self.edges.count == 0 {
                self.edges.append(edge)
            }else{
                print("I AM HUGE NASTY EXCEPTION")
                NSException(name:NSExceptionName(rawValue: "CanNotPutEdge"), reason:"Arc can not accept more edge", userInfo:nil).raise()
            }
        }
    }
    
    func removeEdge(edge:Edge){
        self.edges = self.edges.filter{$0.id != edge.id}
    }
    
    func changeArcColor(){
        if (!self.edges.isEmpty && !self.multipleEdges){
            self.strokeColor = NSColor.red
            self.fillColor = NSColor.red
        }else if(self.edges.isEmpty){
            self.strokeColor = NSColor.green
            self.fillColor = NSColor.green
        }
    }
}
