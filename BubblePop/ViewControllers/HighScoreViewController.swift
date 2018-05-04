//
//  HighScoreViewController.swift
//  BubblePop
//
//  Copyright © 2018 Jason Kumar. All rights reserved.
//

import Foundation
import SnapKit

class HighScoreViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource
{
    // MARK: Properties
    
    var tableView = UITableView()
    var btnMenu = UIButton()
    var btnRestartGame = UIButton()
    
    var shouldShowBottomButtons = false
    var indexToHighlight: Int? = nil
    var highscores: [HighScoreModel]!
    
    // MARK: Lifecycle
    
    init(shouldShowBottomButtons: Bool = false, indexToHighlight: Int? = nil)
    {
        self.shouldShowBottomButtons = shouldShowBottomButtons
        self.indexToHighlight = indexToHighlight
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "Leaderboard"
        
        setupView()
        
        highscores = UserDefaultsHelper.getHighScores()
    }
    
    // MARK: Layout
    
    func setupView()
    {
        // tableView
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.size.equalToSuperview()
        })
        tableView.contentInset = UIEdgeInsetsMake(0, 0, shouldShowBottomButtons ? CGFloat(50 + 2 * SizeHelper.largeMargin()) : 0, 0)
        tableView.delegate = self
        tableView.dataSource = self
        
        // btnMenu
        view.addSubview(btnMenu)
        btnMenu.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 125, height: 50))
            make.right.equalTo(view.snp.centerX).offset(-1 * SizeHelper.largeMargin())
            make.bottom.equalToSuperview().inset(SizeHelper.largeMargin())
        }
        btnMenu.layer.cornerRadius = 4
        btnMenu.layer.masksToBounds = true
        btnMenu.setBackgroundImage(UIImage(color: .bp_medium_gray()), for: .normal)
        btnMenu.setTitle("Menu", for: .normal)
        btnMenu.setTitleColor(.white, for: .normal)
        btnMenu.addTarget(self, action: #selector(btnMenuTapped), for: .touchUpInside)
        btnMenu.isHidden = !shouldShowBottomButtons
        
        
        // btnRestartGame
        view.addSubview(btnRestartGame)
        btnRestartGame.snp.makeConstraints { make in
            make.size.equalTo(btnMenu)
            make.left.equalTo(view.snp.centerX).offset(SizeHelper.largeMargin())
            make.bottom.equalTo(btnMenu)
        }
        btnRestartGame.layer.cornerRadius = 4
        btnRestartGame.layer.masksToBounds = true
        btnRestartGame.setBackgroundImage(UIImage(color: .red), for: .normal)
        btnRestartGame.setTitle("Restart", for: .normal)
        btnRestartGame.setTitleColor(.white, for: .normal)
        btnRestartGame.addTarget(self, action: #selector(btnRestartGameTapped), for: .touchUpInside)
        btnRestartGame.isHidden = !shouldShowBottomButtons
    }
    
    // MARK: User Interaction
    
    @objc func btnMenuTapped()
    {
        if let window = UIApplication.shared.delegate?.window
        {
            window?.swapRootViewControllerWithAnimation(UINavigationController(rootViewController: MenuViewController()), animationType: .pop)
        }
    }
    
    @objc func btnRestartGameTapped()
    {
        if let window = UIApplication.shared.delegate?.window
        {
            window?.swapRootViewControllerWithAnimation(GameViewController(), animationType: .push)
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 54
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return highscores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let highscore = highscores[indexPath.row]
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "HighScoreCell")
        
        if cell == nil
        {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "HighScoreCell")
        }
        
        cell!.backgroundColor = (indexPath.row == indexToHighlight) ? .bp_light_gray() : nil
        cell!.selectionStyle = .none
        cell!.textLabel?.text = highscore.name
        cell!.detailTextLabel?.text = "Score: \(highscore.score)"
        
        return cell!
    }
}
