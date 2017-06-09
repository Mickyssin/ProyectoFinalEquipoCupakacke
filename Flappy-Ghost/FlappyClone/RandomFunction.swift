//
//  RandomFunction.swift
//  FlappyClone
//
//  Created by LEONARDO on 15/3/17.
//  Copyright © 2017 LEONARDO. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat{


    public static func random() -> CGFloat{

        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }

    public static func random(min min : CGFloat, max : CGFloat) -> CGFloat{

        return CGFloat.random() * (max - min) + min
    }
    // Esta es básicamente la función que permite que las paredes tengan una altura aleatoria pero que se deben mantener entre los valores mínimos y máximos y respetando el espacio intermedio entre ellas.  
}
