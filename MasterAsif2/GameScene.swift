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
    var graph:Graph?
    var selectedArc:Arc?
    var selectedNode:Node?
    var traceAmoving:Bool?
    var traceBmoving:Bool?
    var traceCmoving:Bool?
    var APrev:CGPoint?
    var BPrev:CGPoint?
    var CPrev:CGPoint?
    override func setupScene() {
        graph = Graph(scene: self)

        MTKHub.sharedHub.traceDelegate = self
        //MTKUtils.traceVisualization = true

        
    }
    
    func preProcessTraceSet(traceSet: Set<MTKTrace>, node: SKNode, timestamp: TimeInterval) -> Set<MTKTrace> {
        for passiveTangible in self.passiveTangibles {
                if passiveTangible.state == .initializedAndRecognized{
                    if let tangible = PassiveTangibleEx.getTangible(by: passiveTangible.identifier){
                        print("===============IF BLOCK====================")
                        
                        tangible.checkTangibleMove()
                        tangible.checkTraceLost()
                        if tangible.canMove{
                            print("i am on move")
                            self.graph?.touchDown(atPoint: passiveTangible.position)
                            self.graph?.touchMoved(toPoint: passiveTangible.position)
                            self.graph?.touchUp(atPoint: passiveTangible.position)
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

        return traceSet
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        
        
    }
}


