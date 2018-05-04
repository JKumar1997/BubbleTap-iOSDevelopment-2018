//
//  HighScore.swift
//  BubblePop
//
//  Copyright © 2018 Jason Kumar. All rights reserved.
//

import Foundation

struct HighScoreModel: Codable
{
    var name: String
    var score: Int
    
    init(name: String, score: Int)
    {
        self.name = name
        self.score = score
    }
}
