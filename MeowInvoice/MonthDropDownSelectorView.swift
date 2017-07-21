//
//  MonthDropDownSelectorView.swift
//  MeowInvoice
//
//  Created by David on 2017/6/14.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit
import PromiseKit

public enum WhichMonth: String {
  case this = "當期"
  case previous = "上期"
  case both = "兩期"
}

public protocol MonthDropDownSelectorViewDelegate: class {
  func monthDropDownSelector(didSelect month: WhichMonth)
}

final public class MonthDropDownSelectorView: UIView {
  
  private var thisMonthLabel: UILabel!
  private var previousMonthLabel: UILabel!
  private var bothMonthLabel: UILabel!
  
  private var meowFootPrintImageView: UIImageView!
  
  private let labelLeftMargin = 44.cgFloat
  private let labelHeight = 44.cgFloat
  private let fontSize = 17.cgFloat
  private let textColor = MeowInvoiceColor.textColor
  
  public weak var delegate: MonthDropDownSelectorViewDelegate?
  
  public private(set) var invoiceAwards: (this: InvoiceAwards?, previous: InvoiceAwards?)
  
  // MARK: - Init
  public convenience init() {
    self.init(frame: CGRect(x: 0, y: 0, width: 188, height: 134))
    
    configureThisMonthLabel()
    configurePreviousMonthLabel()
    configureBothMonthLabel()
    configureMeowFootPrintImageView()
    
    backgroundColor = .white
    change(cornerRadius: 8)
    applyShadow(shadowRadius: 4, shadowOpacity: 0.2, shadowColor: .black, shadowOffset: CGSize(width: 0, height: 2))
    
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MonthDropDownSelectorView.tapped(gesture:))))
  }
  
  private override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureThisMonthLabel() {
    thisMonthLabel = generateLabel()
    thisMonthLabel.anchor(to: self)
    thisMonthLabel.text = "ya"
  }
  
  private func configurePreviousMonthLabel() {
    previousMonthLabel = generateLabel()
    previousMonthLabel.anchor(to: self).move(0, pointBelow: thisMonthLabel)
    previousMonthLabel.text = "ya"
  }
  
  private func configureBothMonthLabel() {
    bothMonthLabel = generateLabel()
    bothMonthLabel.anchor(to: self).move(0, pointBelow: previousMonthLabel)
    bothMonthLabel.text = "ya"
  }
  
  private func generateLabel() -> UILabel {
    let label = UILabel()
    label
      .changeFontSize(to: fontSize)
      .changeTextColor(to: textColor)
      .change(width: bounds.width - labelLeftMargin)
      .change(height: labelHeight)
      .move(labelLeftMargin, pointsLeadingToAndInside: self)
    
    return label
  }
  
  private func configureMeowFootPrintImageView() {
    meowFootPrintImageView = UIImageView()
    meowFootPrintImageView
      .change(height: 12)
      .change(width: 12)
      .move(16, pointsLeadingToAndInside: self)
      .centerY(to: thisMonthLabel)
      .anchor(to: self)
    meowFootPrintImageView.image = #imageLiteral(resourceName: "small_meow_foot_print")
  }
  
  @objc private func tapped(gesture: UITapGestureRecognizer) {
    let location = gesture.location(in: self)
    if location.y < 44 {
      moveFootPrint(to: thisMonthLabel)
      delegate?.monthDropDownSelector(didSelect: WhichMonth.this)
    } else if location.y < 88 {
      moveFootPrint(to: previousMonthLabel)
      delegate?.monthDropDownSelector(didSelect: WhichMonth.previous)
    } else {
      moveFootPrint(to: bothMonthLabel)
      delegate?.monthDropDownSelector(didSelect: WhichMonth.both)
    }
    dismiss(delay: 0.2)
  }
  
  @discardableResult
  private func moveFootPrint(to label: UILabel) -> Promise<Bool> {
    return UIView.promise(animateWithDuration: 0.2) { [weak self] in
      self?.meowFootPrintImageView.centerY(to: label)
    }
  }
  
  public func dropDown() {
    show()
    _ = UIView.promise(animateWithDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: { [weak self] in
      self?.dropDownState()
    }).then(execute: { [weak self] done -> Void in
      
    })
  }
  
  public func dismiss(delay: TimeInterval = 0.0) {
    _ = UIView.promise(animateWithDuration: 0.2, delay: delay, options: UIViewAnimationOptions.curveEaseInOut, animations: { [weak self] in
      self?.dismissState()
    }).then(execute: { [weak self] done -> Void in
      self?.hide()
    })
  }
  
  private func dismissState() {
    alpha = 0
    frame.size.height = 20
  }
  
  private func dropDownState() {
    alpha = 1
    frame.size.height = 134
  }
  
  public func updateUI(with invoiceAwards: (this: InvoiceAwards?, previous: InvoiceAwards?)) {
    self.invoiceAwards = invoiceAwards
    if let thisAwards = invoiceAwards.this, let previous = invoiceAwards.previous {
      let thisMonth = "\(thisAwards.period.fromMonth).\(thisAwards.period.toMonth)月對獎"
      let previousMonth = "\(previous.period.fromMonth).\(previous.period.toMonth)月對獎"
      thisMonthLabel.text = thisMonth
      previousMonthLabel.text = previousMonth
      bothMonthLabel.text = "兩期一起對獎"
    } else {
      thisMonthLabel.text = "沒有對獎資訊"
      previousMonthLabel.text = "沒有對獎資訊"
      bothMonthLabel.text = "沒有對獎資訊"
    }
  }
  
}
