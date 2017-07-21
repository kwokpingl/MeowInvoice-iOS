//
//  MeowNavigationRouter.swift
//  MeowInvoice
//
//  Created by David on 2017/6/15.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

public protocol MeowNavigationRouter {
  func navigateToMoreOptionView()
}

final public class MeowNavigationDefaultRouter : MeowNavigationRouter {
  
  public weak var viewController: UIViewController?
  private let transitionManager = MeowNavigationTransitioningDelegate()
  
  required public init(viewController: UIViewController) {
    self.viewController = viewController
  }
  
  public func navigateToMoreOptionView() {
    AnalyticsHelper.instance().logShowSettingsPageEvent()
    let module = MeowMoreOptionDefaultBuilder().buildMeowMoreOptionModule()
    transitionManager.presentingViewController = module
    viewController?.asyncPresent(module, animated: true)
  }
  
}
