//
//  UserDefaultsHelper.swift
//  BubblePop
//
//  Copyright © 2018 Jason Kumar. All rights reserved.
//

import Foundation

class UserDefaultsHelper
{
    static func setUserName(_ name: String)
    {
        UserDefaults.standard.set(name, forKey: "userName")
    }
    
    static func getUserName() -> String
    {
        return UserDefaults.standard.string(forKey: "userName") ?? ""
    }
    
    static func setGameTimer(_ seconds: Int)
    {
        UserDefaults.standard.set(seconds, forKey: "gameTimer")
    }
    
    static func getGameTimer() -> Int
    {
        let gameTimer = UserDefaults.standard.integer(forKey: "gameTimer")
        
        // Default timeframe is 60 seconds
        return gameTimer != 0 ? gameTimer : 60
    }
    
    static func setMaxBubbleCount(_ bubbleCount: Int)
    {
        UserDefaults.standard.set(bubbleCount, forKey: "maxBubbleCount")
    }
    
    static func getMaxBubbleCount() -> Int
    {
        let maxBubbleCount = UserDefaults.standard.integer(forKey: "maxBubbleCount")
        
        // Default maxBubbleCount is 15
        return maxBubbleCount != 0 ? maxBubbleCount : 15
    }
    
    // Adds a highscore and returns its index or nil if the score didn't make the top 10
    static func addHighScore(_ score: Int) -> Int?
    {
        var oldHighScores = UserDefaultsHelper.getHighScores()
        var insertIndex = 0
        
        oldHighScores.forEach {highscore in
            if (score <= highscore.score)
            {
                insertIndex += 1
            }
        }
        
        oldHighScores.insert(HighScoreModel(name: UserDefaultsHelper.getUserName(), score: score), at: insertIndex)
        
        if oldHighScores.count > 10
        {
            oldHighScores.removeLast()
        }
        
        let highscoreData = try! PropertyListEncoder().encode(oldHighScores)
        UserDefaults.standard.set(highscoreData, forKey: "highscores")
        
        return insertIndex < 10 ? insertIndex : nil
    }
    
    static func getHighScores() -> [HighScoreModel]
    {
        if let fetchedData = UserDefaults.standard.data(forKey: "highscores")
        {
            return try! PropertyListDecoder().decode([HighScoreModel].self, from: fetchedData)
        }
        
        return [HighScoreModel]()
    }
}
