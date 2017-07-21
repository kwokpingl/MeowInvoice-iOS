//
//  QRCodeInvoice.swift
//  MeowInvoice
//
//  Created by David on 2017/6/1.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation

public enum InvoiceIssuedMonth {
  case januaryFeb(year: Int)
  case marchApril(year: Int)
  case mayJune(year: Int)
  case julyAugest(year: Int)
  case septemberOctober(year: Int)
  case novemberDecember(year: Int)
  
  init(date: Date) {
    if date.month >= 11 {
      // 11, 12 月
      self = InvoiceIssuedMonth.novemberDecember(year: date.year)
    } else if date.month >= 9 {
      self = InvoiceIssuedMonth.septemberOctober(year: date.year)
    } else if date.month >= 7 {
      self = InvoiceIssuedMonth.julyAugest(year: date.year)
    } else if date.month >= 5 {
      self = InvoiceIssuedMonth.mayJune(year: date.year)
    } else if date.month >= 3 {
      self = InvoiceIssuedMonth.marchApril(year: date.year)
    } else {
      self = InvoiceIssuedMonth.januaryFeb(year: date.year)
    }
  }
  
  var redeemAvailableDate: (from: Date, to: Date) {
    switch self {
    case let .januaryFeb(year: year):
      return (from: Date.create(dateOnYear: year, month: 4, day: 6)!,
              to: Date.create(dateOnYear: year, month: 7, day: 5)!)
    case let .marchApril(year: year):
      return (from: Date.create(dateOnYear: year, month: 6, day: 6)!,
              to: Date.create(dateOnYear: year, month: 9, day: 5)!)
    case let .mayJune(year: year):
      return (from: Date.create(dateOnYear: year, month: 8, day: 6)!,
              to: Date.create(dateOnYear: year, month: 11, day: 5)!)
    case let .julyAugest(year: year):
      return (from: Date.create(dateOnYear: year, month: 10, day: 6)!,
              to: Date.create(dateOnYear: year + 1, month: 1, day: 5)!)
    case let .septemberOctober(year: year):
      return (from: Date.create(dateOnYear: year, month: 12, day: 6)!,
              to: Date.create(dateOnYear: year + 1, month: 3, day: 5)!)
    case let .novemberDecember(year: year):
      return (from: Date.create(dateOnYear: year + 1, month: 2, day: 6)!,
              to: Date.create(dateOnYear: year + 1, month: 5, day: 5)!)
    }
  }
  
  var openLotteryDate: Date {
    switch self {
    case let .januaryFeb(year: year): return Date.create(dateOnYear: year, month: 3, day: 25)!
    case let .marchApril(year: year): return Date.create(dateOnYear: year, month: 5, day: 25)!
    case let .mayJune(year: year): return Date.create(dateOnYear: year, month: 7, day: 25)!
    case let .julyAugest(year: year): return Date.create(dateOnYear: year, month: 9, day: 25)!
    case let .septemberOctober(year: year): return Date.create(dateOnYear: year, month: 11, day: 25)!
    case let .novemberDecember(year: year): return Date.create(dateOnYear: year + 1, month: 1, day: 25)!
    }
  }
}

public enum QRCodeInvoiceEncoding {
  case big5
  case utf8
  case base64
  
  init?(value: String?) {
    switch value {
    case .some("0"): self = QRCodeInvoiceEncoding.big5
    case .some("1"): self = QRCodeInvoiceEncoding.utf8
    case .some("2"): self = QRCodeInvoiceEncoding.base64
    default: return nil
    }
  }
}

public struct QRCodeInvoice {
  
  public let fullInvoice: String
  public let invoice: Invoice
  public let issuedDate: Date
  public let randomCode: String
  public let salesAmount: String
  public let totalAmount: String
  public let buyerTaxIDNumber: String
  public let sellerTaxIDNumber: String
  public let encryptionValiatingInfo: String
  public let sellerPersonalInfo: String?
  public let productSum: String?
  public let tradeCount: String?
  public let encoding: QRCodeInvoiceEncoding
  public let detailProductList: [(name: String, quantity: String, price: String)]
  
  public var issuedMonth: InvoiceIssuedMonth {
    return InvoiceIssuedMonth(date: issuedDate)
  }
  
  /// Key to check if this invoice is able to redeem today
  public var ableToRedeem: Bool {
    return ableToRedeem(on: Date())
  }
  
  /// Check if this invoice is able to redeem.
  /// Should not use it to check if invoice is open lottery.
  public func ableToRedeem(on date: Date) -> Bool {
    return date.isBetween(date: redeemAvailableTime.from, and: redeemAvailableTime.to)
  }
  
  public var redeemAvailableTime: (from: Date, to: Date) {
    return issuedMonth.redeemAvailableDate
  }
  
  public var openLotteryDate: Date {
    return issuedMonth.openLotteryDate
  }
  
