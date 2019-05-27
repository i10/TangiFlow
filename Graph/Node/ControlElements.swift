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
    
    init(json:JSON,node:Node) {
        self.parent = node
        for control in Array(json.dictionaryValue.keys){
            
            switch json[control]["type"].stringValue{
            case "number":
                let textFieldFrame = CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: 160, height: 60))
                let textField = CustomTextFields(frame: textFieldFrame, id: control)
                textField.parent = node
                textField.type = "number"
                textField.alignment = .right
               // textField.font?.se
                //textField.font?.
                textField.font = NSFont(name: "Arial", size: 25)
                
                textField.backgroundColor = NSColor.red
                self.textFields.append(textField)
                //textField.setFrameOrigin(CGPoint(x:self.position.x-80,y:self.position.y + 60 + multiplier*60.0))
                //multiplier-=1.0
                textField.backgroundColor = NSColor.white
                textField.placeholderString = json[control]["alias"].stringValue
                parent!.view?.addSubview(textField)
                //view.addSubview(textField)
            case "text":
                let textFieldFrame = CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: 160, height: 60))
                let textField = CustomTextFields(frame: textFieldFrame, id: control)
                textField.parent = node
                textField.type = "text"
                textField.backgroundColor = NSColor.red
                self.textFields.append(textField)
               //textField.setFrameOrigin(CGPoint(x:500,y:500))
                //multiplier-=1.0
                textField.backgroundColor = NSColor.white
                textField.placeholderString = json[control]["alias"].stringValue
                parent!.view?.addSubview(textField)
            //view.addSubview(textField)
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
                self.button?.position = CGPoint(x: 0, y: -35)
                parent!.addChild(button!)
                self.button?.add(target: self, action: #selector(self.buttonPressed(button:)))
            default:
                print("unknown")
            }

        }
        self.positionControls()
        
    }
    
    @objc fileprivate func buttonPressed(button: MTKButton) {
        self.filePicker.removeFromParent()
        self.filePicker.node = self.parent
        filePicker.position = CGPoint(x: 0, y: -450)
        self.parent!.addChild(filePicker)
    }
    
    
    func positionControls(){
        
        for index in 0..<textFields.count{
            print(index)
    
            print(parent!.position.y + CGFloat(60 + (index+1)*120))
            textFields[index].setFrameOrigin(CGPoint(x:parent!.position.x-80,y:parent!.position.y + CGFloat(150 + index*70)))
        }
        var y = 150  + textFields.count * 70
        for index in 0..<sliders.count{
            sliders[index].position = CGPoint(x: 0, y: y + 120*index)
        }
    }
    
    
    func retrieveJSON()->JSON{
        var json:JSON = [:]
        for item in textFields {
            json[item.id!].string = item.stringValue
        }
        for item in sliders{
            json[item.name!].string = String(item.currentValue)
        }
        if let button = self.button {
            json[button.name!].string = parent?.sourceUrl
        }
        
        return json
    }

}
