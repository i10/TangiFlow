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
    var from:Arc?
    var to:Arc?
    var edge:Edge?
    var firstArc:Int = 0
    var currentTrace:Int?
    var fulcrum:Arc?
    init(from:Arc?,to:Arc?) {
        self.id = UUID().uuidString
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
        let activities = TraceToActivity.activityList.filter{$0.id == id}
        if activities.isEmpty{return nil}
        return activities[0]
    }
    
    class func getActivity(by arc:Arc?) -> TraceToActivity?{
        guard let arc = arc else {return nil}
        let activities = TraceToActivity.activityList.filter{$0.from == arc || $0.to == arc}
        if activities.isEmpty{return nil}
        return activities[0]
    }
    
    class func getActivity(by trace:Int) -> TraceToActivity?{
        let activities = TraceToActivity.activityList.filter{$0.currentTrace == trace}
        if activities.isEmpty{return nil}
        return activities[0]
    }
    
    class func removeActivity(activity:TraceToActivity?){
        if let activity = activity{
            activity.edge?.removeFromParent()
            activity.to?.removeEdge(edge: activity.edge)
            activity.from?.removeEdge(edge: activity.edge)
            // self.edgeManager.removeEdge(with: activity.edge?.id)
            activity.edge = nil
            activity.to?.redrawArc(with: -1)
            activity.from?.redrawArc(with: -1)
            activity.to?.changeArcColor()
            activity.from?.changeArcColor()
            TraceToActivity.activityList = TraceToActivity.activityList.filter{$0.id != activity.id}
        }
    }
    
}
