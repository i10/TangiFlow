////
////  File.swift
////  MasterAsif2
////
////  Created by PPI on 14.12.18.
////  Copyright © 2018 RWTH Aachen University. All rights reserved.
////
//
//import Foundation
//for passiveTangible in self.passiveTangibles {
//    pa
//    print("===================tangible==================")
//    print(passiveTangible.state)
//    print(passiveTangible.trackingState)
//    print("==============================================")
//    if let pos = self.oldPoint {
//        print("==========Delta is==============")
//        print(pos.x - passiveTangible.position.x)
//        print(pos.y - passiveTangible.position.y)
//        print("=================================")
//        self.oldPoint = passiveTangible.position
//    }else{
//        self.oldPoint = passiveTangible.position
//    }
//    
//    if(
//        passiveTangible.state == .initializedButLostTracking ||
//            passiveTangible.trackingState == MTKUtils.MTKTangibleTrackingState.recognizedAndRecoveringMissingTraces){
//        self.start = Date()
//        return traceSet
//        //  print("i worked 1")
//        
//    } else if (passiveTangible.state == .initializedAndRecognized ||
//        passiveTangible.trackingState == MTKUtils.MTKTangibleTrackingState.fullyRecognized) {
//        //var locDelta = 20.0
//        //print("i wroked 2")
//        if let start = self.start{
//            self.end = Date()
//            locDelta = self.end!.timeIntervalSince(start).rounded(.down)
//        }
//        
//        if ((locDelta)>self.deltaT){
//            self.graph?.touchDown(atPoint: passiveTangible.position)
//            
//            if tangibleToNode[passiveTangible.identifier] == nil{
//                let node = Node(position: passiveTangible.position)
//                self.tangibleToNode[passiveTangible.identifier] = node
//                self.graph?.addNode(node: node)
//                
//            }else if(passiveTangible.currentA?.state == MTKUtils.MTKTraceState.movingTrace ||
//                passiveTangible.currentB?.state == MTKUtils.MTKTraceState.movingTrace  ||
//                passiveTangible.currentC?.state == MTKUtils.MTKTraceState.movingTrace) {
//                if self.moveStart == nil {
//                    self.moveStart = Date()
//                    
//                }
//                self.graph?.touchDown(atPoint: passiveTangible.position)
//                
//                self.graph?.touchMoved(toPoint: passiveTangible.position)
//                print("move")
//                if self.moveStart != nil {
//                    self.moveEnd = Date()
//                    
//                }
//                
//                
//            }else if(passiveTangible.currentA?.state == MTKUtils.MTKTraceState.endingTrace ||
//                passiveTangible.currentB?.state == MTKUtils.MTKTraceState.endingTrace  ||
//                passiveTangible.currentC?.state == MTKUtils.MTKTraceState.endingTrace){
//                
//                if let start = self.moveStart{
//                    
//                }
//                
//            }
//                
//            else {
//                //print("I work now")
//                self.graph?.touchUp(atPoint: passiveTangible.position)
//            }
//        } else{
//            self.start = nil
//            self.end = nil
//        }
//        
//    }else if(passiveTangible.trackingState == MTKUtils.MTKTangibleTrackingState.notRecognized){
//        //print("i worked 3")
//        if let start = self.graph?.moveStart, let end = self.graph?.moveEnd{
//            var delta = end.timeIntervalSince(start)
//            if(delta>self.deltaMoveT && !self.moving){
//                self.tangibleToNode[passiveTangible.identifier]?.removeFromParent()
//                self.tangibleToNode[passiveTangible.identifier] = nil
//                self.graph?.moveEnd = nil
//                self.graph?.moveStart = nil
//                //print("up")
//            }
//            
//        }
//    }
//    
//}
