//
//  JunkCode.swift
//  MasterAsif2
//
//  Created by PPI on 08.05.19.
//  Copyright © 2019 RWTH Aachen University. All rights reserved.
//


//        var touchTraces:[MTKTrace] = []
//        var tangibleTraces:[MTKTrace] = []
//
//        for passiveTangible in self.passiveTangibles {
//            //            print("+++++AM I WORKING+++++")
//            if passiveTangible.state == .initializedAndRecognized{
//
//                if let prevZ = self.prevZ {
//                    let deltaZ = abs(prevZ - passiveTangible.zRotation)
//                    if deltaZ > 0.1 && deltaZ < 0.5{
//                        if self.start == nil {
//                            self.start = Date()
//                        }
//                        self.angle += deltaZ
//
//                    }else {
//                        self.angle = 0
//                    }
//
//
//                    if angle > 0.8 {
//                        self.start = Date()
//                        //                        print(" YEEEEEES CAN LIFT")
//                    }
//                    self.prevZ = passiveTangible.zRotation
//                }else{
//                    self.prevZ = passiveTangible.zRotation
//                }
//            } else {
//                if let start = self.start{
//                    //print("Start acquired")
//                    let end = Date()
//                    let delta = end.timeIntervalSince(start)
//                    //print(delta)
//                    if delta > 0.02 && delta < 2.0 {
//                        //print("LIIIIIIIIFT")
//                        liftcounter += 1
//                        var node = PassiveTangibleEx.getTangible(by: passiveTangible.identifier)?.node
//                        node?.removeFromParent()
//
//                    }
//                    self.start = nil
//                }
//
//                self.prevZ = nil
//                self.angle = 0
//
//            }
//            //print(liftcounter)
//
//
//
//            tangibleTraces += passiveTangible.usedTraces
////            if passiveTangible.state == .initializedAndRecognized{
////                if let tangible = PassiveTangibleEx.getTangible(by: passiveTangible.identifier){
////                    //print("===============IF BLOCK====================")
////                    tangible.checkTangibleMove()
////                    tangible.checkTraceLost()
////                    if tangible.canMove{
////                        // print("i am on move")
////                        self.graph?.moveNode(node: tangible.node, pos: passiveTangible.position)
////                        //                            self.graph?.touchMoved(toPoint: passiveTangible.position)
////                        //                            self.graph?.touchUp(atPoint: passiveTangible.position)
////                    }
////                }else{
////                    //print("===============ELSE BLOCK====================")
////                    var tangible = PassiveTangibleEx(tangible: passiveTangible)
////                    let node = Node(position: passiveTangible.position)
////                    tangible.node = node
////                    //self.tangibleToNode[passiveTangible.identifier] = node
////                    self.graph?.addNode(node: node)
////                }
////            }
//
//        }
//        touchTraces = traceSet.filter{!tangibleTraces.contains($0) }
//
//        for trace in touchTraces{
//            if trace.state == MTKUtils.MTKTraceState.beginningTrace{
//                self.traceCall[trace.uuid] = 0
//            }
//            else if trace.state == MTKUtils.MTKTraceState.movingTrace{
//                if trace.beginTimestamp!.distance(to: trace.timestamp!) > 1.0  && self.traceCall[trace.uuid] != 1{
//                    graph?.touchDown(trace: trace)
//                    self.traceCall[trace.uuid] = 1
//                    print("worked one time")
//                } else if trace.beginTimestamp!.distance(to: trace.timestamp!) > 1.0 && self.traceCall[trace.uuid] == 1{
//                    graph?.touchMove(trace: trace)
//                }
//            } else if trace.state == MTKUtils.MTKTraceState.endingTrace{
//                graph?.touchUp(trace: trace)
//            }
//                //           } else if trace.state == MTKUtils.MTKTraceState.movingTrace{
//                //               print("")
//
//        }






//
//              //  for passiveTangible in self.passiveTangibles {
//              //      //print(passiveTangible.state)
//              //      //print(traceSet)
//              //      if passiveTangible.state == .initializedAndRecognized{
//              //          if let tangible = PassiveTangibleEx.getTangible(by: passiveTangible.identifier){
//              //                  self.graph?.moveNode(node: tangible.node, pos: passiveTangible.position)
//              //          }else{
//              //              var tangible = PassiveTangibleEx(tangible: passiveTangible)
//              //              let node = Node(position: passiveTangible.position)
//              //              tangible.node = node
//
//              //             self.graph?.addNode(node: node)
//              //          }
//              //      }
//
//              //  }






//                var nodes = self.nodes(at: trace.position!)
//                if !nodes.isEmpty && nodes[0].name == "bar"{
////                    let node =  NodeManager.getNode(with: "PT-127.99.89")
////                    node?.arcManager?.addOutputArc()
//                    //print("ok")
//                    let scr = ScriptRunner()
//                    scr.script()
//                    let resultMaker = ResultVisualization()
//                    resultMaker.getResults()
////                    let dialogue = NSOpenPanel()
////                    dialogue.canChooseFiles = true
////                    dialogue.showsResizeIndicator = true
////                    if (dialogue.runModal() == NSApplication.ModalResponse.OK){
////                        print("MODAL")
////                    }
//
//                }
