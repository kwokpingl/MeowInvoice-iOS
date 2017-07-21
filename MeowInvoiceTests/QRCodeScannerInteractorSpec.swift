//
//  QRCodeScannerInteractorSpec.swift
//  MeowInvoice
//
//  Created by David on 2017/6/2.
//  Copyright © 2017年 david. All rights reserved.
//

import Quick
import Nimble
@testable import MeowInvoice

class QRCodeScannerInteractorSpec: QuickSpec {
  
  var invoiceSuccessValidator: InvoiceValidationServiceSuccessMock!
  var invoiceFailureValidator: InvoiceValidationServiceFailureMock!
  let awardsStore = MockInvoiceAwardsStoreService()
  var interactor: InvoiceQRCodeScannerInteractor!
  
  override func spec() {
    
    beforeEach {
      self.invoiceSuccessValidator = InvoiceValidationServiceSuccessMock()
      self.invoiceFailureValidator = InvoiceValidationServiceFailureMock()
    }
    
    context("Testing qrcode input count") { 
      it("should return onlyOnQRCode") {
        let decoder = QRCodeDecoderServiceFailureMock()
        self.interactor =
          InvoiceQRCodeScannerDefaultInteractor(qrCodeDecoder: decoder,
                                                validator: self.invoiceFailureValidator,
                                                awardsStore: self.awardsStore)
        let result = self.interactor.validate(qrCodes: [""])
        expect(decoder.decodeCalled).to(equal(true))
        expect(self.invoiceFailureValidator.validateCalled).to(equal(false))
        switch result {
        case .onlyOneQRCode: succeed()
        default: fail()
        }
      }
      
      it("should return no qrcode") {
        let decoder = QRCodeDecoderServiceFailureMock()
        self.interactor =
          InvoiceQRCodeScannerDefaultInteractor(qrCodeDecoder: decoder,
                                                validator: self.invoiceFailureValidator,
                                                awardsStore: self.awardsStore)
        let result = self.interactor.validate(qrCodes: [])
        expect(decoder.decodeCalled).to(equal(true))
        expect(self.invoiceFailureValidator.validateCalled).to(equal(false))
        switch result {
        case .noQRCode: succeed()
        default: fail()
        }
      }
      
      it("should get a prize") {
        let decoder = QRCodeDecoderServiceMockIsOpenLotteryAndIsRedeemable()
        self.interactor =
          InvoiceQRCodeScannerDefaultInteractor(qrCodeDecoder: decoder,
                                                validator: self.invoiceSuccessValidator,
                                                awardsStore: self.awardsStore)
        let result = self.interactor.validate(qrCodes: [])
        expect(decoder.decodeCalled).to(equal(true))
        expect(self.invoiceSuccessValidator.validateCalled).to(equal(true))
        switch result {
        case .winning: succeed()
        default: fail()
        }
      }
      
    }
    
    context("Mock qrcode decoder with returned mock invoice.") {
      
      it("invoice should be open lottery and redeemable, should also win a prize") {
        let decoder = QRCodeDecoderServiceMockIsOpenLotteryAndIsRedeemable()
        self.interactor =
          InvoiceQRCodeScannerDefaultInteractor(qrCodeDecoder: decoder,
                                                validator: self.invoiceSuccessValidator,
                                                awardsStore: self.awardsStore)
        let result = self.interactor.validate(qrCodes: ["", ""])
        expect(decoder.decodeCalled).to(equal(true))
        let qrCodeInvoice = decoder.decode(qrCodes: [])
        expect(qrCodeInvoice?.isLotteryOpened).to(equal(true))
        expect(qrCodeInvoice?.isRedeemExpired).to(equal(false))
        expect(qrCodeInvoice?.ableToRedeem).to(equal(true))
        expect(self.invoiceSuccessValidator.validateCalled).to(equal(true))
        switch result {
        case .winning: succeed()
        default: fail()
        }
      }
        
      it("should decode and expired") {
        let decoder = QRCodeDecoderServiceMockExpried()
        self.interactor =
          InvoiceQRCodeScannerDefaultInteractor(qrCodeDecoder: decoder,
                                                validator: self.invoiceSuccessValidator,
                                                awardsStore: self.awardsStore)
        let result = self.interactor.validate(qrCodes: [])
        expect(decoder.decodeCalled).to(equal(true))
        let qrCodeInvoice = decoder.decode(qrCodes: [])
        expect(qrCodeInvoice?.isLotteryOpened).to(equal(true))
        expect(qrCodeInvoice?.isRedeemExpired).to(equal(true))
        expect(qrCodeInvoice?.ableToRedeem).to(equal(false))
        expect(self.invoiceSuccessValidator.validateCalled).to(equal(false))
        switch result {
        case .expired: succeed()
        default: fail()
        }
      }
      
      it("should fail to recognize qrcodes") {
        let decoder = QRCodeDecoderServiceMockUnrecognize()
        self.interactor =
          InvoiceQRCodeScannerDefaultInteractor(qrCodeDecoder: decoder,
                                                validator: self.invoiceSuccessValidator,
                                                awardsStore: self.awardsStore)
        let result = self.interactor.validate(qrCodes: ["", "**"])
        expect(decoder.decodeCalled).to(equal(true))
        let qrCodeInvoice = decoder.decode(qrCodes: [])
        expect(qrCodeInvoice).to(beNil())
        expect(self.invoiceSuccessValidator.validateCalled).to(equal(false))
        switch result {
        case .unableToRecognize: succeed()
        default: fail()
        }
      }
      
      it("invoice should be NOT opened and NOT redeemable, should NOT win a prize") {
        let decoder = QRCodeDecoderServiceMockIsNotOpenLotteryAndIsNotRedeemable()
        self.interactor =
          InvoiceQRCodeScannerDefaultInteractor(qrCodeDecoder: decoder,
                                                validator: self.invoiceSuccessValidator,
                                                awardsStore: self.awardsStore)
        let result = self.interactor.validate(qrCodes: ["", ""])
        expect(decoder.decodeCalled).to(equal(true))
        let qrCodeInvoice = decoder.decode(qrCodes: [])
        expect(qrCodeInvoice?.isLotteryOpened).to(equal(false))
        expect(qrCodeInvoice?.ableToRedeem).to(equal(false))
        expect(qrCodeInvoice?.isRedeemExpired).to(equal(false))
        // validator should not be called.
        expect(self.invoiceSuccessValidator.validateCalled).to(equal(false))
        switch result {
        case .lotteryNotYetOpened: succeed()
        default: fail()
        }
      }
    }
    
  }
  
}

