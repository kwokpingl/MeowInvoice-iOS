//
//  MeowMoreOptionBuilder.swift
//  MeowInvoice
//
//  Created by David on 2017/6/14.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

public protocol MeowMoreOptionBuilder {
  func buildMeowMoreOptionModule() -> UIViewController?
}

final public class MeowMoreOptionDefaultBuilder : MeowMoreOptionBuilder {
  
  public func buildMeowMoreOptionModule() -> UIViewController? {
    let view = MeowMoreOptionViewController()
    
    let router = MeowMoreOptionDefaultRouter(viewController: view)
    let soundStore = DefaultSoundStoreService()
    let notificationStore = DefaultNotificationSettingStoreService()
    let interactor = MeowMoreOptionDefaultInteractor(soundStore: soundStore, notificationStore: notificationStore)
    let presenter = MeowMoreOptionDefaultPresenter(view: view, router: router, interactor: interactor)
    
    view.presenter = presenter
    
    return view
  }
  
}
