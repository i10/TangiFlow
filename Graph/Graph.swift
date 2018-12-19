//
//  Graph.swift
//  Test1
//
//  Created by Asif Mayilli on 11/1/18.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import SpriteKit
import MultiTouchKitSwift
//TODO:while deleting node delete edge adjacent to this node
class Graph{
    var tangibleToNode:[String:Node] = [:]
    var nodeManager:NodeManager = NodeManager()
    var edgeManager:EdgeManager = EdgeManager()
    var scene:SKScene?
    var selectedArc:Arc?
    var selectedNode:Node?
    var movingMode:Bool = false
    var curEdge:Edge?
    var incidenceMatrix:[String:[String:Int]] = [:]
    var moveStart:Date?
    var moveEnd:Date?
    var deltaMoveT = 1.0
    
    init(scene:SKScene){
        self.scene = scene
        self.nodeManager.scene = scene
        self.edgeManager.scene = scene
    }
    
    func connectNodes(from:Node,to:Node,edge:Edge) {
        //let edge = Edge(from: from, to: to)
        self.incidenceMatrix[from.id!]![edge.id!] = 1
        self.incidenceMatrix[to.id!]![edge.id!] = -1
        self.edgeManager.addEdge(edge: edge)
    }
    
    func connectArcs(from:Arc,to:Arc,edge:Edge) {
        //let edge = Edge(from: from, to: to)
        self.incidenceMatrix[(from.parent as! Node).id!]![edge.id!] = 1
        self.incidenceMatrix[(to.parent as! Node).id!]![edge.id!] = -1
        self.edgeManager.addEdge(edge: edge)
    }
    
    func addNode(node: Node) {
        self.incidenceMatrix[node.id!] = [:]
        for item in self.edgeManager.edgeList{
            self.incidenceMatrix[node.id!]![item.id!] = 0
        }
        self.nodeManager.addNode(node: node)
        
    }
    
    func remove(node: Node) {
        let edgeList = (self.incidenceMatrix[node.id!]! as NSDictionary).allKeys(for:1) + (self.incidenceMatrix[node.id!] as! NSDictionary).allKeys(for:-1)
        for item in edgeList{
            self.edgeManager.removeEdge(with: item as! String)
        }
        self.incidenceMatrix.removeValue(forKey: node.id!)
        self.nodeManager.removeNode(with: node.id!)
    }
    
    func removeEdge(edge:Edge){
        self.incidenceMatrix[(edge.from?.id)!]![edge.id!] = 0
        self.incidenceMatrix[(edge.to?.id)!]![edge.id!] = 0
        self.edgeManager.removeEdge(with: edge.id!)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        //print(scene?.nodes(at: pos))
        if let scene = self.scene{
            var allNodes = scene.nodes(at:pos).filter{!($0 is MTKPassiveTangible) }
            if !allNodes.isEmpty {
                
                if allNodes[0] is Arc{
                    self.selectedArc = allNodes[0] as! Arc
                    self.redrawArc(arc: self.selectedArc, with: 1)
                }else{
                    self.selectedNode = allNodes[0].parent as? Node
                    self.movingMode = true
                }
            }
        }
    }
    
    func redrawArc(arc:Arc?,with:Int){
        let parent = arc?.parent!
        arc?.redrawArc(with: with)
        parent?.addChild(arc!)
    }
    
    
    
