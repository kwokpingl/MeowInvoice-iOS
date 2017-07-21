//
//  ShortInvoiceValidationService.swift
//  MeowInvoice
//
//  Created by David on 2017/6/14.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation

public enum ShortInvoiceValidationResult {
  case seemsLikeWinningFirstSpecialPrize(awards: InvoiceAwards, suspectFirstSpecialPrize: Invoice)
  case seemsLikeWinningSpecialPrize(awards: InvoiceAwards, suspectSpecialPrize: Invoice)
  case seemsLikeWinningFirstPrize(awards: InvoiceAwards, suspectFirstPrize: Invoice)
  case seemsLikeWinningAdditionalPrize(awards: InvoiceAwards, additionalSixthPrize: ShortInvoice)
  case noPrize
  case error(message: String)
}

extension ShortInvoiceValidationResult : Equatable {
  
  static public func ==(lhs: ShortInvoiceValidationResult, rhs: ShortInvoiceValidationResult) -> Bool {
    switch (lhs, rhs) {
    case (.noPrize, .noPrize),
         (.seemsLikeWinningFirstPrize, .seemsLikeWinningFirstPrize),
         (.seemsLikeWinningAdditionalPrize, .seemsLikeWinningAdditionalPrize):
      return true
    default:
      return false
    }
  }
  
}

public protocol ShortInvoiceValidationService {
  func validate(_ invoice: ShortInvoice, with awards: InvoiceAwards) -> ShortInvoiceValidationResult
}

final public class DefaultShortInvoiceValidationService : ShortInvoiceValidationService {
  
  public func validate(_ invoice: ShortInvoice, with awards: InvoiceAwards) -> ShortInvoiceValidationResult {
    if awards.firstSpecialPrize.shortInvoice == invoice {
      return .seemsLikeWinningFirstSpecialPrize(awards: awards, suspectFirstSpecialPrize: awards.firstSpecialPrize)
    }
    
    if awards.specialPrize.shortInvoice == invoice {
      return .seemsLikeWinningSpecialPrize(awards: awards, suspectSpecialPrize: awards.specialPrize)
    }
    
    for firstPrize in awards.firstPrizes {
      if firstPrize.shortInvoice == invoice {
        return .seemsLikeWinningFirstPrize(awards: awards, suspectFirstPrize: firstPrize)
      }
    }
    
    for additionalSixthPrize in awards.additionSixthPrizes {
      if additionalSixthPrize == invoice {
        return .seemsLikeWinningAdditionalPrize(awards: awards, additionalSixthPrize: additionalSixthPrize)
      }
    }
    
    return .noPrize
  }
  
}
