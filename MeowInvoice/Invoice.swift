//
//  Invoice.swift
//  MeowInvoice
//
//  Created by David on 2017/5/31.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation

public struct Invoice {
  public let number: String
  
  public init?(number: String) {
    guard number.characters.count == 8, number.isNumeric else { return nil }
    self.number = number
  }
  
  public init?(number: Int) {
    guard number > 0 else { return nil }
    var numberString = String(number)
    
    while numberString.characters.count < 8 {
      numberString = "0" + numberString
    }
    
    guard numberString.characters.count == 8, numberString.isNumeric else { return nil }
    self.number = numberString
  }
  
  public var shortInvoice: ShortInvoice {
    get {
      return ShortInvoice(number: number.last(3))!
    }
  }
  
}

extension Invoice : Equatable {
  
  static public func ==(lhs: Invoice, rhs: Invoice) -> Bool {
    return lhs.number == rhs.number
  }
  
}

extension Invoice {
  
  public func comparing(to invoice: Invoice) -> InvoiceValidationResult {
    if self == invoice {
      return InvoiceValidationResult.winning(prize: InvoicePrize.first)
    } else if number.last(7) == invoice.number.last(7) {
      return InvoiceValidationResult.winning(prize: InvoicePrize.second)
    } else if number.last(6) == invoice.number.last(6) {
      return InvoiceValidationResult.winning(prize: InvoicePrize.third)
    } else if number.last(5) == invoice.number.last(5) {
      return InvoiceValidationResult.winning(prize: InvoicePrize.fourth)
    } else if number.last(4) == invoice.number.last(4) {
      return InvoiceValidationResult.winning(prize: InvoicePrize.fifth)
    } else if number.last(3) == invoice.number.last(3) {
      return InvoiceValidationResult.winning(prize: InvoicePrize.sixth)
    } else {
      return InvoiceValidationResult.noPrize
    }
  }
  
}

extension Invoice : CustomStringConvertible {

  public var description: String { return "Invoice(\(number))" }
  
}
