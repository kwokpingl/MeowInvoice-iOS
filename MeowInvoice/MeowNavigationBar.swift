//
//  MeowNavigationBar.swift
//  MeowInvoice
//
//  Created by David on 2017/6/4.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

public enum MeowNavigationTab {
  case frontPage
  case keyboard
  case scanQRCode
}

public protocol MeowNavigationBarDelegate: class {
  func meowNavigationBar(didChangeTo tab: MeowNavigationTab)
  func meowNavigationBarDidClickMoreOptionButton()
}

final public class MeowNavigationBar: UIView {
  
  private var moreOptionButton: UIButton!
  private var frontPageButton: UIButton!
  private var keyboardButton: UIButton!
  private var scanQRCodeButton: UIButton!
  private let fontSize: CGFloat = 16
  private var bottomFocusLine: UIView!
  
  public weak var delegate: MeowNavigationBarDelegate?
  
  // MARK: - Init
  public convenience init(width: CGFloat) {
    self.init(frame: CGRect(origin: CGPoint.zero,
                            size: CGSize(width: width, height: 64)))
    
    applyShadow(shadowRadius: 4, shadowOpacity: 0.05, shadowColor: .black, shadowOffset: CGSize(width: 0, height: 2))
    
    configureMoreOptionButton()
    configureButtons()
    configureBottomFocusLine()
    focus(on: MeowNavigationTab.frontPage)

    backgroundColor = MeowInvoiceColor.mainOrange
  }
  
  private override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configuration
  private func configureMoreOptionButton() {
    moreOptionButton = UIButton(type: UIButtonType.system)
    moreOptionButton
      .change(width: 24)
      .change(height: 24)
    moreOptionButton.setImage(#imageLiteral(resourceName: "more_icon"), for: UIControlState.normal)
    moreOptionButton.tintColor = .white
    
    moreOptionButton
      .move(10, pointsBottomToAndInside: self)
      .move(12, pointsTrailingToAndInside: self)
    
    moreOptionButton.anchor(to: self)
    moreOptionButton.addTarget(self, action: #selector(MeowNavigationBar.moreOptionClicked), for: UIControlEvents.touchUpInside)
    
    let extendedView = HitTestExtendedView(withWidth: 40, andReceiverView: moreOptionButton)
    extendedView.centerX(to: moreOptionButton).centerY(to: moreOptionButton).anchor(to: self)
  }
  
  private func configureButtons() {
    frontPageButton = generateTitledButton(title: "首頁")
    frontPageButton
      .centerY(to: moreOptionButton)
      .move(fontSize, pointsLeadingToAndInside: self)
      .anchor(to: self)
    keyboardButton = generateTitledButton(title: "鍵盤")
    keyboardButton
      .centerY(to: moreOptionButton)
      .move(0, pointsRightFrom: frontPageButton)
      .anchor(to: self)
    scanQRCodeButton = generateTitledButton(title: "掃描")
    scanQRCodeButton
      .centerY(to: moreOptionButton)
      .move(0, pointsRightFrom: keyboardButton)
      .anchor(to: self)
    [frontPageButton, keyboardButton, scanQRCodeButton].forEach {
      $0?.addTarget(self, action: #selector(MeowNavigationBar.tabButtonClicked(_:)), for: UIControlEvents.touchUpInside)
    }
  }
  
  private func generateTitledButton(title: String) -> UIButton {
    let button = UIButton(type: UIButtonType.system)
    button.setTitle(title, for: .normal)
    button.setTitleColor(.white, for: .normal)
    button
      .change(fontSize: fontSize)
      .change(height: 36
      )
      .change(width: fontSize * 4)
    button.titleLabel?.changeTextAlignment(to: .center)
    return button
  }
  
  private func configureBottomFocusLine() {
    bottomFocusLine = UIView()
    bottomFocusLine
      .change(width: fontSize * 2)
      .change(height: 2)
      .move(0, pointsBottomToAndInside: self)
      .anchor(to: self)
    bottomFocusLine.backgroundColor = .white
  }
  
  private func focus(on tab: MeowNavigationTab, animated: Bool = false) {
    if animated {
      UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: { [weak self] in
          self?.moveBottomFocusLine(to: tab)
      }, completion: nil)
    } else {
      moveBottomFocusLine(to: tab)
    }
  }
  
  private func moveBottomFocusLine(to tab: MeowNavigationTab) {
    switch tab {
    case .frontPage:
      bottomFocusLine.centerX(to: frontPageButton)
    case .keyboard:
      bottomFocusLine.centerX(to: keyboardButton)
    case .scanQRCode:
      bottomFocusLine.centerX(to: scanQRCodeButton)
    }
  }
  
  @objc private func tabButtonClicked(_ button: UIButton) {
    var tab: MeowNavigationTab?
    switch button {
    case frontPageButton: tab = MeowNavigationTab.frontPage
    case keyboardButton: tab = MeowNavigationTab.keyboard
    case scanQRCodeButton: tab = MeowNavigationTab.scanQRCode
    default: tab = nil
    }
    guard let _tab = tab else { return }
    focus(on: _tab, animated: true)
    delegate?.meowNavigationBar(didChangeTo: _tab)
  }
  
  @objc private func moreOptionClicked() {
    delegate?.meowNavigationBarDidClickMoreOptionButton()
  }
  
  public func updateTabIndicator(with progress: CGFloat) {
    let sectionWidth = keyboardButton.center.x - frontPageButton.center.x
    bottomFocusLine.center.x = frontPageButton.center.x + sectionWidth * progress
  }
  
}
