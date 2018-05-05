//
//  MenuViewController.swift
//  BubblePop
//
//  Copyright © 2018 Jason Kumar. All rights reserved.
//

import Foundation
import SnapKit

class MenuViewController: BaseViewController, UITextFieldDelegate
{
    // MARK: Properties
    
    var scrollView = UIScrollView()
    var contentView = UIView()
    
    var imgViewLogo = UIImageView(image: UIImage(named: "Logo"))
    var lblUsername = UILabel()
    var inptUsername = UITextField()
    
    var btnStartGame = UIButton()
    
    var isKeyboardShown: Bool!
    var keyboardHeight: CGFloat = 0
    
    
    // MARK: Lifecycle
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "Menu"
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: view.window)
        
        isKeyboardShown = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: Layout
    
    func setupView()
    {
        // NavigationBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(btnSettingsTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "High Score", style: .plain, target: self, action: #selector(btnHighScoreTapped))
        
        
        // scrollView
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive
        
        
        // contentView
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        contentView.isUserInteractionEnabled = true
        
        
        // imgViewLogo
        contentView.addSubview(imgViewLogo)
        imgViewLogo.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(SizeHelper.largeMargin())
            make.width.height.equalTo(view.frame.width / 3 * 2)
        })
        imgViewLogo.contentMode = .scaleAspectFit
        
        
        // inptUsername
        contentView.addSubview(inptUsername)
        inptUsername.snp.makeConstraints({ make in
            make.size.equalTo(CGSize(width: 200, height: 30))
            make.centerX.equalToSuperview()
            make.top.equalTo(imgViewLogo.snp.bottom).offset(SizeHelper.veryLargeMargin())
        })
        inptUsername.placeholder = "John Doe"
        inptUsername.text = UserDefaultsHelper.getUserName()
        inptUsername.textColor = .bp_almost_black()
        inptUsername.tintColor = .red
        inptUsername.clearButtonMode = .whileEditing
        inptUsername.borderStyle = .roundedRect
        inptUsername.contentVerticalAlignment = .center
        inptUsername.returnKeyType = .done
        inptUsername.autocorrectionType = .no
        inptUsername.addTarget(self, action: #selector(inptUsernameChanged), for: .editingChanged)
        inptUsername.delegate = self
        
        
        // lblUsername
        contentView.addSubview(lblUsername)
        lblUsername.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.top.equalTo(inptUsername.snp.bottom).offset(SizeHelper.mediumMargin())
        })
        lblUsername.textColor = .bp_dark_gray()
        lblUsername.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .light)
        lblUsername.textAlignment = .center
        lblUsername.numberOfLines = 0
        lblUsername.text = "Please enter your name before playing. Names are limited to 20 characters."
        
        
        // btnStartGame
        contentView.addSubview(btnStartGame)
        btnStartGame.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 150, height: 50))
            make.top.equalTo(lblUsername.snp.bottom).offset(SizeHelper.hugeMargin())
            make.centerX.equalToSuperview()
        }
        btnStartGame.layer.cornerRadius = 4
        btnStartGame.layer.masksToBounds = true
        btnStartGame.setBackgroundImage(UIImage(color: .red), for: .normal)
        btnStartGame.setBackgroundImage(UIImage(color: .bp_light_gray()), for: .disabled)
        btnStartGame.setTitle("Start Game", for: .normal)
        btnStartGame.addTarget(self, action: #selector(btnStartGameTapped), for: .touchUpInside)
        btnStartGame.isEnabled = (inptUsername.text?.count ?? 0) > 0
        
        
        // contentView
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(btnStartGame).offset(SizeHelper.hugeMargin())
        }
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
        let username = inptUsername.text ?? ""
        
        if username.replacingOccurrences(of: " ", with: "").count > 0
        {
            UserDefaultsHelper.setUserName(inptUsername.text ?? "")
            
            if let window = UIApplication.shared.delegate?.window
            {
                window?.swapRootViewControllerWithAnimation(GameViewController(), animationType: .push)
            }
        }
    }
    
    @objc func inptUsernameChanged(_ textField: UITextField)
    {
        btnStartGame.isEnabled = (inptUsername.text ?? "").replacingOccurrences(of: " ", with: "").count > 0
    }
    
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Hide keyboard
        textField.resignFirstResponder()
        
        // Also continue
        btnStartGameTapped()
        
        return false // We do not want UITextField to insert line-breaks.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let oldLength = textField.text?.count ?? 0
        let replacementLength = string.count
        let rangeLength = range.length
        
        let newLength = oldLength - rangeLength + replacementLength
        
        return newLength <= 20
    }
    
    
    // MARK: Additional Helpers
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        guard !isKeyboardShown else
        {
            return;
        }
        
        isKeyboardShown = true
        
        if let keyboardRect = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect
        {
            var insets = scrollView.contentInset
            
            keyboardHeight = keyboardRect.size.height
            
            insets.bottom += keyboardHeight
            
            scrollView.contentInset = insets
            scrollView.scrollIndicatorInsets = insets
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.imgViewLogo.snp.updateConstraints { update in
                update.height.equalTo(self.view.frame.width / 4)
            }
            self.imgViewLogo.superview?.layoutIfNeeded()
        })
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        guard isKeyboardShown else
        {
            return
        }
        
        isKeyboardShown = false
        
        var insets = scrollView.contentInset
        
        insets.bottom -= keyboardHeight
        
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
        
        keyboardHeight = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.imgViewLogo.snp.updateConstraints { update in
                update.height.equalTo(self.view.frame.width / 3 * 2)
            }
            self.imgViewLogo.superview?.layoutIfNeeded()
        })
    }
}

