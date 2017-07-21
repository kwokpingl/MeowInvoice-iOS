//
//  InvoiceValidationService.swift
//  MeowInvoice
//
//  Created by David on 2017/5/31.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation

public enum InvoiceValidationResult {
  case winning(prize: InvoicePrize)
  case noPrize
  case error(message: String)
}

extension InvoiceValidationResult {
  
  public func hasPrice() -> Bool {
    switch self {
    case .noPrize: return false
    default: return true
    }
  }
  
}

extension InvoiceValidationResult : Equatable {
  
  static public func ==(lhs: InvoiceValidationResult, rhs: InvoiceValidationResult) -> Bool {
    switch (lhs, rhs) {
    case let (.winning(prize: lPrize), .winning(prize: rPrize)):
      return lPrize == rPrize
    case (.noPrize, .noPrize):
      return true
    default:
      return false
    }
  }
  
}

public enum InvoicePrize {
  case firstSpecial
  case special
  case first
  case second
  case third
  case fourth
  case fifth
  case sixth, additionSixth
  
  var stringValue: String {
    switch self {
    case .firstSpecial: return "特別獎"
    case .special: return "特獎"
    case .first: return "頭獎"
    case .second: return "二獎"
    case .third: return "三獎"
    case .fourth: return "四獎"
    case .fifth: return "五獎"
    case .sixth: return "六獎"
    case .additionSixth: return "增開六獎"
    }
  }
  
  var prizeAmount: Int {
    switch self {
    case .firstSpecial: return 10000000
    case .special: return 2000000
    case .first: return 200000
    case .second: return 40000
    case .third: return 10000
    case .fourth: return 4000
    case .fifth: return 1000
    case .sixth, .additionSixth: return 200
    }
  }
  
}

extension InvoicePrize : Equatable {
  
  static public func ==(lhs: InvoicePrize, rhs: InvoicePrize) -> Bool {
    switch (lhs, rhs) {
    case (.firstSpecial, .firstSpecial): return true
    case (.special, .special): return true
    case (.first, .first): return true
    case (.second, .second): return true
    case (.third, .third): return true
    case (.fourth, .fourth): return true
    case (.fifth, .fifth): return true
    case (.sixth, .sixth): return true
    case (.additionSixth, .additionSixth): return true
    default: return false
    }
  }
  
}

public protocol InvoiceValidationService {
  func validate(invoice: Invoice, with award: InvoiceAwards) -> InvoiceValidationResult
  func validateInvoiceWithoutSpecialPrizes(invoice: Invoice, with award: InvoiceAwards) -> InvoiceValidationResult
}

public struct DefaultInvoiceValidationService : InvoiceValidationService {
  
  public func validate(invoice: Invoice, with award: InvoiceAwards) -> InvoiceValidationResult {
    if award.firstSpecialPrize == invoice {
      return InvoiceValidationResult.winning(prize: InvoicePrize.firstSpecial)
    } else if award.specialPrize == invoice {
      return InvoiceValidationResult.winning(prize: InvoicePrize.special)
    } else {
      return validateInvoiceWithoutSpecialPrizes(invoice: invoice, with: award)
    }
  }
  
  public func validateInvoiceWithoutSpecialPrizes(invoice: Invoice, with award: InvoiceAwards) -> InvoiceValidationResult {
    var result = InvoiceValidationResult.noPrize
    
    // check first prizes
    for firstPrize in award.firstPrizes {
      result = invoice.comparing(to: firstPrize)
      if result.hasPrice() {
        return result
      }
    }
    
    // check addition sixth prizes
    let shortInvoice = invoice.shortInvoice
    for additionSixthPrize in award.additionSixthPrizes {
      if shortInvoice == additionSixthPrize {
        return InvoiceValidationResult.winning(prize: InvoicePrize.additionSixth)
      }
    }
    
    return result
  }
  
}