    func touchMoved(toPoint pos : CGPoint) {
        if let scene = self.scene as? GameScene{
            var allNodes = scene.nodes(at:pos)
            if self.movingMode{
                //print("SELECTED NODE IS")
                //print(self.selectedNode?.id)
                self.moveNode(node:self.selectedNode,pos:pos)
                
                return
            }
            if !allNodes.isEmpty && !scene.drawLineMode{
                if(allNodes[0] is Arc){
                    if(self.selectedArc != nil && self.selectedArc != allNodes[0] && self.selectedArc?.parent == allNodes[0].parent){
                        self.popNeighbour(arc: allNodes[0] as! Arc)
                    }
                }
            }else{
                if (self.selectedArc != nil ){
                    if(self.curEdge==nil && (self.selectedArc?.canAdd)! ){
                        self.curEdge = Edge(from: (self.selectedArc?.globalPos)!, to: pos)
                        scene.addChild(self.curEdge!)
                    }else if(self.curEdge != nil) {
                        scene.drawLineMode = true
                        self.curEdge?.redrawEdge(from: (self.selectedArc?.globalPos)!, to: pos)
                        scene.addChild(self.curEdge!)
                        if allNodes.count>1{
                            if let endArc = allNodes[1] as? Arc{
                                if endArc.parent != self.selectedArc?.parent {
                                    let parent = endArc.parent
                                    endArc.redrawArc(with: 1)
                                    parent?.addChild(endArc)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func redrawEdges(with node: Node){
        if let graph = (self.scene as? GameScene)?.graph, let edges = graph.incidenceMatrix[node.id!]{
            for item in edges{
                let edge = graph.edgeManager.getEdge(by: item.key)
                if item.value == 1{
                    edge.redrawEdge(from: (edge.from?.globalPos)!, to: (edge.to?.globalPos)!)
                    self.scene?.addChild(edge)
                }
                else if item.value == -1{
                    edge.redrawEdge(from: (edge.from?.globalPos)!, to: (edge.to?.globalPos)!)
                    self.scene?.addChild(edge)
                }
            }
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let scene = self.scene as? GameScene{
            if (self.selectedArc != nil && !(self.scene as! GameScene).drawLineMode)  {
                let parent = self.selectedArc?.parent
                self.selectedArc?.redrawArc(with: -1)
                parent?.addChild(self.selectedArc!)
            }else if (self.selectedArc != nil && (self.scene as! GameScene).drawLineMode){
                self.putEdge(to: pos, scene: scene)
            }
        }
        self.selectedNode = nil
        self.selectedArc = nil
        self.movingMode = false
        (self.scene as! GameScene).drawLineMode = false
        self.curEdge = nil
        
    }
    
    func redrawEdge(){
        self.curEdge?.removeFromParent()
        self.curEdge = nil
    }
    
    func newCoord(node:Node, pos:CGPoint){
        let deltaX = pos.x - node.position.x
        let deltaY = pos.y - node.position.y
       // print(CGPoint(x:deltaX,y:deltaY))
        if (abs(deltaX) > 2 || abs(deltaY) > 2) {
            node.position.x = node.position.x + deltaX
            node.position.y = node.position.y + deltaY
            self.moveArcs(node: node, deltaX: deltaX, deltaY: deltaY)
        }
        
        }
        
    
    func putEdge(to pos:CGPoint, scene:GameScene){
        if (scene.nodes(at:pos).indices.contains(1)){
            if let endArc = scene.nodes(at:pos)[1] as? Arc{
                do{
                    if(endArc.isInput && endArc.parent != self.selectedArc?.parent){
                        try
                        self.changeEdgeEnds(startArc: self.selectedArc, endArc: endArc, scene: scene, direction: 1)
                        
                        self.selectedArc?.changeArcColor()
                        endArc.changeArcColor()
                    }else if(!endArc.isInput && endArc.parent != self.selectedArc?.parent){
                        try
                        self.changeEdgeEnds(startArc: self.selectedArc, endArc: endArc, scene: scene, direction: -1)
                        self.selectedArc?.changeArcColor()
                        endArc.changeArcColor()
                    }
                }catch{
                    self.redrawEdge()
                    print("haha")
                    
                }
            }
        }
        self.redrawEdge()
        //self.selectedArc?.redrawArc(with: -1)
        self.redrawArc(arc: self.selectedArc, with: -1)
        print("hihi")
    }
    
    func moveArcs(node:Node,deltaX:CGFloat,deltaY:CGFloat){
        for item in node.arcManager!.inputArcs + node.arcManager!.outputArcs {
            var point = CGPoint(x: (item.globalPos?.x)! + deltaX, y: (item.globalPos?.y)! + deltaY)
            item.globalPos = point
            if item.isInput{
                for item1 in item.edges{
                    item1.redrawEdge(from: (item1.fromPoint)!, to: item.globalPos!)
                    scene?.addChild(item1)
                }
            } else {
                for item1 in item.edges{
                    item1.redrawEdge(from: item.globalPos!, to: (item1.toPoint)!)
                    scene?.addChild(item1)
                }
            }
        }
    }
    
    
    
    func changeEdgeEnds(startArc:Arc?, endArc:Arc, scene:GameScene, direction:Int) throws{
        endArc.addEdge(edge: self.curEdge!)
        self.selectedArc?.addEdge(edge: self.curEdge!)
        if(direction == 1){
            self.curEdge?.to = endArc
            self.curEdge?.from = startArc
            self.curEdge?.redrawEdge(from: (startArc?.globalPos)!, to: endArc.globalPos!)
        }else{
            self.curEdge?.to = startArc
            self.curEdge?.from = endArc
            self.curEdge?.redrawEdge(from: endArc.globalPos! , to: (startArc?.globalPos)!)
        }
        self.curEdge?.zPosition = -2
        scene.graph?.edgeManager.addEdge(edge: self.curEdge!)
        self.curEdge = nil
    }
    
    func moveNode(node:Node?,pos:CGPoint){
        if self.moveStart == nil {
            self.moveStart = Date()
        }
        if let nodeToMove = node {
            if self.movingMode{
                self.newCoord(node: nodeToMove, pos: pos)
                if self.moveStart != nil {
                    self.moveEnd = Date()
                    
                }
            }
        }
    }
    
    func popNeighbour(arc:Arc){
        let parent = self.selectedArc!.parent!
        self.selectedArc?.redrawArc(with: -1)
        arc.redrawArc(with: 1)
        parent.addChild(self.selectedArc!)
        parent.addChild(arc)
        self.selectedArc = arc
    }
    
    
    
    
   
}
