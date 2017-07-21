//
//  InvoiceInformationCheckerView.swift
//  MeowInvoice
//
//  Created by David on 2017/6/5.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

public protocol InvoiceInformationCheckerViewDelegate: class {
  func invoiceInformationCheckerView(didTapButtonToCheck invoiceAwards: InvoiceAwards)
}

final public class InvoiceInformationCheckerView: UIView {
  
  private var monthLabel: UILabel!
  private var redeemDateLabel: UILabel!
  private var checkInvoiceNumberButton: UIButton!
  
  private var invoiceAwards: InvoiceAwards?
  public weak var delegate: InvoiceInformationCheckerViewDelegate?
  
  // MARK: - Init
  public convenience init(width: CGFloat) {
    self.init(frame: CGRect(origin: .zero, size: CGSize(width: width, height: 100)))
    
    configureMonthLabel()
    configureRedeemDateLabel()
    configureCheckInvoiceNumberButton()
  }
  
  private override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configuration
  private func configureMonthLabel() {
    let fontSize = 16.cgFloat
    monthLabel = UILabel()
    monthLabel
      .changeTextAlignment(to: .center)
      .changeTextColor(to: MeowInvoiceColor.darkTextColor)
      .changeFontSize(to: fontSize)
      .change(width: bounds.width)
      .change(height: fontSize)
      .centerX(to: self)
      .move(0, pointsTopToAndInside: self)
      .anchor(to: self)
    monthLabel.text = "---年-.-月"
  }
  
  private func configureRedeemDateLabel() {
    let fontSize = 12.cgFloat
    redeemDateLabel = UILabel()
    redeemDateLabel
      .changeTextAlignment(to: .center)
      .changeTextColor(to: MeowInvoiceColor.darkTextColor)
      .changeFontSize(to: fontSize)
      .change(width: bounds.width)
      .change(height: fontSize)
      .centerX(to: self)
      .move(8, pointBelow: monthLabel)
      .anchor(to: self)
    redeemDateLabel.text = "領獎日 ?? - ??"
  }
  
  private func configureCheckInvoiceNumberButton() {
    let fontSize = 16.cgFloat
    checkInvoiceNumberButton = UIButton(type: UIButtonType.system)
    checkInvoiceNumberButton
      .set(title: "查看號碼",
           titleColor: .white,
           backgroundColor: MeowInvoiceColor.mainOrange,
           highlightBackgroundColor: MeowInvoiceColor.mainOrange)
      .change(fontSize: fontSize)
      .change(width: bounds.width)
      .change(height: 40)
      .change(cornerRadius: 20)
      .clipedToBounds()
      .move(0, pointsBottomToAndInside: self)
      .centerX(to: self)
      .anchor(to: self)
    checkInvoiceNumberButton.addTarget(self,
                                       action: #selector(InvoiceInformationCheckerView.checkInvoiceButtonClicked),
                                       for: .touchUpInside)
  }
  
  @objc private func checkInvoiceButtonClicked() {
    guard let invoiceAwards = invoiceAwards else { return }
    delegate?.invoiceInformationCheckerView(didTapButtonToCheck: invoiceAwards)
  }
  
  public func update(with invoiceAward: InvoiceAwards?) {
    self.invoiceAwards = invoiceAward
    if let invoiceAward = invoiceAward {
      monthLabel.text = "\(invoiceAward.period.year)年\(invoiceAward.period.fromMonth).\(invoiceAward.period.toMonth)月"
      let redeemAvailableDate = invoiceAward.issuedMonth.redeemAvailableDate
      redeemDateLabel.text = "領獎日 \(redeemAvailableDate.from.month)/\(redeemAvailableDate.from.day) - \(redeemAvailableDate.to.month)/\(redeemAvailableDate.to.day)"
    } else {
      monthLabel.text = "---年-.-月"
      redeemDateLabel.text = "領獎日 -/- - -/-"
    }
  }
  
}
