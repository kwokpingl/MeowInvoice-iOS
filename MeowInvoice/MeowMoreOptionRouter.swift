//
//  MeowMoreOptionRouter.swift
//  MeowInvoice
//
//  Created by David on 2017/6/14.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

public protocol MeowMoreOptionRouter {
  func navigateBack()
}

final public class MeowMoreOptionDefaultRouter : MeowMoreOptionRouter {
  
  public weak var viewController: UIViewController?
  
  required public init(viewController: UIViewController) {
    self.viewController = viewController
  }
  
  public func navigateBack() {
    viewController?.asyncDismiss(true)
  }
  
}
