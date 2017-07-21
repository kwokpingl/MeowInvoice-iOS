//
//  KeyboardInputView.swift
//  MeowInvoice
//
//  Created by David on 2017/6/5.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

public protocol KeyboardInputViewDelegate: class {
  func keyboardInputView(didEnterInvoice number: String)
}

final public class KeyboardInputView: UIView {
  
  private var inputDigitLabels: [UILabel] = []
  public private(set) var keyBuffer: [MeowKeyPad] = []
  public weak var delegate: KeyboardInputViewDelegate?
  
  // MARK: - Init
  public convenience init(width: CGFloat) {
    self.init(frame: CGRect(origin: .zero, size: CGSize(width: width, height: 98)))
    
    configureInputDigitLabels()
    showPlaceholder()
  }
  
  private override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureInputDigitLabels() {
    let fontSize = 36.cgFloat
    inputDigitLabels = [UILabel(), UILabel(), UILabel()]
    inputDigitLabels.forEach {
      $0.changeFontSize(to: fontSize)
        .changeTextAlignment(to: .center)
        .changeTextColor(to: MeowInvoiceColor.mainOrange)
        .change(width: fontSize)
        .change(height: fontSize)
        .anchor(to: self)
    }
    
    for (index, inputDigitLabel) in inputDigitLabels.enumerated() {
      let keyPadSpacing = 2.cgFloat
      let sizeOfKeyPad = (bounds.width - 2 * keyPadSpacing) / 6
      inputDigitLabel.centerY(inside: self)
      inputDigitLabel.center.x = sizeOfKeyPad * (index * 2 + 1).cgFloat + keyPadSpacing * index.cgFloat
    }
    
    inputDigitLabels.forEach {
      let underlineView = UIView()
      underlineView
        .change(width: $0.bounds.width)
        .change(height: 4)
        .move(12, pointBelow: $0)
        .centerX(to: $0)
        .anchor(to: self)
      underlineView.backgroundColor = $0.textColor
    }
  }
  
  public func clear() {
    keyBuffer.removeAll()
    updateViewUsingKeyBuffer()
  }
  
  public func input(key: MeowKeyPad) {
    switch key {
    case .backspace:
//      keyBuffer.popFirst()
      _ = keyBuffer.popLast()
    case .clear:
      keyBuffer.removeAll()
    default:
      if keyBuffer.count >= 3 {
        // clear buffer
        keyBuffer.removeAll()
      }
      // insert input key
//      keyBuffer.insert(key, at: 0)
      keyBuffer.append(key)
    }
    // update view
    updateViewUsingKeyBuffer()
    if keyBuffer.count == 3 {
//      let number = keyBuffer.reversed().reduce("", { $0.0 + $0.1.stringValue })
      let number = keyBuffer.reduce("", { $0.0 + $0.1.stringValue })
      delegate?.keyboardInputView(didEnterInvoice: number)
    }
  }
  
  private func updateViewUsingKeyBuffer() {
//    for (index, inputDigitLabel) in inputDigitLabels.reversed().enumerated() {
    for (index, inputDigitLabel) in inputDigitLabels.enumerated() {
      inputDigitLabel.text = keyBuffer[safe: index]?.stringValue
    }
    keyBuffer.isEmpty ? showPlaceholder() : hidePlaceholder()
  }
  
  private func showPlaceholder() {
    inputDigitLabels.forEach { $0.alpha = 0.3 }
    let placeholderText = ["後", "三", "碼"]
    for (index, inputDigitLabel) in inputDigitLabels.enumerated() {
      inputDigitLabel.text = placeholderText[index]
    }
  }
  
  private func hidePlaceholder() {
    inputDigitLabels.forEach { $0.alpha = 1.0 }
  }
  
}
