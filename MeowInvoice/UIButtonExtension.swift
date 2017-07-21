//
//  UIButtonExtension.swift
//  MeowInvoice
//
//  Created by David on 2017/6/4.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

extension UIButton {
  
  @discardableResult
  func change(fontSize: CGFloat) -> Self {
    titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    return self
  }
  
  func set(title: String?, titleColor: UIColor?, backgroundColor: UIColor, highlightBackgroundColor: UIColor) -> Self {
    setTitle(title, for: .normal)
    setTitleColor(titleColor, for: .normal)
    setBackgroundImage(UIImage.with(color: backgroundColor), for: .normal)
    setBackgroundImage(UIImage.with(color: highlightBackgroundColor), for: .highlighted)
    return self
  }
  
}
