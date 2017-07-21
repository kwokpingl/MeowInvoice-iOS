//
//  MeowKeyboardKeyView.swift
//  MeowInvoice
//
//  Created by David on 2017/6/5.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

public enum MeowKeyPad {
  case one, two, three, four, five, six, seven, eight, nine, zero
  case clear
  case backspace
  
  public var stringValue: String {
    switch self {
    case .one: return "1"
    case .two: return "2"
    case .three: return "3"
    case .four: return "4"
    case .five: return "5"
    case .six: return "6"
    case .seven: return "7"
    case .eight: return "8"
    case .nine: return "9"
    case .zero: return "0"
    case .clear: return "清除"
    case .backspace: return "倒退"
    }
  }
}

public protocol MeowKeyboardKeyViewDelegate: class {
  func meowKeyboardKeyView(didTapOn keyPad: MeowKeyPad)
}

final public class MeowKeyboardKeyView: UIView {
  
  private var keyPadLabel: UILabel!
  public private(set) var keyPad: MeowKeyPad!
  public weak var delegate: MeowKeyboardKeyViewDelegate?
  
  // MARK: - Init
  public convenience init(width: CGFloat, height: CGFloat, keyPad: MeowKeyPad) {
    self.init(frame: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
    self.keyPad = keyPad
    
    configureKeyPadLabel()
    
    backgroundColor = .white
    clipedToBounds()
    
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MeowKeyboardKeyView.tapped(gesture:))))
  }
  
  private override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureKeyPadLabel() {
    keyPadLabel = UILabel()
    keyPadLabel
      .changeTextAlignment(to: .center)
      .changeFontSize(to: 32)
      .changeTextColor(to: MeowInvoiceColor.textColor)
      .change(width: bounds.width)
      .change(height: bounds.height)
      .centerX(inside: self)
      .centerY(inside: self)
      .anchor(to: self)
    keyPadLabel.text = keyPad.stringValue
  }
  
  @objc private func tapped(gesture: UITapGestureRecognizer) {
    let location = gesture.location(in: self)
    showFootPrint(on: location)
    delegate?.meowKeyboardKeyView(didTapOn: keyPad)
  }
  
  private func showFootPrint(on location: CGPoint) {
    let footPrint = UIImageView().change(width: 50).change(height: 48)
    footPrint.contentMode = .scaleAspectFill
    footPrint.image = #imageLiteral(resourceName: "meow_foot_print_on_key_pad")
    footPrint.anchor(to: self)
    footPrint.center = location
    let duration = Double(Int.random() % 5) / 5 + 0.5
    UIView.animate(withDuration: duration, animations: {
      footPrint.alpha = 0
    }) { (_) in
      footPrint.removeFromSuperview()
    }
  }
  
  public func adjust(size: CGSize) {
    frame.size = size
    keyPadLabel.frame = bounds
  }
  
}
