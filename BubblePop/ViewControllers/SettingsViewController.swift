//
//  SettingsViewController.swift
//  BubblePop
//
//  Copyright © 2018 Jason Kumar. All rights reserved.
//

import Foundation
import SnapKit

class SettingsViewController: BaseViewController
{
    // MARK: Properties
    
    var scrollView = UIScrollView()
    var contentView = UIView()
    
    var txtGameTimer = UITextField()
    var sldGameTimer = UISlider()
    var lblGameTimer = UILabel()
    var txtMaxBubbleCount = UITextField()
    var sldMaxBubbleCount = UISlider()
    var lblMaxBubbleCount = UILabel()
    
    // MARK: Lifecycle
    
    // MARK: View Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "Settings"
        
        print(view.frame.size.width)
        print(view.frame.size.height)
        
        setupView()
    }
    
    // MARK: Layout
    
    func setupView()
    {
        // scrollView
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.alwaysBounceVertical = true
        
        
        // contentView
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        contentView.isUserInteractionEnabled = true
        
        
        // txtGameTimer
        contentView.addSubview(txtGameTimer)
        txtGameTimer.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset((navigationController?.navigationBar.frame.height ?? 0) + CGFloat(SizeHelper.hugeMargin()))
        }
        txtGameTimer.textColor = .bp_almost_black()
        txtGameTimer.isUserInteractionEnabled = false
        txtGameTimer.text = "Timeframe: \(UserDefaultsHelper.getGameTimer()) seconds"
        
        
        // sldGameTimer
        contentView.addSubview(sldGameTimer)
        sldGameTimer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.greaterThanOrEqualTo(200)
            make.width.lessThanOrEqualTo(400)
            make.left.greaterThanOrEqualTo(view).offset(SizeHelper.largeMargin())
            make.right.lessThanOrEqualTo(view).inset(SizeHelper.largeMargin())
            make.top.equalTo(txtGameTimer.snp.bottom).offset(SizeHelper.mediumMargin())
        }
        sldGameTimer.isContinuous = true
        sldGameTimer.minimumValue = 5
        sldGameTimer.maximumValue = 120
        sldGameTimer.value = Float(UserDefaultsHelper.getGameTimer())
        sldGameTimer.tintColor = .red
        sldGameTimer.addTarget(self, action: #selector(sldGameTimerChanged), for: .valueChanged)
        
        
        // lblGameTimer
        contentView.addSubview(lblGameTimer)
        lblGameTimer.snp.makeConstraints{ make in
            make.left.right.equalToSuperview().inset(SizeHelper.hugeMargin())
            make.top.equalTo(sldGameTimer.snp.bottom).offset(SizeHelper.largeMargin())
        }
        lblGameTimer.textColor = .bp_dark_gray()
        lblGameTimer.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .light)
        lblGameTimer.numberOfLines = 0
        lblGameTimer.textAlignment = .center
        lblGameTimer.text = "By dragging the slider you can set how many seconds the game takes to complete."
        
        
        // txtMaxBubbleCount
        contentView.addSubview(txtMaxBubbleCount)
        txtMaxBubbleCount.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lblGameTimer.snp.bottom).offset(SizeHelper.veryLargeMargin())
        }
        txtMaxBubbleCount.textColor = .bp_almost_black()
        txtMaxBubbleCount.isUserInteractionEnabled = false
        txtMaxBubbleCount.text = "Max. bubbles: \(UserDefaultsHelper.getMaxBubbleCount())"
        
        
        // sldMaxBubbleCount
        contentView.addSubview(sldMaxBubbleCount)
        sldMaxBubbleCount.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.greaterThanOrEqualTo(200)
            make.width.lessThanOrEqualTo(400)
            make.left.greaterThanOrEqualTo(view).offset(SizeHelper.largeMargin())
            make.right.lessThanOrEqualTo(view).inset(SizeHelper.largeMargin())
            make.top.equalTo(txtMaxBubbleCount.snp.bottom).offset(SizeHelper.mediumMargin())
        }
        sldMaxBubbleCount.isContinuous = true
        sldMaxBubbleCount.minimumValue = 5
        sldMaxBubbleCount.maximumValue = Float(getMaxBubbleCountForWorstCase())
        sldMaxBubbleCount.value = Float(UserDefaultsHelper.getMaxBubbleCount())
        sldMaxBubbleCount.tintColor = .red
        sldMaxBubbleCount.addTarget(self, action: #selector(sldMaxBubbleCountChanged), for: .valueChanged)
        
        
        // lblMaxBubbleCount
        contentView.addSubview(lblMaxBubbleCount)
        lblMaxBubbleCount.snp.makeConstraints{ make in
            make.left.right.equalToSuperview().inset(SizeHelper.hugeMargin())
            make.top.equalTo(sldMaxBubbleCount.snp.bottom).offset(SizeHelper.largeMargin())
        }
        lblMaxBubbleCount.textColor = .bp_dark_gray()
        lblMaxBubbleCount.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .light)
        lblMaxBubbleCount.numberOfLines = 0
        lblMaxBubbleCount.textAlignment = .center
        lblMaxBubbleCount.text = "By dragging the slider you can set the maximum number of bubbles that can be on screen simultaneously."
        
        
        // contentView
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(lblMaxBubbleCount).offset(SizeHelper.largeMargin())
        }
    }
    
    // MARK: User Interaction
    
    @objc func sldGameTimerChanged()
    {
        // Round to nearest int dividable by 5
        let rounded = roundToNearestInt(sldGameTimer.value, dividableBy: 5)
        
        txtGameTimer.text = "Timeframe: \(rounded) seconds"
        sldGameTimer.value = Float(rounded)
        
        // Save to UserDefaults
        UserDefaultsHelper.setGameTimer(rounded)
    }
    
    @objc func sldMaxBubbleCountChanged()
    {
        // Round to nearest int dividable by 5
        let rounded = roundToNearestInt(sldMaxBubbleCount.value, dividableBy: 1)
        
        txtMaxBubbleCount.text = "Max. bubbles: \(rounded)"
        sldMaxBubbleCount.value = Float(rounded)
        
        // Save to UserDefaults
        UserDefaultsHelper.setMaxBubbleCount(rounded)
    }
    
    // MARK: Additional Helpers
    
    func roundToNearestInt(_ floatToRound: Float, dividableBy: Int) -> Int
    {
        let divided = floatToRound / Float(dividableBy)
        return Int(divided.rounded()) * dividableBy
    }
    
    // Calculates how many bubbles can in any case be displayed.
    // This is not a precise calculation, but rather a very pessimistic estimate.
    // Being pessimistic helps with random placement of bubbles
    func getMaxBubbleCountForWorstCase() -> Int
    {
        let diameter = 2 * BubbleModel.radius
        
        let width = view.frame.size.width
        let height = view.frame.size.height - CGFloat(GameViewController.topBarHeight) // topBar cannot be populated by bubbles
        
        // Worst case for a row/column is best case of row/column - 1
        // Worst case for a 2d grid is still better, but we're not looking for the optimal solution here
        let rows = Int(height / diameter) - 1
        let columns = Int(width / diameter) - 1
        
        return rows * columns
    }
}
