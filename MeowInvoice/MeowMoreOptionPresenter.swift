//
//  MeowMoreOptionPresenter.swift
//  MeowInvoice
//
//  Created by David on 2017/6/14.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation

public protocol MeowMoreOptionPresenter {
  func closeMoreOptionView()
  func savePrizeAlertSound(at index: Int)
  func loadContent()
  var settingsListViewModel: SettingListViewModel { get }
  func changeReceiveOpenLotteryNotification(to state: Bool)
}

final public class MeowMoreOptionDefaultPresenter : MeowMoreOptionPresenter {

  private weak var view: MeowMoreOptionView?
  private let router: MeowMoreOptionRouter
  private let interactor: MeowMoreOptionInteractor
  
  required public init(view: MeowMoreOptionView, router: MeowMoreOptionRouter, interactor: MeowMoreOptionInteractor) {
    self.view = view
    self.router = router
    self.interactor = interactor
  }
  
  public func closeMoreOptionView() {
    router.navigateBack()
  }
  
  public func savePrizeAlertSound(at index: Int) {
    interactor.changePrizeAlertSound(at: index)
    view?.presentSelectedSound()
  }
  
  public func loadContent() {
    interactor.loadStoredSound()
    view?.presentInitialContent()
  }
  
  public var settingsListViewModel: SettingListViewModel {
    return interactor.settingsListViewModel
  }
  
  public func changeReceiveOpenLotteryNotification(to state: Bool) {
    interactor.changeReceiveOpenLotteryNotification(to: state)
  }
  
}
