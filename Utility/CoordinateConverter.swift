//
//  CoordinateConverter.swift
//  backendtest
//
//  Created by Asif Mayilli on 4/22/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation
import SpriteKit
class CoordinateConverter{
    
    class func polarToDecart(radius:CGFloat,angle:CGFloat)->CGPoint{
        let x = radius*cos(angle)
        let y = radius*sin(angle)
        return CGPoint(x: x, y: y)
    }
    
    class func localToGlobal(node:SKNode,coords:CGPoint) -> CGPoint{
        let x = node.position.x + coords.x
        let y = node.position.y + coords.y
        return CGPoint(x:x,y:y)
    }
}
