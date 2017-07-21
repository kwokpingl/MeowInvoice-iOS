//
//  MeowMoreOptionInteractor.swift
//  MeowInvoice
//
//  Created by David on 2017/6/14.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation
import UIKit

public protocol MeowMoreOptionInteractor {
  func changePrizeAlertSound(at index: Int)
  var prizeAlertSoundName: SoundName { get }
  var settingsListViewModel: SettingListViewModel { get set }
  func loadStoredSound()
  func changeReceiveOpenLotteryNotification(to state: Bool)
  var receiveOpenLotteryNotification: Bool { get }
}

final public class MeowMoreOptionDefaultInteractor : MeowMoreOptionInteractor {
  
  private let soundStore: SoundStoreService
  private let notificationStore: NotificationSettingStoreService
  
  public var settingsListViewModel: SettingListViewModel =
    SettingListViewModel(listCount: 2,
                         sountListTitle: "聲音設定",
                         soundList: [SoundSettingViewModel(soundName: .meow, selected: false),
                                     SoundSettingViewModel(soundName: .dingdone, selected: false),
                                     SoundSettingViewModel(soundName: .human, selected: false)],
                         otherSettingTitle: "其他設定",
                         otherSettingList: [OtherSettingViewModel(title: "收到對獎通知", isOn: true)])
  
  required public init(soundStore: SoundStoreService, notificationStore: NotificationSettingStoreService) {
    self.soundStore = soundStore
    self.notificationStore = notificationStore
    settingsListViewModel.otherSettingList[0].isOn = receiveOpenLotteryNotification
  }
  
  public func changePrizeAlertSound(at index: Int) {
    for (index, _) in settingsListViewModel.soundList.enumerated() {
      settingsListViewModel.soundList[index].selected = false
    }
    settingsListViewModel.soundList[index].selected = true
    let name = settingsListViewModel.soundList[index].soundName
    soundStore.set(prizeAlertSound: name)
  }
  
  public var prizeAlertSoundName: SoundName {
    return soundStore.prizeAlertSoundName
  }
  
  public func loadStoredSound() {
    for (index, sound) in settingsListViewModel.soundList.enumerated() {
      if sound.soundName == prizeAlertSoundName {
        settingsListViewModel.soundList[index].selected = true
        break
      }
    }
  }
  
  public func changeReceiveOpenLotteryNotification(to state: Bool) {
    notificationStore.set(receiveOpenLotteryNotification: state)
    if state {
      // is on
      UIApplication.shared.registerForRemoteNotifications()
    } else {
      // is off
      UIApplication.shared.unregisterForRemoteNotifications()
    }
  }
  
  public var receiveOpenLotteryNotification: Bool {
    return notificationStore.receiveOpenLotteryNotification
  }
  
}
