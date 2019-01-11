//
//  GameScene.swift
//  Test1
//
//  Created by Asif Mayilli on 10/30/18.
//  Copyright © 2018 Test. All rights reserved.
//

import SpriteKit

import MultiTouchKitSwift
class GameScene: MTKScene {
    var tangibleToNode:[String:Node] = [:]
    var drawLineMode = false
    var startArc:Arc?
    var endArc:Arc?
    var currentDrawnEdge:Edge?
    var graph:Graph2?
    var selectedArc:Arc?
    var selectedNode:Node?
    var traceAmoving:Bool?
    var traceBmoving:Bool?
    var traceCmoving:Bool?
    var APrev:CGPoint?
    var BPrev:CGPoint?
    var CPrev:CGPoint?
    override func setupScene() {
        graph = Graph2(scene: self)
        MTKHub.sharedHub.traceDelegate = self
        var node = Node(position: CGPoint(x:1000,y:1000))
        var node1 = Node(position: CGPoint(x:1500,y:1000))
        var node2 = Node(position: CGPoint(x:2000,y:1000))
        var node3 = Node(position: CGPoint(x:3000,y:1000))
        self.graph?.addNode(node: node)
        self.graph?.addNode(node: node1)
        self.graph?.addNode(node: node2)
        self.graph?.addNode(node: node3)
        //MTKUtils.traceVisualization = true

        
    }
    
    func preProcessTraceSet(traceSet: Set<MTKTrace>, node: SKNode, timestamp: TimeInterval) -> Set<MTKTrace> {
        var touchTraces:[MTKTrace] = []
        var tangibleTraces:[MTKTrace] = []
        for passiveTangible in self.passiveTangibles {
//            print("+++++AM I WORKING+++++")
            tangibleTraces += passiveTangible.usedTraces
                if passiveTangible.state == .initializedAndRecognized{
                    if let tangible = PassiveTangibleEx.getTangible(by: passiveTangible.identifier){
                        print("===============IF BLOCK====================")
                        tangible.checkTangibleMove()
                        tangible.checkTraceLost()
                        if tangible.canMove{
                            print("i am on move")
                            self.graph?.touchDown(trace: passiveTangible.position)
//                            self.graph?.touchMoved(toPoint: passiveTangible.position)
//                            self.graph?.touchUp(atPoint: passiveTangible.position)
                        }
                    }else{
                        print("===============ELSE BLOCK====================")
                        var tangible = PassiveTangibleEx(tangible: passiveTangible)
                        let node = Node(position: passiveTangible.position)
                        tangible.node = node
                        //self.tangibleToNode[passiveTangible.identifier] = node
                        self.graph?.addNode(node: node)
                    }
                }

        }
        touchTraces = traceSet.filter{!tangibleTraces.contains($0) }
        for trace in touchTraces{
            if trace.state == MTKUtils.MTKTraceState.beginningTrace{
                graph?.touchDown(trace: trace)
           } else if trace.state == MTKUtils.MTKTraceState.movingTrace{
                graph?.touchMove(trace: trace)}
             else if trace.state == MTKUtils.MTKTraceState.endingTrace{
                graph?.touchUp(trace: trace)
            }
        }
        return traceSet
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        
        
    }
}


