//
//  CGFloat+RandomNumber.swift
//  BubblePop
//
//  Copyright © 2018 Jason Kumar. All rights reserved.
//

import Foundation
import UIKit

// Adds helpers for generating random CGFloats
public extension CGFloat
{
    // Returns a random CGFloat between 0.0 and 1.0, inclusive
    public static var random: CGFloat
    {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    // Returns a random CGFloat between min and max, inclusive
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat
    {
        return CGFloat.random * (max - min) + min
    }
}
