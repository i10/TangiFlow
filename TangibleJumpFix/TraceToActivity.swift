//
//  TraceToActivity.swift
//  MasterAsif2
//
//  Created by PPI on 09.01.19.
//  Copyright © 2019 RWTH Aachen University. All rights reserved.
//

import Foundation
import MultiTouchKitSwift
import SpriteKit

class TraceToActivity{
    static var activityList:[TraceToActivity] = []
    var id:Int?
    var fromPoint:CGPoint?
    var toPoint:CGPoint?
    var from:Arc?
    var to:Arc?
    var edge:Edge?
    var firstArc:Int = 0
    init(id:Int,from:Arc?,to:Arc?) {
        self.id = id
        if let from = from {
            self.from = from
            firstArc = 1
        } else {
            self.to = to
            firstArc = 2
        }
        TraceToActivity.activityList.append(self)
    }
    class func getActivity(by id:Int) -> TraceToActivity?{
        let activities = TraceToActivity.activityList.filter{$0.id == id}
        if activities.isEmpty{return nil}
        return activities[0]
    }
    
    
}
