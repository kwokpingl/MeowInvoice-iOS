//
//  NotificationSettingStoreService.swift
//  MeowInvoice
//
//  Created by David on 2017/7/10.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

public protocol NotificationSettingStoreService {
  var receiveOpenLotteryNotification: Bool { get }
  func set(receiveOpenLotteryNotification on: Bool)
  var isReceiveOpenLotteryNotificationDetermined: Bool { get }
}

final public class DefaultNotificationSettingStoreService : NotificationSettingStoreService {
  
  public var receiveOpenLotteryNotification: Bool {
    return Defaults[.receiveOpenLotteryNotification] ?? false
  }
  
  public func set(receiveOpenLotteryNotification on: Bool) {
    Defaults[.receiveOpenLotteryNotification] = on
    AnalyticsHelper.instance().logChangeNotificationSettingEvent(on: on)
  }
  
  public var isReceiveOpenLotteryNotificationDetermined: Bool {
    return Defaults[.receiveOpenLotteryNotification] == nil ? false : true
  }
  
}
