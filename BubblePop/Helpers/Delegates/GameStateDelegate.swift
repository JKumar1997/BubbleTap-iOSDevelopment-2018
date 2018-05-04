//
//  GameStateDelegate.swift
//  BubblePop
//
//  Copyright © 2018 Jason Kumar. All rights reserved.
//

import Foundation

protocol GameStateDelegate
{
    func updateState(time: Int, score: Int)
}
