//
//  KeyboardCheckerDefaultInteractorSpec.swift
//  MeowInvoice
//
//  Created by David on 2017/6/20.
//  Copyright © 2017年 david. All rights reserved.
//

import Quick
import Nimble
@testable import MeowInvoice

class KeyboardCheckerDefaultInteractorSpec: QuickSpec {
  
  var interactor: KeyboardCheckerInteractor!
  var validator: ShortInvoiceValidationService!
  var store: InvoiceAwardsStoreService!
  
  override func spec() {
    
    beforeEach {
      self.validator = ShortInvoiceValidationMockSuccess()
      self.store = InvoiceAwardsStoreMock()
      self.interactor =
        KeyboardCheckerDefaultInteractor(validator: self.validator,
                                         invoiceAwardsStore: self.store)
    }
    
    it("should get the same thing from interactor getter and store getter.") {
      expect(self.interactor.invoiceAwards.previous).to(equal(self.store.previousMonth))
      expect(self.interactor.invoiceAwards.this).to(equal(self.store.thisMonth))
    }
    
    it("should change month") {
      let month = WhichMonth.previous
      self.interactor.set(changed: month)
      expect(self.interactor.checkingOptionMonth).to(equal(month))
    }
    
    it("should validate this month and success") {
      let successValidator = ShortInvoiceValidationMockSuccess()
      self.validator = successValidator
      self.interactor =
        KeyboardCheckerDefaultInteractor(validator: self.validator,
                                         invoiceAwardsStore: self.store)
      self.interactor.set(changed: .this)
      let result = self.interactor.validate("123")
      expect(successValidator.validateCalled).to(beTrue())
      expect(self.interactor.checkingOptionMonth).to(equal(WhichMonth.this))
      switch result {
      case .seemsLikeWinningFirstSpecialPrize: succeed()
      default: fail()
      }
    }
    
    it("should validate previous month and success") {
      let successValidator = ShortInvoiceValidationMockSuccess()
      self.validator = successValidator
      self.interactor =
        KeyboardCheckerDefaultInteractor(validator: self.validator,
                                         invoiceAwardsStore: self.store)
      self.interactor.set(changed: .previous)
      let result = self.interactor.validate("123")
      expect(successValidator.validateCalled).to(beTrue())
      expect(self.interactor.checkingOptionMonth).to(equal(WhichMonth.previous))
      switch result {
      case .seemsLikeWinningFirstSpecialPrize: succeed()
      default: fail()
      }
    }
    
    it("should validate both month and success") {
      let successValidator = ShortInvoiceValidationMockSuccess()
      self.validator = successValidator
      self.interactor =
        KeyboardCheckerDefaultInteractor(validator: self.validator,
                                         invoiceAwardsStore: self.store)
      self.interactor.set(changed: .both)
      let result = self.interactor.validate("123")
      expect(successValidator.validateCalled).to(beTrue())
      expect(self.interactor.checkingOptionMonth).to(equal(WhichMonth.both))
      switch result {
      case .seemsLikeWinningFirstSpecialPrize: succeed()
      default: fail()
      }
    }
    
    it("should validate both month and fail") {
      let failureValidator = ShortInvoiceValidationMockFailure()
      self.validator = failureValidator
      self.interactor =
        KeyboardCheckerDefaultInteractor(validator: self.validator,
                                         invoiceAwardsStore: self.store)
      self.interactor.set(changed: .both)
      let result = self.interactor.validate("123")
      expect(failureValidator.validateCalled).to(beTrue())
      expect(self.interactor.checkingOptionMonth).to(equal(WhichMonth.both))
      switch result {
      case .noPrize: succeed()
      default: fail()
      }
    }
    
  }
  
}

class ShortInvoiceValidationMockFailure : ShortInvoiceValidationService {
  
  var validateCalled = false
  
  func validate(_ invoice: ShortInvoice, with awards: InvoiceAwards) -> ShortInvoiceValidationResult {
    validateCalled = true
    return .noPrize
  }
  
}

class ShortInvoiceValidationMockSuccess : ShortInvoiceValidationService {
  
  var validateCalled = false
  
  func validate(_ invoice: ShortInvoice, with awards: InvoiceAwards) -> ShortInvoiceValidationResult {
    validateCalled = true
    let awards = InvoiceAwards(firstSpecialPrize: "12345678",
                               specialPrize: "12345678",
                               firstPrizes: ["12345678","12345678","12345678"],
                               additionSixthPrizes: ["996"],
                               period: (106,3,4))!
    return .seemsLikeWinningFirstSpecialPrize(awards: awards, suspectFirstSpecialPrize: awards.firstSpecialPrize)
  }
  
}

class InvoiceAwardsStoreMock : InvoiceAwardsStoreService {
  
  var previousMonth: InvoiceAwards? {
    return
      InvoiceAwards(firstSpecialPrize: "12345678",
                    specialPrize: "12345678",
                    firstPrizes: ["12345678","12345678","12345678"],
                    additionSixthPrizes: ["996"],
                    period: (106,3,4))!
  }
  
  var thisMonth: InvoiceAwards? {
    return
      InvoiceAwards(firstSpecialPrize: "12345678",
                    specialPrize: "12345678",
                    firstPrizes: ["12345678","12345678","12345678"],
                    additionSixthPrizes: ["996"],
                    period: (106,3,4))!
  }
  
  var updateCalled = false
  
  func updateInvoiceAwards(with newInvoiceAwards: (this: InvoiceAwards, previous: InvoiceAwards)) {
    updateCalled = true
  }
  
}
