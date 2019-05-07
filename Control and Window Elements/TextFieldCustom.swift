//
//  TextFieldCustom.swift
//  MasterAsif2
//
//  Created by PPI on 26.04.19.
//  Copyright © 2019 RWTH Aachen University. All rights reserved.
//

import Foundation
import AppKit
class CustomTextFields:NSTextField{
    var id:String?
    var type:String = "text"
    var parent:Node? = nil
    override init(frame frameRect: NSRect) {
        super.init(frame:frameRect)
    }
    
    convenience init(frame frameRect: NSRect, id:String) {
        self.init(frame:frameRect)
        self.id = id
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
