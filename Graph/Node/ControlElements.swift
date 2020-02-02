//
//  ControlElements.swift
//  MasterAsif2
//
//  Created by PPI on 07.05.19.
//  Copyright © 2019 RWTH Aachen University. All rights reserved.
//

import Foundation
import MultiTouchKitSwift
class ControlElements{
    var button:MTKButton? = nil
    var textFields:[CustomTextFields] = []
    var sliders:[Slider] = []
    var filePicker:MTKFileManager = MTKFileManager()
    var parent:Node?
    
    //initializes control elements for node such as sliders, textfields and handles how to place them around the node
    init(json:JSON,node:Node) {
        self.parent = node
        for control in Array(json.dictionaryValue.keys){
            
            switch json[control]["type"].stringValue{
            case "number":
                let textFieldFrame = CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: 160, height: 60))
                var textStorage = NSTextContainer(containerSize: CGSize(width: 160, height: 60))
                let textField = CustomTextFields(frame: textFieldFrame, textContainer: textStorage ,id:control)
                textField.parent = node
                textField.type = "number"
                textField.alignment = .right
                textField.backgroundColor = NSColor.red
                self.textFields.append(textField)
                textField.backgroundColor = NSColor.white
                parent!.view?.addSubview(textField)
            case "text":
                var textStorage = NSTextStorage()
                var layoutManager = NSLayoutManager()
                textStorage.addLayoutManager(layoutManager)
                var textContainer = NSTextContainer(containerSize: CGSize(width: 200, height: 80))
                layoutManager.addTextContainer(textContainer)
                var textView = CustomTextFields(frame: CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: 200, height: 80)), textContainer: textContainer,id:control)
                textView.parent = node
                textView.type = "text"
                self.textFields.append(textView)
                textView.isEditable = true
                textView.isSelectable = true
                parent!.view!.addSubview(textView)
            case "slider":
                let slider = Slider(min: CGFloat(json[control]["min"].floatValue),
                                    max: CGFloat(json[control]["max"].floatValue),
                                    step: CGFloat(json[control]["step"].floatValue),
                                    defaultVal: CGFloat(json[control]["default"].floatValue))
                slider.name = control
                slider.alias = json[control]["alias"].stringValue
                self.sliders.append(slider)
                slider.drawLabel()
                self.parent?.addChild(slider)
                
               
            case "button":
                self.button = MTKButton(size: CGSize(width: 30, height: 30), image:"ffolder.png" )
                self.button?.name = control
                self.button?.position = CGPoint(x: 0, y: -70)
                parent!.addChild(button!)
                self.button?.add(target: self, action: #selector(self.buttonPressed(button:)))
                self.parent?.playButton.removeFromParent()
            default:
                print("unknown")
            }

        }
        self.positionControls()
        
    }
    
    @objc fileprivate func buttonPressed(button: MTKButton) {
        self.filePicker.removeFromParent()
        self.filePicker.drawFolders()
        self.filePicker.node = self.parent
        filePicker.position = CGPoint(x: 0, y: -450)
        self.parent!.addChild(filePicker)
    }
    
    
    func positionControls(){
        for index in 0..<textFields.count{
            print(index)
            
            print(parent!.position.y + CGFloat(60 + (index+1)*120))
            textFields[index].setFrameOrigin(CGPoint(x:parent!.position.x-80,y:parent!.position.y + CGFloat(250 + index*70)))
        }
        var y = 250  + textFields.count * 70
        for index in 0..<sliders.count{
            sliders[index].position = CGPoint(x: 0, y: y + 80*index)
        }
    }
    
    //when UI passes data to back-end this function collects all arguments available in control elements 
    //such as current value of slider, current text in textfield etc.
    func retrieveJSON()->JSON{
        var json:JSON = [:]
        for item in textFields {
            json[item.id!].string = item.string
        }
        for item in sliders{
            json[item.name!].string = "\(CGFloat((item.currentValue as NSString).doubleValue) + 1.0)"
        }
        if let button = self.button {
            json[button.name!].string = parent?.sourceUrl
        }
        
        return json
    }

}
