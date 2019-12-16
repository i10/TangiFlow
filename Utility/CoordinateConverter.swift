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
    //Converter from polar to Decart coordinate system
    //You can read more about polar coordinate system here https://en.wikipedia.org/wiki/Polar_coordinate_system
    //You can read more about Cartesian (Decartes) coordinate system here https://en.wikipedia.org/wiki/Cartesian_coordinate_system
    class func polarToDecart(radius:CGFloat,angle:CGFloat)->CGPoint{
        let x = radius*cos(angle)
        let y = radius*sin(angle)
        return CGPoint(x: x, y: y)
    }
    //Convertes local coordinates inside specific node to the global coordinates of scene. 
    //E.g Arcs of nodes has local coordinates relative to their parent nodes. 
    //To find their global coordinates relative to the scene you can use this function
    class func localToGlobal(node:SKNode,coords:CGPoint) -> CGPoint{
        let x = node.position.x + coords.x
        let y = node.position.y + coords.y
        return CGPoint(x:x,y:y)
    }
}
