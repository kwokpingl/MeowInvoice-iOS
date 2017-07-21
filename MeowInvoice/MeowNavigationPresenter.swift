//
//  MeowNavigationPresenter.swift
//  MeowInvoice
//
//  Created by David on 2017/6/15.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation

public protocol MeowNavigationPresenter {
  func loadContent()
  func presentMoreOptionView()
}

final public class MeowNavigationDefaultPresenter : MeowNavigationPresenter {
  private weak var view: MeowNavigationView?
  private let router: MeowNavigationRouter
  private let interactor: MeowNavigationInteractor
  
  required public init(view: MeowNavigationView, router: MeowNavigationRouter, interactor: MeowNavigationInteractor) {
    self.view = view
    self.router = router
    self.interactor = interactor
  }
  
  public func loadContent() {
    interactor.updateInvoiceAwards()
  }
  
  public func presentMoreOptionView() {
    router.navigateToMoreOptionView()
  }
  
}
