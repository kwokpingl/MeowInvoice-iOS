//
//  InvoiceAwardsStoreService.swift
//  MeowInvoice
//
//  Created by David on 2017/6/2.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

public protocol InvoiceAwardsStoreService {
  var thisMonth: InvoiceAwards? { get }
  var previousMonth: InvoiceAwards? { get }
  func updateInvoiceAwards(with newInvoiceAwards: (this: InvoiceAwards, previous: InvoiceAwards))
}

public struct DefaultInvoiceAwardsStoreService : InvoiceAwardsStoreService {
  
  public let defaults: UserDefaults
  
  init(defaults: UserDefaults = Defaults) {
    self.defaults = defaults
  }
  
  public var thisMonth: InvoiceAwards? {
    guard let firstSpecialPrize = defaults[.thisMonthFirstSpecialPrize],
          let firstPrizes = defaults[.thisMonthFirstPrizes],
          let specialPrize = defaults[.thisMonthSpecialPrize],
          let additionalSixthPrizes = defaults[.thisMonthAdditionalSixthPrize],
          let year = defaults[.thisMonthPeriodYear],
          let fromMonth = defaults[.thisMonthPeriodFromMonth],
          let toMonth = defaults[.thisMonthPeriodToMonth] else { return nil }
    return InvoiceAwards(firstSpecialPrize: firstSpecialPrize,
                         specialPrize: specialPrize,
                         firstPrizes: firstPrizes,
                         additionSixthPrizes: additionalSixthPrizes, period: (year: year, fromMonth: fromMonth, toMonth: toMonth))
  }
  
  public var previousMonth: InvoiceAwards? {
    guard let firstSpecialPrize = defaults[.previousMonthFirstSpecialPrize],
      let firstPrizes = defaults[.previousMonthFirstPrizes],
      let specialPrize = defaults[.previousMonthSpecialPrize],
      let additionalSixthPrizes = defaults[.previousMonthAdditionalSixthPrize],
      let year = defaults[.previousMonthPeriodYear],
      let fromMonth = defaults[.previousMonthPeriodFromMonth],
      let toMonth = defaults[.previousMonthPeriodToMonth] else { return nil }
    return InvoiceAwards(firstSpecialPrize: firstSpecialPrize,
                         specialPrize: specialPrize,
                         firstPrizes: firstPrizes,
                         additionSixthPrizes: additionalSixthPrizes, period: (year: year, fromMonth: fromMonth, toMonth: toMonth))
  }
  
  public func updateInvoiceAwards(with newInvoiceAwards: (this: InvoiceAwards, previous: InvoiceAwards)) {
    defaults[.thisMonthFirstSpecialPrize] = newInvoiceAwards.this.firstSpecialPrize.number
    defaults[.thisMonthFirstPrizes] = newInvoiceAwards.this.firstPrizes.map { $0.number }
    defaults[.thisMonthSpecialPrize] = newInvoiceAwards.this.specialPrize.number
    defaults[.thisMonthAdditionalSixthPrize] = newInvoiceAwards.this.additionSixthPrizes.map { $0.number }
    defaults[.thisMonthPeriodYear] = newInvoiceAwards.this.period.year
    defaults[.thisMonthPeriodFromMonth] = newInvoiceAwards.this.period.fromMonth
    defaults[.thisMonthPeriodToMonth] = newInvoiceAwards.this.period.toMonth
    
    defaults[.previousMonthFirstSpecialPrize] = newInvoiceAwards.previous.firstSpecialPrize.number
    defaults[.previousMonthFirstPrizes] = newInvoiceAwards.previous.firstPrizes.map { $0.number }
    defaults[.previousMonthSpecialPrize] = newInvoiceAwards.previous.specialPrize.number
    defaults[.previousMonthAdditionalSixthPrize] = newInvoiceAwards.previous.additionSixthPrizes.map { $0.number }
    defaults[.previousMonthPeriodYear] = newInvoiceAwards.previous.period.year
    defaults[.previousMonthPeriodFromMonth] = newInvoiceAwards.previous.period.fromMonth
    defaults[.previousMonthPeriodToMonth] = newInvoiceAwards.previous.period.toMonth
  }
  
}

public struct MockInvoiceAwardsStoreService : InvoiceAwardsStoreService {
  
  public var thisMonth: InvoiceAwards? {
    return InvoiceAwards(firstSpecialPrize: "74748874",
                         specialPrize: "82528918",
                         firstPrizes: ["07836485", "13410946", "96152286"],
                         additionSixthPrizes: ["996"], period: (year: 106, fromMonth: 3, toMonth: 4))
  }
  
  public var previousMonth: InvoiceAwards? {
    return InvoiceAwards(firstSpecialPrize: "82885130",
                         specialPrize: "59729884",
                         firstPrizes: ["04598625", "13193259", "87827366"],
                         additionSixthPrizes: ["125"], period: (year: 106, fromMonth: 1, toMonth: 2))
  }
  
  public func updateInvoiceAwards(with newInvoiceAwards: (this: InvoiceAwards, previous: InvoiceAwards)) {
    // do nothing.
  }
  
}
