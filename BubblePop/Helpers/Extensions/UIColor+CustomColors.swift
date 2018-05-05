//
//  UIColor+CustomColors.swift
//  BubblePop
//
//  Copyright © 2018 Jason Kumar. All rights reserved.
//

import Foundation
import UIKit

// Adds custom colours to UIColor without the need to subclass and cast it
extension UIColor
{
    public static func bp_light_gray() -> UIColor
    {
        return UIColor(red: 0.874509803921569, green: 0.874509803921569, blue: 0.854901960784314, alpha: 1.0)
    }
    
    public static func bp_medium_gray() -> UIColor
    {
        return UIColor(red: 0.807843137254902, green: 0.807843137254902, blue: 0.823529411764706, alpha: 1.0)
    }
    
    public static func bp_dark_gray() -> UIColor
    {
        return UIColor(red: 0.552941176470588, green: 0.56078431372549, blue: 0.545098039215686, alpha: 1.0)
    }
    
    public static func bp_almost_black() -> UIColor
    {
        return UIColor(red: 0.200000002980232, green: 0.200000002980232, blue: 0.200000002980232, alpha: 1.0)
    }
    
    public static func bp_pink() -> UIColor
    {
        return UIColor(red: 1, green: 0.4392156863, blue: 0.5764705882, alpha: 1.0)
    }
}
