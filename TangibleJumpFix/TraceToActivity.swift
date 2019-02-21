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
//    var fromPoint:CGPoint?
//    var toPoint:CGPoint?
//    var from:Arc?
//    var to:Arc?
    var arc:Arc


    init(arc:Arc) {
        self.id = arc.id
        self.arc = arc
        TraceToActivity.activityList.append(self)
    }
    
    class func getActivity(by id:String) -> TraceToActivity?{
        let activities = TraceToActivity.activityList.filter{$0.id == id}
        if activities.isEmpty{return nil}
        return activities[0]
    }
    
    class func removeActivity(by id:String){
        TraceToActivity.activityList = TraceToActivity.activityList.filter{$0.id != id }
    }
    
    class func getAvailableActivity(isInput:Bool)->TraceToActivity?{
        var activities:[TraceToActivity] = []
        if isInput{
            activities = TraceToActivity.activityList.filter{$0.arc.isInput && $0.arc.canAdd}
        }else{
            activities = TraceToActivity.activityList.filter{!$0.arc.isInput && $0.arc.canAdd}
        }
        if !activities.isEmpty{return activities[0]}
        return nil
    }
    
    
}
