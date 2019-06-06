//
//  ProjectFilesManager.swift
//  backendtest
//
//  Created by Asif Mayilli on 3/29/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation
import SwiftyJSON
class ProjectFilesManager{
    var projectFile:String = "myproj"
    var projectFileJson:JSON?
    
    func openJson(){
        if let jsonPath = Bundle.main.path(forResource: projectFile, ofType: "json") {
            print(jsonPath)
            do {
                
                let data = try Data(contentsOf: URL(fileURLWithPath: jsonPath), options: .mappedIfSafe)
                self.projectFileJson = try JSON(data:data)
//                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
//                    self.projectFileJson = jsonResult
//                   // print(self.projectFileJson["PT-127.99.88"])
//                    //print(self.projectFileJson["PT-118.122.125"])
//                }
            } catch {
              //  print("heuhdnsx")
            }
        }
    }
    
    
}
