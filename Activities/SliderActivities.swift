//
//  SliderActivities.swift
//  MasterAsif2
//
//  Created by PPI on 06.05.19.
//  Copyright © 2019 RWTH Aachen University. All rights reserved.
//
/*
While being used sliders get attached to MTKTrace creating SliderActivity 
which we can identify given touch by specific MTKTrace unique id
*/
import Foundation
import MultiTouchKitSwift
class SliderActivity{
    static var sliderList:[SliderActivity] = []
    var slider:Slider?
    //var prevTracePosition:CGPoint?
    var trace:MTKTrace?
    var oldX:CGFloat = 0.0
    var oldY:CGFloat = 0.0
    init(trace:MTKTrace,slider:Slider) {
        
        self.slider = slider
        self.trace = trace
        self.oldX = trace.position!.x
        self.oldY = trace.position!.y
        SliderActivity.sliderList.append(self)
        
    }
    
    
    class func getActivity(by id:Int?) -> SliderActivity?{
        guard let id = id else {return nil}
        let activities = SliderActivity.sliderList.filter{$0.trace?.uuid == id}
        if activities.isEmpty{return nil}
        return activities[0]
    }
    
    
    
    class func removeActivity(id:Int){
        SliderActivity.sliderList = SliderActivity.sliderList.filter{$0.trace?.uuid != id}
    }
}
