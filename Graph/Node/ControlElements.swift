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
                var slider = Slider()
                slider.name = control
                slider.max = CGFloat(json[control]["max"].floatValue)
                slider.min = CGFloat(json[control]["min"].floatValue)
                slider.step = CGFloat(json[control]["step"].floatValue)
                slider.alias = json[control]["alias"].stringValue
                self.sliders.append(slider)
                self.parent?.addChild(slider)
               
            case "button":
                self.button = MTKButton(size: CGSize(width: 40, height: 40), image:"open.png" )
                self.button?.name = control
                self.button?.position = CGPoint(x: -70, y: 0)
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
        filePicker.position = CGPoint(x: -600, y: 0)
        self.parent!.addChild(filePicker)
    }
    
    
    func positionControls(){
        
        for index in 0..<textFields.count{
            print(index)
    
            print(parent!.position.y + CGFloat(60 + (index+1)*120))
            textFields[index].setFrameOrigin(CGPoint(x:parent!.position.x-80,y:parent!.position.y + CGFloat(200 + index*70)))
        }
        var y = 220  + textFields.count * 70
        for index in 0..<sliders.count{
            sliders[index].position = CGPoint(x: 0, y: y + 80*index)
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
