//
//  TangibleManager.swift
//  MasterAsif2
//
//  Created by PPI on 15.06.19.
//  Copyright © 2019 RWTH Aachen University. All rights reserved.
//

import Foundation
import MultiTouchKitSwift

class TangibleManager {
    
    fileprivate var tangibles = [String]()
    
    open func isExisting(id: String) -> Bool {
        return tangibles.contains(id)
    }
    
    open func addTangible(with id: String) {
        self.tangibles.append(id)
    }
    
    open func removeTangible(with id: String) {
        guard let index = self.tangibles.index(of: id) else { return }
        
        self.tangibles.remove(at: index)
    }
    
}
