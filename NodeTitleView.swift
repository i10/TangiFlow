//
//  NodeTitleView.swift
//  backendtest
//
//  Created by Asif Mayilli on 4/6/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation
import SpriteKit
class NodeTitleView:SKNode{
    var controlledArgs:[String] = []
    var title:String = "I am title"
    
    override init() {
        super.init()
        let textFieldFrame = CGRect(origin: .zero, size: CGSize(width: 200, height: 30))
        let textField = NSTextField(frame: textFieldFrame)
        textField.backgroundColor = NSColor.white
        textField.placeholderString = "hello world"
        //self.scene?.view
        
        //self.id = UUID().uuidString
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   // convenience init() {}
}
