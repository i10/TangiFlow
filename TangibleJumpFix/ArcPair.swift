//
//  ArcPair.swift
//  MasterAsif2
//
//  Created by PPI on 21.02.19.
//  Copyright © 2019 RWTH Aachen University. All rights reserved.
//

import Foundation
class ArcPair{
    var from:Arc
    var to:Arc
    var edge:Edge?
    static var pairs:[ArcPair] = []
    
    init(from:Arc,to:Arc) {
        self.from = from
        self.to = to
        ArcPair.pairs.append(self)
    }
    
    class func removePair(from:Arc,to:Arc){
        ArcPair.pairs = ArcPair.pairs.filter{!($0.from.id == from.id && $0.to.id == to.id)}
    }
    
    class func getPair(by arc:Arc)->ArcPair?{
        var pairs = ArcPair.pairs.filter{$0.from.id! == arc.id || $0.to.id! == arc.id}
        if !pairs.isEmpty{
            return pairs[0]
        }
        return nil
    }
}
