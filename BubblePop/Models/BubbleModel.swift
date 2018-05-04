//
//  Bubble.swift
//  BubblePop
//
//  Copyright © 2018 Jason Kumar. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class BubbleModel: SKShapeNode
{
    static let radius: CGFloat = 35
    
    var color: UIColor = .red
    var value: Int = 1
    
    init(circleOfRadius: CGFloat)
    {
        super.init()
        
        let diameter = circleOfRadius * 2
        self.path = CGPath(ellipseIn: CGRect(origin: .zero, size: CGSize(width: diameter, height: diameter)), transform: nil)
        self.name = "Bubble"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(position: CGPoint, color: UIColor, value: Int)
    {
        self.init(circleOfRadius: BubbleModel.radius)
        
        self.position = position
        self.color = color
        self.fillColor = color
        self.strokeColor = color
        self.value = value
    }
}
