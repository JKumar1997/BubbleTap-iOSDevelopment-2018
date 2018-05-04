//
//  MenuViewController.swift
//  BubblePop
//
//  Copyright © 2018 Jason Kumar. All rights reserved.
//

import Foundation
import SnapKit

class MenuViewController: BaseViewController
{
    // MARK: Properties
    
    var lblWelcome = UILabel()
    var btnStartGame = UIButton()
    
    // MARK: Lifecycle
    
    // Custom initializers go here
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "Menu"
        
        setupView()
    }
    
    // MARK: Layout
    
    func setupView()
    {
        // NavigationBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(btnSettingsTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "High Score", style: .plain, target: self, action: #selector(btnHighScoreTapped))
        
        // lblWelcome
        view.addSubview(lblWelcome)
        lblWelcome.snp.makeConstraints({ make in
            make.left.equalToSuperview().inset(SizeHelper.largeMargin())
            make.right.equalToSuperview().inset(SizeHelper.largeMargin())
            make.centerY.equalToSuperview()
        })
        lblWelcome.textAlignment = .center
        lblWelcome.text = "Hello \(UserDefaultsHelper.getUserName())!"
        
        // btnStartGame
        view.addSubview(btnStartGame)
        btnStartGame.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 150, height: 50))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(SizeHelper.largeMargin())
        }
        btnStartGame.layer.cornerRadius = 4
        btnStartGame.layer.masksToBounds = true
        btnStartGame.setBackgroundImage(UIImage(color: .red), for: .normal)
        btnStartGame.setTitle("Start Game", for: .normal)
        btnStartGame.setTitleColor(.white, for: .normal)
        btnStartGame.addTarget(self, action: #selector(btnStartGameTapped), for: .touchUpInside)
    }
    
    // MARK: User Interaction
    
    @objc func btnSettingsTapped(sender: UIButton!)
    {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    @objc func btnHighScoreTapped()
    {
        navigationController?.pushViewController(HighScoreViewController(), animated: true)
    }
    
    @objc func btnStartGameTapped()
    {
        if let window = UIApplication.shared.delegate?.window
        {
            window?.swapRootViewControllerWithAnimation(GameViewController(), animationType: .push)
        }
    }
}

