//
//  QRCodeInvoiceValidatorService.swift
//  MeowInvoice
//
//  Created by David on 2017/6/6.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation

/// QRCodeInvoiceValidationResult
///
/// - winning:          winning some prize.
/// - noPrize:          no prize
/// - redeemDataError:  redeem awards data unable to be used to redeem given invoice
public enum QRCodeInvoiceValidationResult {
  case winning(prize: InvoicePrize)
  case noPrize
  case redeemDataError
}

extension QRCodeInvoiceValidationResult : Equatable {
  
  public static func ==(lhs: QRCodeInvoiceValidationResult, rhs: QRCodeInvoiceValidationResult) -> Bool {
    switch (lhs, rhs) {
    case (.winning(prize: let lPrize), .winning(prize: let rPrize)):
      return lPrize == rPrize
    case (.noPrize, .noPrize):
      return true
    case (.redeemDataError, .redeemDataError):
      return true
    default:
      return false
    }
  }
  
}

public protocol QRCodeInvoiceValidationService {
  func isQRCodeAbleToRedeem(code: QRCodeInvoice, on date: Date) -> Bool
  func validate(qrCode: QRCodeInvoice, with awards: InvoiceAwards) -> QRCodeInvoiceValidationResult
}

public struct DefaultQRCodeInvoiceValidationService : QRCodeInvoiceValidationService {
  
  private let validator: InvoiceValidationService
  
  public init(validator: InvoiceValidationService) {
    self.validator = validator
  }

  public func isQRCodeAbleToRedeem(code: QRCodeInvoice, on date: Date) -> Bool {
    return code.ableToRedeem(on: date)
  }
  
  public func validate(qrCode: QRCodeInvoice, with awards: InvoiceAwards) -> QRCodeInvoiceValidationResult {
    guard qrCode.ableToRedeem(by: awards) else { return .redeemDataError }
    // may return no prize, winning prize.
    let result = validator.validate(invoice: qrCode.invoice, with: awards)
    switch result {
    case let .winning(prize: prize): return .winning(prize: prize)
    default: return .noPrize
    }
  }
  
}
