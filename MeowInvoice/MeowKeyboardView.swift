//
//  MeowKeyboardView.swift
//  MeowInvoice
//
//  Created by David on 2017/6/5.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

public protocol MeowKeyboardViewDelegate: class {
  func meowKeyboardView(didTapOn keyPad: MeowKeyPad)
}

final public class MeowKeyboardView: UIView {
  
  private var keyPads: [MeowKeyboardKeyView] = []
  private let keyPadSpacing: CGFloat = 2
  private var keyPadSize: CGSize {
    let width = (bounds.width - 2 * keyPadSpacing) / 3
    let height = (bounds.height - 3 * keyPadSpacing) / 4
    return CGSize(width: width, height: height)
  }
  
  public weak var delegate: MeowKeyboardViewDelegate?
  
  // MARK: - Init
  public convenience init(width: CGFloat, height: CGFloat) {
    self.init(frame: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
    
    configureKeyPads()
    
  }
  
  private override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureKeyPads() {
    let keys: [MeowKeyPad] = [.one, .two, .three,
                                .four, .five, .six,
                                .seven, .eight, .nine,
                                .clear, .zero, .backspace]
    keys.forEach({
      let size = keyPadSize
      let keyPad = MeowKeyboardKeyView(width: size.width, height: size.height, keyPad: $0)
      keyPads.append(keyPad)
      keyPad.anchor(to: self)
      keyPad.delegate = self
    })
    
    arrangeKeyPads()
  }
  
  private func arrangeKeyPads() {
    for (index, keyPad) in keyPads.enumerated() {
      let row = index / 3
      let column = index % 3
      let x = column.cgFloat * (keyPadSize.width + keyPadSpacing)
      let y = row.cgFloat * (keyPadSize.height + keyPadSpacing)
      keyPad
        .move(x, pointsLeadingToAndInside: self)
        .move(y, pointsTopToAndInside: self)
    }
  }
  
  public func adjustHeight(to height: CGFloat) {
    frame.size.height = height
    keyPads.forEach { $0.adjust(size: keyPadSize) }
    arrangeKeyPads()
  }
  
}

extension MeowKeyboardView : MeowKeyboardKeyViewDelegate {
  
  public func meowKeyboardKeyView(didTapOn keyPad: MeowKeyPad) {
    MeowSound.play().tick()
    delegate?.meowKeyboardView(didTapOn: keyPad)
  }
  
}
