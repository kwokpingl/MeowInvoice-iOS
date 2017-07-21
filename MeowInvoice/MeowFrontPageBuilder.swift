//
//  MeowFrontPageBuilder.swift
//  MeowInvoice
//
//  Created by David on 2017/6/6.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

public protocol MeowFrontPageBuilder {
  func buildMeowFrontPageModule() -> UIViewController?
}

public struct MeowFrontPageDefaultBuilder : MeowFrontPageBuilder {
  
  public func buildMeowFrontPageModule() -> UIViewController? {
    let view = MeowFrontPageViewController()
    
    let countDown = DefaultOpenLotteryCountDownService()
    let invoiceAwardsStore = DefaultInvoiceAwardsStoreService()
    let interactor = MeowFrontPageDefaultInteractor(countDownService: countDown, invoiceAwardsStore: invoiceAwardsStore)
    let router = MeowFrontPageDefaultRouter(viewController: view)
    let presenter = MeowFrontPageDefaultPresenter(interactor: interactor,
                                                  router: router,
                                                  view: view)
    
    view.presenter = presenter
    
    return view
  }
  
}
