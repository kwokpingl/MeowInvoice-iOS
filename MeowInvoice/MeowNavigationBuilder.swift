//
//  MeowNavigationBuilder.swift
//  MeowInvoice
//
//  Created by David on 2017/6/15.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

public protocol MeowNavigationBuilder {
  func buildMeowNavigationModule() -> UIViewController?
}

final public class MeowNavigationDefaultBuilder : MeowNavigationBuilder {
  
  public func buildMeowNavigationModule() -> UIViewController? {
    let navigation = MeowNavigationController()
    
    let router = MeowNavigationDefaultRouter(viewController: navigation)
    let awardsStore = DefaultInvoiceAwardsStoreService()
    let fetcher = FetchInvoiceAwards()
    let interactor = MeowNavigationDefaultInteractor(awardsStore: awardsStore, fetcher: fetcher)
    let presenter = MeowNavigationDefaultPresenter(view: navigation,
                                                   router: router,
                                                   interactor: interactor)
    
    navigation.presenter = presenter
    
    return navigation
  }
  
}
