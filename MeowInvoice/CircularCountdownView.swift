//
//  CircularCountdownView.swift
//  MeowInvoice
//
//  Created by David on 2017/6/5.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

final public class CircularCountdownView: UIView {
  
  private var secondLayerView: UIView!
  private var thirdLayerView: UIView!
  private var countdownDaysLabel: UILabel!
  private var countdownLabel: UILabel!
  private var openLotteryDateLabel: UILabel!
  
  // MARK: - Init
  public convenience init(size: CGFloat) {
    self.init(frame: CGRect(origin: .zero, size: CGSize(width: size, height: size)))
    
    backgroundColor = MeowInvoiceColor.countdownLayerColor.withAlpha(0.4)
    change(cornerRadius: bounds.width / 2)
    applyCircleShadow(shadowRadius: 20,
                      shadowOpacity: 0.4,
                      shadowColor: MeowInvoiceColor.countdownShadowLayerColor,
                      shadowOffset: CGSize(width: 3, height: 1))
    
    secondLayerView = generateCircularView(size: 0.875 * bounds.width)
    secondLayerView.centerX(inside: self).centerY(inside: self).anchor(to: self)
    
    thirdLayerView = generateCircularView(size: 0.7452 * bounds.width)
    thirdLayerView.centerX(inside: self).centerY(inside: self).anchor(to: self)
    
    configureCountdownDaysLabel()
    
    configureCountdownLabel()
    configureOpenLotteryDateLabel()
  }
  
  private override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func generateCircularView(size: CGFloat) -> UIView {
    let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: size, height: size)))
    view.backgroundColor = MeowInvoiceColor.countdownLayerColor.withAlpha(0.4)
    view.applyCircleShadow(shadowRadius: 20,
                           shadowOpacity: 0.4,
                           shadowColor: MeowInvoiceColor.countdownShadowLayerColor,
                           shadowOffset: CGSize(width: 3, height: 1))
    return view
  }
  
  private func configureCountdownDaysLabel() {
    countdownDaysLabel = UILabel()
    let countdownAttribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 64)]
    let countdownString = NSMutableAttributedString(string: "--", attributes: countdownAttribute)
    let dayAttribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
    let dayString = NSAttributedString(string: "天", attributes: dayAttribute)
    countdownString.append(dayString)
    countdownString.addAttributes([NSForegroundColorAttributeName: UIColor.white],
                                  range: NSRange.init(location: 0, length: countdownString.length))
    countdownDaysLabel.attributedText = countdownString
    countdownDaysLabel.sizeToFit()
    countdownDaysLabel.anchor(to: thirdLayerView).centerX(inside: thirdLayerView).move(16, pointsTopToAndInside: thirdLayerView)
  }
  
  private func configureOpenLotteryDateLabel() {
    openLotteryDateLabel = UILabel()
    openLotteryDateLabel.text = "09/25 開獎"
    openLotteryDateLabel.changeFontSize(to: 12)
    openLotteryDateLabel.changeTextColor(to: .white)
    openLotteryDateLabel.sizeToFit()
    openLotteryDateLabel.centerX(inside: thirdLayerView).move(4, pointBelow: countdownLabel).anchor(to: thirdLayerView)
  }
  
  private func configureCountdownLabel() {
    countdownLabel = UILabel()
    countdownLabel.text = "開獎倒數"
    countdownLabel.changeFontSize(to: 16)
    countdownLabel.changeTextColor(to: .white)
    countdownLabel.sizeToFit()
    countdownLabel.centerX(inside: thirdLayerView).move(0, pointBelow: countdownDaysLabel).anchor(to: thirdLayerView)
  }
  
  public func updateContent(with viewModel: CountDownInformationViewModel) {
    let countdownAttribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 64)]
    let countdownString = NSMutableAttributedString(string: "\(viewModel.countDownDays)", attributes: countdownAttribute)
    let dayAttribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
    let dayString = NSAttributedString(string: "天", attributes: dayAttribute)
    countdownString.append(dayString)
    countdownString.addAttributes([NSForegroundColorAttributeName: UIColor.white],
                                  range: NSRange.init(location: 0, length: countdownString.length))
    countdownDaysLabel.attributedText = countdownString
    countdownDaysLabel.sizeToFit()
    countdownDaysLabel.centerX(inside: thirdLayerView).move(16, pointsTopToAndInside: thirdLayerView)
    
    countdownLabel.centerX(inside: thirdLayerView).move(0, pointBelow: countdownDaysLabel)
    
    openLotteryDateLabel.text = "\(viewModel.nextOpenLotteryDate.month)/\(viewModel.nextOpenLotteryDate.day) 開獎"
    openLotteryDateLabel.sizeToFit()
    openLotteryDateLabel.centerX(inside: thirdLayerView).move(4, pointBelow: countdownLabel)
  }
  
}