class QRCodeDecoderServiceMockIsOpenLotteryAndIsRedeemable : QRCodeDecoderService {
  
  var decodeCalled: Bool = false
  
  func decode(qrCodes: [String]) -> QRCodeInvoice? {
    decodeCalled = true
    let date = Date().dateBySubtractingDay(60)!
    let year = date.yearOfRepublicEra
    let month = date.month
    let day = date.day
    let monthString = { () -> String in
      if month < 10 {
        return "0\(month)"
      } else {
        return month.string
      }
    }()
    let dayString = { () -> String in
      if day < 10 {
        return "0\(day)"
      } else {
        return day.string
      }
    }()
    return QRCodeInvoice(qrCodes: ["**","TZ62958842\(year)\(monthString)\(dayString)91040000004B0000004B00000000423274581ddZFPeX1laqgQNOdA5c9Q==:**********:2:2:1:菠蘿:1:35:日式紅豆:1:40"])
  }
  
}

class QRCodeDecoderServiceMockIsOpenLotteryAndIsNotRedeemable : QRCodeDecoderService {
  
  var decodeCalled: Bool = false
  
  func decode(qrCodes: [String]) -> QRCodeInvoice? {
    decodeCalled = true
    let now = Date()
    let year = now.year - 1911
    let month = now.month % 2 == 0 ? now.month + 1 : now.month
    let day = now.day
    let openDate = Date.create(dateOnYear: year + 1911, month: month + 1, day: 25, hour: 1, minute: 10, second: 10)!
    let monthString = { () -> String in
      if openDate.month < 10 {
        return "0\(openDate.month)"
      } else {
        return openDate.month.string
      }
    }()
    let dayString = { () -> String in
      if openDate.day < 10 {
        return "0\(openDate.day)"
      } else {
        return openDate.day.string
      }
    }()
    return QRCodeInvoice(qrCodes: ["**","TZ62958842\(openDate.yearOfRepublicEra)\(monthString)\(dayString)91040000004B0000004B00000000423274581ddZFPeX1laqgQNOdA5c9Q==:**********:2:2:1:菠蘿:1:35:日式紅豆:1:40"])
  }
  
}

