//
//  FileHandler.swift
//  backendtest
//
//  Created by Asif Mayilli on 4/20/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation
import SwiftyJSON
class FileHandler{
    static let shared = FileHandler()
    
     private init(){}
    func requestForLocation(){
        //Code Process
    }
    var projectDataPath =  "/Users/ppi/Documents/Code/MasterAsif/RestoreJSON/restore.json"
    var graphDataPath = "/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/Files/graph.json"
    var resultFolderPath = "/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/Files/Result"
    var imagesFolderPath = "/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/Files/Images"
    var mainScriptpath = "/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/main.py"
    var copyProj = "/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/Files/restore_copy_proj.json"
    var imageSource = "/Users/ppi/Desktop/ImageSource"
    var fileManager = FileManager.default
    
    
    public func getContent(of path:String) -> [URL]{
        var files:[URL] = []
        do {
            files = try fileManager.contentsOfDirectory(at: URL(fileURLWithPath: path),includingPropertiesForKeys: nil)
        }catch{ print("Error while enumerating files: \(error.localizedDescription)")}
        return files
    }
    
    public func cleanContent(of path:String){
        print("CLEANING CONTENT OF")
        let files = self.getContent(of: path)
        for file in files{
            self.removeFile(at: file)
        }
    }
    
    func removeFile(at path:URL){
        do{
            try  fileManager.removeItem(at: path)
        }catch{ print("Error while deleting file: \(error.localizedDescription)") }
    }
    
    func getJsonContent(of path:String) -> JSON? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let json = try JSON(data: data)
            
            return json
        } catch{
            print("Error while getting json: \(error.localizedDescription)")
        }
        return nil
    }
    func writeJsonContent(data:JSON,to path:String){
       // let json = JSON(data)
        let str = data.description
        let dataToWrite = str.data(using: String.Encoding.utf8)!
        if let file = FileHandle(forWritingAtPath:path) {
            file.truncateFile(atOffset: 0)
            file.write(dataToWrite)
        }
    }
}
