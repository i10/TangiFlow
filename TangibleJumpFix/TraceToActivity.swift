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
    var id:String?
    var fromPoint:CGPoint?
    var toPoint:CGPoint?
    var fromAngle:CGFloat?
    var toAngle:CGFloat?
    var from:Arc?
    var to:Arc?
    var edge:Edge?
    var firstArc:Int = 0
    init(id:String,from:Arc?,to:Arc?) {
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
    class func getActivity(by id:String) -> TraceToActivity?{
        let activities = TraceToActivity.activityList.filter{$0.id == id || $0.to?.id == id || $0.from?.id == id}
        if activities.isEmpty{return nil}
        return activities[0]
    }
    
    class func getActivity(by edge:Edge) -> TraceToActivity?{
        let activities = TraceToActivity.activityList.filter{$0.edge?.id == edge.id}
        if activities.isEmpty{return nil}
        return activities[0]
    }
    
    class func removeActivity(by id:String){
        self.activityList = TraceToActivity.activityList.filter{$0.id != id}
    }
    
    
}
