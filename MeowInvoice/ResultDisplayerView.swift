//
//  ResultDisplayerView.swift
//  MeowInvoice
//
//  Created by David on 2017/6/6.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

final public class ResultDisplayerView: UIView {
  
  private var resultLabel: UILabel!
  private var detailResultLabel: UILabel!
  
  // MARK: - Init
  public convenience init(width: CGFloat, height: CGFloat) {
    self.init(frame: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
    
    configureResultLabel()
    configureDetailResultLabel()
    
    backgroundColor = MeowInvoiceColor.backgroundOrange
  }
  
  private override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureResultLabel() {
    resultLabel = UILabel()
    let fontSize = 32.cgFloat
    resultLabel
      .changeFontSize(to: fontSize)
      .changeTextColor(to: .white)
      .changeTextAlignment(to: .center)
      .change(height: fontSize)
      .change(width: bounds.width)
      .anchor(to: self)
      .centerX(inside: self)
      .move(32, pointsTopToAndInside: self)
    resultLabel.text = ""
  }
  
  private func configureDetailResultLabel() {
    detailResultLabel = UILabel()
    let fontSize = 16.cgFloat
    detailResultLabel
      .changeFontSize(to: fontSize)
      .changeTextColor(to: MeowInvoiceColor.darkTextColor)
      .changeTextAlignment(to: .center)
      .change(height: fontSize)
      .change(width: bounds.width)
      .anchor(to: self)
      .centerX(inside: self)
      .move(12, pointBelow: resultLabel)
    detailResultLabel.text = ""
  }
  
  public func update(with viewModel: ShortInvoiceValidationViewModel) {
    resultLabel.text = viewModel.title
    detailResultLabel.attributedText = viewModel.subtitle
  }
  
  public func clearResult() {
    resultLabel.text = ""
    detailResultLabel.text = ""
  }
  
}
