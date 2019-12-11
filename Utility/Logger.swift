//
//  Logger.swift
//  MasterAsif2
//
//  Created by PPI on 11.06.19.
//  Copyright © 2019 RWTH Aachen University. All rights reserved.
//
import SwiftLog
import Foundation
class Logger{
    static let shared = Logger()
    
    
    init() {
        logw("write to the log!")
        
        //Set the name of the log files
        Log.logger.name = "test" //default is "logfile"
        
        //Set the max size of each log file. Value is in KB
        Log.logger.maxFileSize = 4096 //default is 1024
        
        //Set the max number of logs files that will be kept
        Log.logger.maxFileCount = 8 //default is 4
        
        //Set the directory in which the logs files will be written
        Log.logger.directory = "/Users/ppi/Documents/Code/MasterAsif/Logs" //default is the standard logging directory for each platform.
        
        //Set whether or not writing to the log also prints to the console
        Log.logger.printToConsole = false //default is true
    }
    
    func logWrite(message:String){
        logw(message)
    }
}
