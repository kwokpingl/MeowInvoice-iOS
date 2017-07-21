//
//  SoundStoreService.swift
//  MeowInvoice
//
//  Created by David on 2017/6/14.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

public enum SoundName: String {
  case meow = "喵喵聲"
  case dingdone = "叮咚聲"
  case human = "人聲"
  
  public var value: String {
    return rawValue
  }
}

public protocol SoundStoreService {
  var prizeAlertSoundName: SoundName { get }
  var defaultPrizeAlertSoundName: SoundName { get }
  func set(prizeAlertSound name: SoundName)
}

final public class DefaultSoundStoreService : SoundStoreService {
  
  public var defaultPrizeAlertSoundName: SoundName {
    return .meow
  }
  
  public var prizeAlertSoundName: SoundName {
    let currentSoundName = SoundName(rawValue: Defaults[.prizeSoundSetting] ?? "")
    return currentSoundName ?? defaultPrizeAlertSoundName
  }
  
  public func set(prizeAlertSound name: SoundName) {
    AnalyticsHelper.instance().logChangeSoundSettingEvent(soundName: name)
    Defaults[.prizeSoundSetting] = name.value
  }
  
}
