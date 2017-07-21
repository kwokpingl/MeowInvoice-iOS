//
//  DefaultKeys.swift
//  MeowInvoice
//
//  Created by David on 2017/6/14.
//  Copyright © 2017年 david. All rights reserved.
//

import SwiftyUserDefaults

extension DefaultsKeys {
  static let prizeSoundSetting = DefaultsKey<String?>("io.meow.prizeSoundSetting")
  static let getPrizeNotification = DefaultsKey<Bool>("io.meow.getPrizeNotification")
  
  static let thisMonthFirstSpecialPrize = DefaultsKey<String?>("io.meow.thisMonthFirstSpecialPrize")
  static let thisMonthSpecialPrize = DefaultsKey<String?>("io.meow.thisMonthSpecialPrize")
  static let thisMonthFirstPrizes = DefaultsKey<[String]?>("io.meow.thisMonthFirstPrizes")
  static let thisMonthAdditionalSixthPrize = DefaultsKey<[String]?>("io.meow.thisMonthAdditionalSixthPrize")
  static let thisMonthPeriodYear = DefaultsKey<Int?>("io.meow.thisMonthPeriodYear")
  static let thisMonthPeriodFromMonth = DefaultsKey<Int?>("io.meow.thisMonthPeriodFromMonth")
  static let thisMonthPeriodToMonth = DefaultsKey<Int?>("io.meow.thisMonthPeriodToMonth")
  
  static let previousMonthFirstSpecialPrize = DefaultsKey<String?>("io.meow.previousMonthFirstSpecialPrize")
  static let previousMonthSpecialPrize = DefaultsKey<String?>("io.meow.previousMonthSpecialPrize")
  static let previousMonthFirstPrizes = DefaultsKey<[String]?>("io.meow.previousMonthFirstPrizes")
  static let previousMonthAdditionalSixthPrize = DefaultsKey<[String]?>("io.meow.previousMonthAdditionalSixthPrize")
  static let previousMonthPeriodYear = DefaultsKey<Int?>("io.meow.previousMonthPeriodYear")
  static let previousMonthPeriodFromMonth = DefaultsKey<Int?>("io.meow.previousMonthPeriodFromMonth")
  static let previousMonthPeriodToMonth = DefaultsKey<Int?>("io.meow.previousMonthPeriodToMonth")
  
  static let receiveOpenLotteryNotification = DefaultsKey<Bool?>("io.meow.receiveOpenLotteryNotification")
  
  static let didLaunchOnce = DefaultsKey<Bool>("io.meow.didLaunchOnce")
}