  /// To check if today is this qrcode invoice's open lottery date.
  public var isLotteryOpened: Bool {
    return isLotteryOpened(on: Date())
  }
  
  /// To check if given date is this qrcode invoice's open lottery date.
  public func isLotteryOpened(on date: Date) -> Bool {
    let openLotteryDate = issuedMonth.openLotteryDate
    return date.isAfterOrSame(with: openLotteryDate)
  }
  
  /// To check if this invoice is expired.
  public var isRedeemExpired: Bool {
    return isRedeemExpired(on: Date())
  }
  
  /// To check if this invoice is expired by given date.
  public func isRedeemExpired(on date: Date) -> Bool {
    return date.isAfter(issuedMonth.redeemAvailableDate.to)
  }
  
  // To check if able to redeem by invoice awards
  public func ableToRedeem(by invoiceAwards: InvoiceAwards) -> Bool {
    guard
      let start = Date.create(dateOnYear: invoiceAwards.period.year + 1911,
                              month: invoiceAwards.period.fromMonth,
                              day: 1),
      let end = Date.create(dateOnYear: invoiceAwards.period.year + 1911,
                            month: invoiceAwards.period.toMonth,
                            day: 1)?.dateByAddingMonth(1)?.dateBySubtractingDay(1)
      else { return false }
    return issuedDate.isBetween(date: start, and: end)
  }
  
  public init?(qrCodes: [String]) {
    guard qrCodes.count == 2 else { return nil }
    let leftQRCode = qrCodes[0].hasPrefix("**") ? qrCodes[1] : qrCodes[0]
    let rightQRCode = qrCodes[0].hasPrefix("**") ? qrCodes[0] : qrCodes[1]
    var qrCode = (leftQRCode.hasPrefix("bom") ? leftQRCode.trimFirst(3) : leftQRCode) + rightQRCode.trimFirst(2)
    print(qrCode)
    var invoiceInformation = qrCode.characters.split(separator: ":").map(String.init)
    // This is main part of invoice.
    guard let mainInformation = invoiceInformation.popFirst() else { return nil }
    // main information length must equal to 77
    guard mainInformation.characters.count == 77 else { return nil }
    
    self.fullInvoice = mainInformation.string(from: 0, to: 9)
    guard let invoice = Invoice(number: self.fullInvoice.last(8)) else { return nil }
    self.invoice = invoice
    
    guard let year = Int(mainInformation.string(from: 10, to: 12)),
          let month = Int(mainInformation.string(from: 13, to: 14)),
          let day = Int(mainInformation.string(from: 15, to: 16)),
          let issuedDate = Date.create(dateOnYear: year + 1911, month: month, day: day) else { return nil }
    self.issuedDate = issuedDate
    self.randomCode = mainInformation.string(from: 17, to: 20)
    self.salesAmount = mainInformation.string(from: 21, to: 28)
    self.totalAmount = mainInformation.string(from: 29, to: 36)
    self.buyerTaxIDNumber = mainInformation.string(from: 37, to: 44)
    self.sellerTaxIDNumber = mainInformation.string(from: 45, to: 52)
    self.encryptionValiatingInfo = mainInformation.string(from: 53, to: 76)
    
    self.sellerPersonalInfo = invoiceInformation.popFirst()
    self.productSum = invoiceInformation.popFirst()
    self.tradeCount = invoiceInformation.popFirst()
    guard let encoding = QRCodeInvoiceEncoding.init(value: invoiceInformation.popFirst()) else { return nil }
    self.encoding = encoding
    
    // create detail product list from other part information.
    var detailProductList: [(name: String, quantity: String, price: String)] = []
    while invoiceInformation.count > 0 {
      guard let name = invoiceInformation.popFirst(),
            let quantity = invoiceInformation.popFirst(),
            let price = invoiceInformation.popFirst() else { continue }
      detailProductList.append((name, quantity, price))
    }
    self.detailProductList = detailProductList
  }
}

extension QRCodeInvoice : CustomStringConvertible {
  
  public var description: String {
    return "QRCodeInvoice:{\n\tfullInvoice: \(fullInvoice)\n\tissuedDate: \(issuedDate)\n\trandomCode: \(randomCode)\n\tsalesAmount: \(salesAmount)\n\ttotalAmount: \(totalAmount)\n\tbuyerTaxIDNumber: \(buyerTaxIDNumber)\n\tsellerTaxIDNumber: \(sellerTaxIDNumber)\n\tencryptionValiatingInfo: \(encryptionValiatingInfo)\n\tsellerPersonalInfo: \(sellerPersonalInfo)\n\tproductSum: \(productSum)\n\ttradeCount: \(tradeCount)\n\tencoding: \(encoding)\n\tdetailProductList: \(detailProductList)\n}"
  }
  
}
