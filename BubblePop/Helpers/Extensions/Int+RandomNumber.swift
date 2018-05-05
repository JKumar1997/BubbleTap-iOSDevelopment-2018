//
//  Int+RandomNumber.swift
//  BubblePop
//
//  Copyright © 2018 Jason Kumar. All rights reserved.
//

import Foundation
import UIKit

// Adds helpers for generating random Ints
public extension Int
{
    // Returns a random Int between min and max, inclusive
    public static func random (min: Int , max: Int) -> Int
    {
        return Int(arc4random_uniform(UInt32(1 + max - min))) + min
    }
    
}
