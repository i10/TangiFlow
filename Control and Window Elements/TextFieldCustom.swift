//
//  TextFieldCustom.swift
//  MasterAsif2
//
//  Created by PPI on 26.04.19.
//  Copyright © 2019 RWTH Aachen University. All rights reserved.
//


//it is custom textfield class which has id, type and parent fields added
import Foundation
import AppKit
class CustomTextFields:NSTextView{
    var id:String?
    //type of input "text" for alpha numerical and "number" for numerical keyboard
    var type:String = "text"
    //stores node to which text field belongs
    var parent:Node? = nil
    override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame:frameRect,textContainer: container)
        
    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    convenience init(frame frameRect: NSRect, textContainer container: NSTextContainer?, id:String) {
        self.init(frame: frameRect, textContainer: container)
        self.id = id
        self.setFont(NSFont(name: "Arial", size: 100)!, range: NSRange(location: 0, length:0))
    }
}