class QRCodeDecoderServiceMockIsNotOpenLotteryAndIsNotRedeemable : QRCodeDecoderService {
  
  var decodeCalled: Bool = false
  
  func decode(qrCodes: [String]) -> QRCodeInvoice? {
    decodeCalled = true
    let date = Date().dateByAddingDay(75)!
    let year = date.yearOfRepublicEra
    let month = date.month
    let day = date.day
    let monthString = { () -> String in
      if month < 10 {
        return "0\(month)"
      } else {
        return month.string
      }
    }()
    let dayString = { () -> String in
      if day < 10 {
        return "0\(day)"
      } else {
        return day.string
      }
    }()
    return QRCodeInvoice(qrCodes: ["**","TZ62958842\(year)\(monthString)\(dayString)91040000004B0000004B00000000423274581ddZFPeX1laqgQNOdA5c9Q==:**********:2:2:1:菠蘿:1:35:日式紅豆:1:40"])
  }
  
}

class QRCodeDecoderServiceMockExpried : QRCodeDecoderService {
  
  var decodeCalled: Bool = false
  
  func decode(qrCodes: [String]) -> QRCodeInvoice? {
    decodeCalled = true
    return QRCodeInvoice(qrCodes: ["**","TZ62958842\(105)\(11)\(11)91040000004B0000004B00000000423274581ddZFPeX1laqgQNOdA5c9Q==:**********:2:2:1:菠蘿:1:35:日式紅豆:1:40"])
  }
  
}
  
class QRCodeDecoderServiceMockUnrecognize : QRCodeDecoderService {
  
  var decodeCalled: Bool = false
  
  func decode(qrCodes: [String]) -> QRCodeInvoice? {
    decodeCalled = true
    return QRCodeInvoice(qrCodes: ["**",""])
  }
  
}
  
class QRCodeDecoderServiceFailureMock : QRCodeDecoderService {
  
  var decodeCalled: Bool = false
  
  func decode(qrCodes: [String]) -> QRCodeInvoice? {
    decodeCalled = true
    return QRCodeInvoice(qrCodes: ["**"])
  }
  
}
  
class InvoiceValidationServiceSuccessMock : QRCodeInvoiceValidationService {
  
  var validateCalled: Bool = false
  
  func isQRCodeAbleToRedeem(code: QRCodeInvoice, on date: Date) -> Bool {
    return true
  }
  
  func validate(qrCode: QRCodeInvoice, with awards: InvoiceAwards) -> InvoiceValidationResult {
    validateCalled = true
    return InvoiceValidationResult.winning(prize: .firstSpecial)
  }
  
}

class InvoiceValidationServiceFailureMock : QRCodeInvoiceValidationService {
  
  var validateCalled: Bool = false
  
  func isQRCodeAbleToRedeem(code: QRCodeInvoice, on date: Date) -> Bool {
    return false
  }
  
  func validate(qrCode: QRCodeInvoice, with awards: InvoiceAwards) -> InvoiceValidationResult {
    validateCalled = true
    return InvoiceValidationResult.winning(prize: .firstSpecial)
  }
  
}
