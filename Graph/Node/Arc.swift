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
    var parentNode:Node?
    var pathToDraw:CGMutablePath = CGMutablePath()
    var startAngle:CGFloat = CGFloat(3.0 * Double.pi/2)
    var isInput:Bool = false
    let colors:[Bool:NSColor] = [true:NSColor(calibratedRed: 111.0/255.0, green: 195.0/255.0, blue: 223.0/255.0, alpha: 1.0),
                                 false:NSColor(calibratedRed: 255.0/255.0, green: 230.0/255.0, blue: 77.0/255.0, alpha: 1.0)]
    var segmentRadius:CGFloat = 30
    var angle:CGFloat?
    var radius:CGFloat?
    var localPos:CGPoint?
    var globalPos:CGPoint?
    var id:String?
    var edges:[Edge] = []
    var rotationAngle:CGFloat?
    var popped:Bool = false
    var alias:String = ""
    var canAdd:Bool {
        get{
            return edges.isEmpty
        }
    }
    
    var polarAngle:CGFloat{
        get {
            return self.angle!/2.0 + self.zRotation + self.startAngle
        }
    }
    
    override init() {
        super.init()
        
    }
    
    init(angle:CGFloat,radius:CGFloat,isInput:Bool,rotation:CGFloat=0,name:String="",parentNode:Node){
        super.init()
        self.id = UUID().uuidString
        self.angle = angle
        self.radius = radius
        self.isInput = isInput
        self.drawArc(angle: angle, radius: radius, isInput: isInput, rotation: rotation)
        self.position = CGPoint(x: 0, y: 0)
        self.strokeColor = colors[self.canAdd]!
        self.fillColor = colors[self.canAdd]!
        self.lineWidth = 1
        self.zRotation = rotation
        self.zPosition = -1
        self.name = name
        self.parentNode = parentNode
        self.setLocation()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func redrawArc(with factor:Int){
        let parent = self.parent
        self.removeFromParent()
        if(factor==1 && !popped){
            
            self.radius = self.radius! + self.segmentRadius*0.5
            self.segmentRadius = 1.5*self.segmentRadius
            self.popped = true
        } else if(factor == -1 && popped && self.edges.isEmpty){
            
            self.radius = self.radius! - (self.segmentRadius/1.5)*0.5
            self.segmentRadius = self.segmentRadius/1.5
            self.popped = false
        }
        
        self.drawArc(angle: self.angle!, radius: self.radius!, isInput: self.isInput, rotation: self.zRotation)
        parent?.addChild(self)
    }
    
    func redrawArc(with angle:CGFloat){
        self.removeFromParent()
        self.angle = angle
        self.drawArc(angle: angle, radius: self.radius!, isInput: self.isInput, rotation: self.zRotation)
        self.parentNode?.addChild(self)
        self.setLocation()
        for item in self.edges{
            item.redrawEdge(from: item.from!.globalPos!, to: item.to!.globalPos!)
        }
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
        if !self.edges.contains(edge){
            if self.edges.count == 0 {
                self.edges.append(edge)
            }else{
                NSException(name:NSExceptionName(rawValue: "CanNotPutEdge"), reason:"Arc can not accept more edge", userInfo:nil).raise()
            }
        }
    }
    
    func removeEdge(edge:Edge?){
        guard let edge = edge else {return}
        self.edges = self.edges.filter{$0.id != edge.id}
        self.changeArcColor()
    }
    
    func changeArcColor(){
        self.strokeColor = self.colors[self.canAdd]!
        self.fillColor = self.colors[self.canAdd]!
    }
    
    
    func setLocation(){
        self.localPos = CoordinateConverter.polarToDecart(radius: self.radius!, angle: self.polarAngle)
        self.globalPos = CoordinateConverter.localToGlobal(node: self.parentNode!, coords: self.localPos!)
    }
    
    func drawLabel(angle:CGFloat){
        let label:SKLabelNode = SKLabelNode()
        
        label.zRotation = angle + CGFloat.pi
        label.zPosition = 4
        label.fontSize = 20
        label.horizontalAlignmentMode = .right
        label.text = self.alias
        print("I AM WIDTH")
        print(label.frame.width)
        label.position = CoordinateConverter.polarToDecart(radius: self.radius! + 40, angle: angle+0.1)
        var backgroundNode:SKShapeNode = SKShapeNode(rectOf: CGSize(width: label.frame.width+20, height:40) )
        backgroundNode.fillColor = NSColor(calibratedRed: 111.0/255.0, green: 195.0/255.0, blue: 223.0/255.0, alpha: 0.5)
        backgroundNode.position.y = 5
        backgroundNode.position.x = -label.frame.width/2
        
        label.addChild(backgroundNode)
        self.parentNode?.addChild(label)
    }
}
