//
//  AppDelegate.swift
//  MasterAsif2
//
//  Created by PPI on 11.12.18.
//  Copyright © 2018 RWTH Aachen University. All rights reserved.
//

import Cocoa
import MultiTouchKitSwift
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        MTKHub.sharedHub.start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

