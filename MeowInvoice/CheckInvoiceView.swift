//
//  CheckInvoiceView.swift
//  MeowInvoice
//
//  Created by David on 2017/6/5.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

public protocol CheckInvoiceViewDelegate: class {
  func checkInvoiceView(didRequestToCheck invoiceAwards: InvoiceAwards)
}

final public class CheckInvoiceView: UIView {
  
  private var titleLabel: UILabel!
  private var thisMonthInvoiceInformationCheckerView: InvoiceInformationCheckerView!
  private var prevoiusMonthInvoiceInformationCheckerView: InvoiceInformationCheckerView!
  private let invoiceInformationCheckerViewLeftMargin = 24.cgFloat
  private let invoiceInformationCheckerViewMiddleSpacing = 32.cgFloat
  private let invoiceInformationCheckerViewTopSpacing = 32.cgFloat
  private var invoiceInformationCheckerViewWidth: CGFloat {
    return (bounds.width - 2 * invoiceInformationCheckerViewLeftMargin - invoiceInformationCheckerViewMiddleSpacing) / 2
  }
  
  public weak var delegate: CheckInvoiceViewDelegate?
  
  // MARK: - Init
  public convenience init(width: CGFloat) {
    self.init(frame: CGRect(origin: .zero, size: CGSize(width: width, height: 205)))
    
    configureTitleLabel()
    configurePrevoiusMonthInvoiceInformationCheckerView()
    configureThisMonthInvoiceInformationCheckerView()
    
    backgroundColor = .white
    change(cornerRadius: 8)
  }
  
  private override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configuration
  private func configureTitleLabel() {
    titleLabel = UILabel()
    let fontSize = 12.cgFloat
    titleLabel
      .changeFontSize(to: fontSize)
      .changeTextAlignment(to: .center)
      .changeTextColor(to: MeowInvoiceColor.mainOrange)
      .change(height: fontSize)
      .change(width: bounds.width)
      .move(24, pointsTopToAndInside: self)
      .centerX(to: self)
      .anchor(to: self)
    titleLabel.text = "喵查看"
  }
  
  private func configurePrevoiusMonthInvoiceInformationCheckerView() {
    prevoiusMonthInvoiceInformationCheckerView = InvoiceInformationCheckerView(width: invoiceInformationCheckerViewWidth)
    prevoiusMonthInvoiceInformationCheckerView
      .move(invoiceInformationCheckerViewLeftMargin, pointsLeadingToAndInside: self)
      .move(invoiceInformationCheckerViewTopSpacing, pointBelow: titleLabel)
      .anchor(to: self)
    prevoiusMonthInvoiceInformationCheckerView.delegate = self
  }
  
  private func configureThisMonthInvoiceInformationCheckerView() {
    thisMonthInvoiceInformationCheckerView = InvoiceInformationCheckerView(width: invoiceInformationCheckerViewWidth)
    thisMonthInvoiceInformationCheckerView
      .centerY(to: prevoiusMonthInvoiceInformationCheckerView)
      .move(invoiceInformationCheckerViewMiddleSpacing, pointsRightFrom: prevoiusMonthInvoiceInformationCheckerView)
      .anchor(to: self)
    thisMonthInvoiceInformationCheckerView.delegate = self
  }
  
  public func update(with viewModel: FrontPageInvoiceAwardsViewModel) {
    thisMonthInvoiceInformationCheckerView.update(with: viewModel.thisMonth)
    prevoiusMonthInvoiceInformationCheckerView.update(with: viewModel.previousMonth)
  }
  
}

extension CheckInvoiceView : InvoiceInformationCheckerViewDelegate {
  
  public func invoiceInformationCheckerView(didTapButtonToCheck invoiceAwards: InvoiceAwards) {
    delegate?.checkInvoiceView(didRequestToCheck: invoiceAwards)
  }
  
}
