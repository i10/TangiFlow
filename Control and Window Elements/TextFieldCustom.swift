//
//  TextFieldCustom.swift
//  MasterAsif2
//
//  Created by PPI on 26.04.19.
//  Copyright © 2019 RWTH Aachen University. All rights reserved.
//

import Foundation
import AppKit
class CustomTextFields:NSTextView{
    var id:String?
    var type:String = "text"
    var parent:Node? = nil
    override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame:frameRect,textContainer: container)
        
    }
    
//    convenience init(frame frameRect: NSRect, id:String) {
//        self.init(frame:frameRect)
//        self.id = id
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    convenience init(frame frameRect: NSRect, textContainer container: NSTextContainer?, id:String) {
        self.init(frame: frameRect, textContainer: container)
        self.id = id
        self.setFont(NSFont(name: "Arial", size: 100)!, range: NSRange(location: 0, length:0))
    }
}
