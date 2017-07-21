//
//  KeyboardCheckerRouter.swift
//  MeowInvoice
//
//  Created by David on 2017/6/14.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

public protocol KeyboardCheckerRouter {
  
}

final public class KeyboardCheckerDefaultRouter : KeyboardCheckerRouter {
  
  public weak var viewController: UIViewController?  
  
  public init(viewController: UIViewController) {
    self.viewController = viewController
  }
 
}
