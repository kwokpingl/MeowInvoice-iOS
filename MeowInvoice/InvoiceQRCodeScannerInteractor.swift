//
//  InvoiceQRCodeScannerInteractor.swift
//  MeowInvoice
//
//  Created by David on 2017/6/1.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation

public enum InvoiceQRCodeScanResult {
  case noQRCode
  case onlyOneQRCode
  case unableToRecognize
  case winning(prize: InvoicePrize, invoice: QRCodeInvoice)
  case noPrize(invoice: QRCodeInvoice)
  case lotteryNotYetOpened(invoice: QRCodeInvoice)
  case expired(invoice: QRCodeInvoice)
  case error(message: String)
  case inputRepeat
  case redeemDataError(invoice: QRCodeInvoice, thisAwards: InvoiceAwards, previousAwards: InvoiceAwards)
}

public protocol InvoiceQRCodeScannerInteractor {
  func validate(qrCodes: [String]) -> InvoiceQRCodeScanResult
}

final public class InvoiceQRCodeScannerDefaultInteractor : InvoiceQRCodeScannerInteractor {
  
  private let qrCodeDecoder: QRCodeDecoderService
  private let validator: QRCodeInvoiceValidationService
  private let awardsStore: InvoiceAwardsStoreService
  private var previousQRCodes: [String] = []
  
  required public init(qrCodeDecoder: QRCodeDecoderService, validator: QRCodeInvoiceValidationService, awardsStore: InvoiceAwardsStoreService) {
    self.qrCodeDecoder = qrCodeDecoder
    self.validator = validator
    self.awardsStore = awardsStore
  }
  
  public func validate(qrCodes: [String]) -> InvoiceQRCodeScanResult {
    // check if repeat
    guard previousQRCodes != qrCodes else { return .inputRepeat }
    // check if qrcode count is less than 2, if yes, return
    guard qrCodes.count > 0 else { return .noQRCode }
    guard qrCodes.count > 1 else { return .onlyOneQRCode }
    // record previous qr code if needed
    previousQRCodes = qrCodes
    // check has awards data
    guard let thisMonth = awardsStore.thisMonth,
          let previousMonth = awardsStore.previousMonth else { return .error(message: "沒有最新發票資料") }
    // decode invoice 
    guard let qrCodeInvoice = qrCodeDecoder.decode(qrCodes: qrCodes) else { return .unableToRecognize }
    // if invoice lottery is not opened yet, return
    guard qrCodeInvoice.isLotteryOpened else { return .lotteryNotYetOpened(invoice: qrCodeInvoice) }
    // if opened, check if is expired.
    guard !qrCodeInvoice.isRedeemExpired else { return .expired(invoice: qrCodeInvoice) }
    // if not expired, validate invoice
    let thisResult = validator.validate(qrCode: qrCodeInvoice, with: thisMonth)
    let previousResult = validator.validate(qrCode: qrCodeInvoice, with: previousMonth)
    if case .winning(prize: let prize) = thisResult {
      return .winning(prize: prize, invoice: qrCodeInvoice)
    } else if case .winning(prize: let prize) = previousResult {
      return .winning(prize: prize, invoice: qrCodeInvoice)
    } else {
      if thisResult == .redeemDataError && previousResult == .redeemDataError {
        return .redeemDataError(invoice: qrCodeInvoice, thisAwards: thisMonth, previousAwards: previousMonth)
      } else {
        return .noPrize(invoice: qrCodeInvoice)
      }
    }
  }
  
}
