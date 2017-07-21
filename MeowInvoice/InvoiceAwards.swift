//
//  InvoiceAwards.swift
//  MeowInvoice
//
//  Created by David on 2017/5/29.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation
import NetworkRequestKit
import Kanna

public struct InvoiceAwards {
  public let period: (year: Int, fromMonth: Int, toMonth: Int)
  public let firstSpecialPrize: Invoice
  public let specialPrize: Invoice
  public let firstPrizes: [Invoice]
  public let additionSixthPrizes: [ShortInvoice]
  
  init?(firstSpecialPrize: String,
        specialPrize: String,
        firstPrizes: [String],
        additionSixthPrizes: [String],
        period: (year: Int, fromMonth: Int, toMonth: Int)) {
    guard let _firstSpecialPrize = Invoice(number: firstSpecialPrize) else { return nil }
    guard let _specialPrize = Invoice(number: specialPrize) else { return nil }
    
    let _firstPrizes = firstPrizes.flatMap(Invoice.init)
    guard _firstPrizes.count > 0 else { return nil }
    
    let _additionSixthPrizes = additionSixthPrizes.flatMap(ShortInvoice.init)
    
    self.firstSpecialPrize = _firstSpecialPrize
    self.specialPrize = _specialPrize
    self.firstPrizes = _firstPrizes
    self.additionSixthPrizes = _additionSixthPrizes
    guard period.fromMonth < period.toMonth,
          period.fromMonth % 2 == 1,
          period.toMonth % 2 == 0 else { return nil }
    self.period = period
  }
  
  public var issuedMonth: InvoiceIssuedMonth {
    let date = Date.create(dateOnYear: period.year + 1911, month: period.fromMonth, day: 1)!
    return InvoiceIssuedMonth(date: date)
  }
  
  public var allShortInvoices: [ShortInvoice] {
    get {
      return [firstSpecialPrize.shortInvoice,
              specialPrize.shortInvoice] + firstPrizes.map({ $0.shortInvoice }) + additionSixthPrizes
    }
  }
  
}

extension InvoiceAwards : CustomStringConvertible {
  
  public var description: String { return "FaPieowAward: {\n\tfirstSpecialPrize: \(firstSpecialPrize)\n\tspecialPrize: \(specialPrize)\n\tfirstPrizes: \(firstPrizes)\n\tadditionSixthPrizes: \(additionSixthPrizes)\n\tperiod: \(period)\n}" }
  
}

extension InvoiceAwards {
  
  public static func fromHTMLParser(parseWith data: Data) throws -> (thisMonth: InvoiceAwards, previousMonth: InvoiceAwards) {
    guard let html = HTML(html: data, encoding: String.Encoding.utf8) else { throw NetworkRequestError.invalidData }
    let monthElement = html.css("h2")
    guard monthElement.count > 4 else { throw NetworkRequestError.invalidData }
    let tables = html.css("table")
    // check if content if more then 2 count.
    guard tables.count >= 2 else { throw NetworkRequestError.invalidData }
    
    let thisMonthInfo = tables[0]
    let previousMonthInfo = tables[1]
    guard let thisMonthAward = parseHTMLTable(thisMonthInfo, period: monthElement[1]) else { throw NetworkRequestError.invalidData }
    guard let previousMonthAward = parseHTMLTable(previousMonthInfo, period: monthElement[3]) else { throw NetworkRequestError.invalidData }
    
    return (thisMonthAward, previousMonthAward)
  }
  
  public static func parseHTMLTable(_ table: XMLElement, period: XMLElement?) -> InvoiceAwards? {
    
    guard let firstSpecialPrizeString = filterPrize(of: "特別獎", inside: table) else { return nil }
    guard let specialPrizeString = filterPrize(of: "特獎", inside: table) else { return nil }
    guard let firstPrizesString = filterPrize(of: "頭獎", inside: table) else { return nil }
    guard let additionSixthPrizesString = filterPrize(of: "增開六獎", inside: table) else { return nil }
    guard let period = period?.text else { return nil }
    let splitedPeriodContent = period.characters.split(separator: "年").map(String.init)
    guard let year = splitedPeriodContent.first?.int else { return nil }
    guard let monthContent = splitedPeriodContent.last?.characters.split(separator: "月").map(String.init).first else { return nil }
    let months = monthContent.characters.split(separator: "-").map(String.init)
    guard let fromMonth = months[safe: 0]?.int else { return nil }
    guard let toMonth = months[safe: 1]?.int else { return nil }
   
    return InvoiceAwards(firstSpecialPrize: firstSpecialPrizeString,
                         specialPrize: specialPrizeString,
                         firstPrizes: firstPrizesString.characters.split(separator: "、").map(String.init),
                         additionSixthPrizes: additionSixthPrizesString.characters.split(separator: "、").map(String.init),
                         period: (year, fromMonth, toMonth))
  }
  
  public static func filterPrize(of prize: String, inside table: XMLElement) -> String? {
    return
      table.css("tr")
        .filter({ $0.text?.contains(prize) ?? false })
        .first?.css("span").first?.text
  }
  
}

extension InvoiceAwards : Equatable {
  
  static public func ==(lhs: InvoiceAwards, rhs: InvoiceAwards) -> Bool {
    return
      lhs.firstSpecialPrize == rhs.firstSpecialPrize &&
      lhs.specialPrize == rhs.specialPrize &&
      lhs.firstPrizes == rhs.firstPrizes &&
      lhs.period == rhs.period &&
      lhs.additionSixthPrizes == rhs.additionSixthPrizes
  }
  
}
