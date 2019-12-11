//
//  ControlProtocol.swift
//  MasterAsif2
//
//  Created by PPI on 07.05.19.
//  Copyright © 2019 RWTH Aachen University. All rights reserved.
//

import Foundation
import SwiftyJSON
protocol ControlProtocol {
    var value:String {get set}
    func getDict()->JSON
}
