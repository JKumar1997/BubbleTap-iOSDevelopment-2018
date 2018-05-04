//
//  GameScene.swift
//  BubblePop
//
//  Copyright © 2018 Jason Kumar. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene
{
    // MARK: Properties
    
    var gameStateDelegate: GameStateDelegate? = nil
    
    var time = 60
    var maxBubbleCount = 15
    var score = 0
    var lastPoppedColor = UIColor.clear // Dummy value as no combo is possible on first move
    let bubblePopSound = SKAction.playSoundFileNamed("pop.wav", waitForCompletion: false)
    
    override func didMove(to: SKView)
    {
        scene?.backgroundColor = .white
        
        // Fetch time and maxBubbleCount from UserDefaults
        time = UserDefaultsHelper.getGameTimer()
        maxBubbleCount = UserDefaultsHelper.getMaxBubbleCount()
        
        // Create game loop
        let step = SKAction.sequence([SKAction.run(gameStep), SKAction.wait(forDuration: 1.0), SKAction.run(gameTimeChange)])
        let loop = SKAction.repeat(step, count: time)
        let end = SKAction.run(gameEnd)
        
        run(SKAction.sequence([loop, end]))
    }
    
    // Main game loop, gets called every second
    func gameStep()
    {
        // Update game state
        gameStateDelegate?.updateState(time: time, score: score)
        
        // Remove random bubbles
        removeRandomBubbles()
        
        // Add random bubbles
        createRandomBubbles()
    }
    
    func gameTimeChange()
    {
        // Decrease timer
        time -= 1
        
        // Update game state
        gameStateDelegate?.updateState(time: time, score: score)
    }
    
    func gameEnd()
    {
        // Add highscore
        let index = UserDefaultsHelper.addHighScore(score)
        
        // Show Leaderboard
        if let window = UIApplication.shared.delegate?.window
        {
            window?.swapRootViewControllerWithAnimation(UINavigationController(rootViewController: HighScoreViewController(shouldShowBottomButtons: true, indexToHighlight: index)), animationType: .push)
        }
    }
    
    // MARK: User Interactions
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch: AnyObject in touches
        {
            let location = touch.location(in: self)
            
            // Iterate over all nodes the user touched
            for node in nodes(at: location)
            {
                if node.name == "Bubble"
                {
                    let bubble = node as! BubbleModel
                    
                    // Increase score
                    let multiplier = (lastPoppedColor == bubble.color) ? 1.5 : 1.0
                    let multipliedScore = Double(bubble.value) * multiplier
                    
                    score += Int(multipliedScore.rounded())
                    
                    // Update last popped color for combo bonus
                    lastPoppedColor = bubble.color
                    
                    // Remove the bubble
                    bubble.removeFromParent()
                    
                    // Play sound
                    run(bubblePopSound)
                    
                    // Update game state
                    gameStateDelegate?.updateState(time: time, score: score)
                }
            }
        }
    }
    
    // MARK: Additional Helpers
    
    // Iterates over all bubbles and for each one tosses a coin whether to remove or not
    func removeRandomBubbles()
    {
        for bubble in getAllBubbles()
        {
            if (Int(arc4random_uniform(100)) < 50)
            {
                bubble.removeFromParent()
            }
        }
    }
    
    func createRandomBubbles()
    {
        let bubbleCount = getAllBubbles().count
        
        if (bubbleCount >= maxBubbleCount)
        {
            return
        }
        
        let bubblesToCreate = Int.random(min: 1, max: maxBubbleCount - bubbleCount)
        
        for _ in (1...bubblesToCreate)
        {
            createSingleBubble()
        }
    }
    
    func createSingleBubble(retryCount: Int = 5)
    {
        // Get random location without extending beyond visible area
        let randX = CGFloat.random(min: 0, max: size.width - 2 * BubbleModel.radius)
        let randY = CGFloat.random(min: 0, max: size.height - 2 * BubbleModel.radius)
        let location = CGPoint(x: randX, y: randY)
        
        // Create circle around it
        let circle = SKShapeNode(circleOfRadius: 2 * BubbleModel.radius) // We don't have to create other circles now
        circle.position = location
        
        // Ensure bubble is not clipped by other bubble
        for bubble in getAllBubbles()
        {
            if circle.contains(bubble.position)
            {
                if retryCount > 0
                {
                    createSingleBubble(retryCount: retryCount - 1)
                }
                
                return
            }
        }
        
        // Determine colour and value
        var color: UIColor!
        var value: Int!
        
        let randomPerMille = Int(arc4random_uniform(1000))
        
        switch randomPerMille {
        case 0..<400:
            color = .red
            value = 1
        case 400..<700:
            color = .bp_pink()
            value = 2
        case 700..<850:
            color = .green
            value = 5
        case 850..<950:
            color = .blue
            value = 8
        default:
            color = .black
            value = 10
        }
        
        // Finally add bubble
        self.addChild(BubbleModel(position: location, color: color, value: value))
    }
    
    func getAllBubbles() -> [BubbleModel]
    {
        // TODO: Why is this sometimes EXP_BAD_ACCESS when restarting after waiting in HighScores for some time
        return children.filter({ node in (node.name ?? "") == "Bubble" }).map({ bubble in bubble as! BubbleModel })
    }
}
