//
//  GameStateDelegate.swift
//  BubblePop
//
//  Copyright © 2018 Jason Kumar. All rights reserved.
//

import Foundation

// Delegates the display of game state
protocol GameStateDelegate
{
    func updateState(time: Int, score: Int)
}
