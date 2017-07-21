//
//  CountDownService.swift
//  MeowInvoice
//
//  Created by David on 2017/6/6.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation

public protocol OpenLotteryCountDownService {
  var daysUntilNextOpenLotteryDate: Int { get }
  var nextOpenLotteryDate: Date { get }
  var thisOpenLotteryDate: Date { get }
  func nextOpenLotteryDate(of date: Date) -> Date
  func thisOpenLotteryDate(of date: Date) -> Date
}

public struct DefaultOpenLotteryCountDownService : OpenLotteryCountDownService {
  
  public var daysUntilNextOpenLotteryDate: Int {
    return nextOpenLotteryDate.daysToDate(Date())
  }
  
  public var nextOpenLotteryDate: Date {
    return nextOpenLotteryDate(of: Date())
  }
  
  public var thisOpenLotteryDate: Date {
    return thisOpenLotteryDate(of: Date())
  }
  
  public func nextOpenLotteryDate(of date: Date) -> Date {
    let thisDate = thisOpenLotteryDate(of: date)
    if thisDate.month == 11 {
      return Date.create(dateOnYear: thisDate.year + 1, month: 1, day: 25)!
    } else {
      return Date.create(dateOnYear: thisDate.year, month: thisDate.month + 2, day: 25)!
    }
  }
  
  public func thisOpenLotteryDate(of date: Date) -> Date {
    if let november25Period = Date.create(dateOnYear: date.year, month: 11, day: 25), date.isAfter(november25Period) {
      return november25Period
    } else if let september25Period = Date.create(dateOnYear: date.year, month: 9, day: 25), date.isAfter(september25Period) {
      return september25Period
    } else if let july25Period = Date.create(dateOnYear: date.year, month: 7, day: 25), date.isAfter(july25Period) {
      return july25Period
    } else if let may25Period = Date.create(dateOnYear: date.year, month: 5, day: 25), date.isAfter(may25Period) {
      return may25Period
    } else if let march25Period = Date.create(dateOnYear: date.year, month: 3, day: 25), date.isAfter(march25Period) {
      return march25Period
    } else if let jan25Period = Date.create(dateOnYear: date.year, month: 1, day: 25), date.isAfter(jan25Period) {
      return jan25Period
    } else {
      // previous year date
      return Date.create(dateOnYear: date.year - 1, month: 11, day: 25)!
    }
  }
  
}
