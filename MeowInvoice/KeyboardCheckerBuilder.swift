//
//  KeyboardCheckerBuilder.swift
//  MeowInvoice
//
//  Created by David on 2017/6/14.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

public protocol KeyboardCheckerBuilder {
  func buildKeyboardCheckerModule() -> UIViewController?
}

final public class KeyboardCheckerDefaultBuilder : KeyboardCheckerBuilder {
  
  public func buildKeyboardCheckerModule() -> UIViewController? {
    let view = KeyboardCheckerViewController()
    
    let router = KeyboardCheckerDefaultRouter(viewController: view)
    
    let validator = DefaultShortInvoiceValidationService()
    let invoiceAwardsStore = DefaultInvoiceAwardsStoreService()
    let interactor = KeyboardCheckerDefaultInteractor(validator: validator,
                                                      invoiceAwardsStore: invoiceAwardsStore)
    let presenter = KeyboardCheckerDefaultPresenter(view: view,
                                                    router: router,
                                                    interactor: interactor)
    
    view.presenter = presenter
    
    return view
  }
  
}
