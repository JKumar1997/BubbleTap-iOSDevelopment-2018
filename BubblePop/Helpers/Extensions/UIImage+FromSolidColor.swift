//
//  UIImage+FromSolidColor.swift
//  BubblePop
//
//  Copyright © 2018 Jason Kumar. All rights reserved.
//

import Foundation
import UIKit

// Adds a constructor for creating a UIImage with a solid colour
public extension UIImage
{
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1))
    {
        let rect = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
