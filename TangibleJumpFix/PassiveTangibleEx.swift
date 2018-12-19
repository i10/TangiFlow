//
//  PassiveTangibleEx.swift
//  MasterAsif2
//
//  Created by Asif Mayilli on 18.12.18.
//  Copyright © 2018 RWTH Aachen University. All rights reserved.
//

import Foundation
import MultiTouchKitSwift
class PassiveTangibleEx {
    static var tangibleList: [PassiveTangibleEx] = []
    var tangible:MTKPassiveTangible?
    var canLift:Bool = false
    var node:Node?
    var traceAmoving:Bool = false
    var traceBmoving:Bool = false
    var traceCmoving:Bool = false
    var APrev:CGPoint?
    var BPrev:CGPoint?
    var CPrev:CGPoint?
    var canMove:Bool = false
    
    init(tangible:MTKPassiveTangible) {
        self.tangible = tangible
        if let aprev = tangible.currentA?.position, let bprev = tangible.currentB?.position, let cprev = tangible.currentC?.position{
            self.APrev = aprev
            self.BPrev = bprev
            self.CPrev = cprev
        }
        PassiveTangibleEx.tangibleList.append(self)
    }
    
    func checkTangibleMove(){
        if let aprev = APrev{
            if let currentA = tangible?.currentA?.position{
                self.APrev = currentA
                if(abs(aprev.x-currentA.x)>4 || abs(aprev.y-currentA.y)>4){
                    self.traceAmoving = true
                } else{
                    self.traceAmoving = false
                }
            }
        }else{
            self.APrev = tangible?.currentA?.position
        }
        if let bprev = BPrev{
            if let currentB = tangible?.currentB?.position{
                self.BPrev = currentB
                if(abs(bprev.x-currentB.x)>4 || abs(bprev.y-currentB.y)>4){
                    self.traceBmoving = true
                }else{
                    self.traceBmoving = false
                }
            }
        }else{
            self.BPrev = tangible?.currentB?.position
        }
        if let cprev = CPrev{
            if let currentC = tangible?.currentC?.position{
                self.CPrev = currentC
                if(abs(cprev.x-currentC.x)>4 || abs(cprev.y-currentC.y)>4){
                    self.traceCmoving = true
                }else{
                    self.traceCmoving = false
                }
            }
        }else{
            self.CPrev = tangible?.currentC?.position
        }
        

    }
    
    class func getTangible(by id:String)-> PassiveTangibleEx?{
        let tangibles = PassiveTangibleEx.tangibleList.filter{$0.tangible?.identifier == id}
        if tangibles.isEmpty{return nil}
        return tangibles[0]
    }
    
    func checkTraceLost(){
        if self.tangible?.countOfLostTraces == 0{
            
                self.canMove = self.traceAmoving && self.traceBmoving && self.traceCmoving
            
        }else if self.tangible?.countOfLostTraces == 1{
            if self.tangible!.traceALost {
                self.canMove = self.traceBmoving && self.traceCmoving
            }else if self.tangible!.traceBLost{
                self.canMove = self.traceAmoving && self.traceCmoving
            } else if self.tangible!.traceCLost{
                self.canMove = self.traceAmoving && self.traceBmoving
            }
            
        }else if self.tangible?.countOfLostTraces == 2{
            if !self.tangible!.traceALost {
                self.canMove = self.traceAmoving
            }else if !self.tangible!.traceBLost{
                self.canMove = self.traceBmoving
            } else if !self.tangible!.traceCLost{
                self.canMove = self.traceCmoving
            }
        }
//        self.traceAmoving = false
//        self.traceBmoving = false
//        self.traceCmoving = false
    }
    
    
}
