//
//  GameViewController.swift
//  BubblePop
//
//  Copyright © 2018 Jason Kumar. All rights reserved.
//

import SnapKit
import SpriteKit

class GameViewController: UIViewController, GameStateDelegate
{
    // MARK: Properties
    
    let topBar = UIView()
    let lblScore = UILabel()
    let txtScore = UITextField()
    let lblTime = UILabel()
    let txtTime = UITextField()
    let lblHighScore = UILabel()
    let txtHighScore = UITextField()
    let lytGame = SKView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView()
    {
        // topBar
        view.addSubview(topBar)
        topBar.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(54)
        }
        topBar.backgroundColor = .bp_light_gray()
        
        // lblTime
        topBar.addSubview(lblTime)
        lblTime.snp.makeConstraints{ make in
            make.centerX.equalTo(topBar.snp.left).offset(SizeHelper.hugeMargin())
            make.top.equalToSuperview().offset(SizeHelper.smallMargin())
        }
        lblTime.textColor = .bp_almost_black()
        lblTime.text = "Time Left"
        
        // txtTime
        topBar.addSubview(txtTime)
        txtTime.snp.makeConstraints{ make in
            make.centerX.equalTo(lblTime)
            make.bottom.equalToSuperview().inset(SizeHelper.smallMargin())
        }
        txtTime.textColor = .bp_almost_black()
        txtTime.isUserInteractionEnabled = false
        
        // lblScore
        topBar.addSubview(lblScore)
        lblScore.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lblTime)
        }
        lblScore.textColor = .bp_almost_black()
        lblScore.text = "Score"
        
        // txtScore
        topBar.addSubview(txtScore)
        txtScore.snp.makeConstraints{ make in
            make.centerX.equalTo(lblScore)
            make.bottom.equalToSuperview().inset(SizeHelper.smallMargin())
        }
        txtScore.textColor = .bp_almost_black()
        txtScore.isUserInteractionEnabled = false
        
        // lblHighScore
        topBar.addSubview(lblHighScore)
        lblHighScore.snp.makeConstraints{ make in
            make.centerX.equalTo(topBar.snp.right).inset(SizeHelper.hugeMargin())
            make.top.equalTo(lblTime)
        }
        lblHighScore.textColor = .bp_almost_black()
        lblHighScore.text = "High Score"
        
        // txtHighScore
        topBar.addSubview(txtHighScore)
        txtHighScore.snp.makeConstraints{ make in
            make.centerX.equalTo(lblHighScore)
            make.bottom.equalToSuperview().inset(SizeHelper.smallMargin())
        }
        txtHighScore.textColor = .bp_almost_black()
        txtHighScore.isUserInteractionEnabled = false
        txtHighScore.text = "\(UserDefaultsHelper.getHighScores().first?.score ?? 0)"
        
        // lytGame
        view.addSubview(lytGame)
        lytGame.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(topBar.snp.bottom)
        }
        //lytGame.showsFPS = true
        //lytGame.showsNodeCount = true
        lytGame.ignoresSiblingOrder = true
        
        // scene
        let scene = GameScene(size: lytGame.bounds.size)
        scene.gameStateDelegate = self
        scene.scaleMode = .resizeFill
        
        lytGame.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    
    // MARK: GameStateDelegate
    
    func updateState(time: Int, score: Int)
    {
        txtTime.text = "\(time)"
        txtScore.text = "\(score)"
        
        if let currentHighScoreText = txtHighScore.text, let currentHighScore = Int(currentHighScoreText), score > currentHighScore
        {
            txtHighScore.text = "\(score)"
        }
    }
}
