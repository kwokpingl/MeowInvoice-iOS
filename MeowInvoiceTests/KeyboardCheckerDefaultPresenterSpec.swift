//
//  KeyboardCheckerDefaultPresenterSpec.swift
//  MeowInvoice
//
//  Created by David on 2017/6/20.
//  Copyright © 2017年 david. All rights reserved.
//

import Quick
import Nimble
@testable import MeowInvoice

class KeyboardCheckerDefaultPresenterSpec: QuickSpec {
  
  var presenter: KeyboardCheckerDefaultPresenter!
  var viewMock: KeyboardCheckerViewMock!
  var routerMock: KeyboardCheckerRouterMock!
  var interactorMock: KeyboardCheckerInteractorMock!
  
  override func spec() {
    beforeEach {
      self.viewMock = KeyboardCheckerViewMock()
      self.routerMock = KeyboardCheckerRouterMock()
      self.interactorMock = KeyboardCheckerInteractorMock()
      self.presenter = KeyboardCheckerDefaultPresenter(view: self.viewMock,
                                                       router: self.routerMock,
                                                       interactor: self.interactorMock)
    }
    
    context("Test presenter") { 
      it("should present month selector content update after pseenter load contents") {
        self.presenter.loadContents()
        expect(self.viewMock.presentMonthSelectorContentFlag).to(beTrue())
      }
      
      it("should present validation result after presenter present result.") {
        self.presenter.presentResultOf(lastThree: "123")
        expect(self.viewMock.presentValidationResultFlag).to(beTrue())
      }
      
      it("should change validation month to this month and view should change month option") {
        self.presenter.changeCheckingOption(bySelecting: .this)
        expect(self.viewMock.presentChangedCheckingOptionFlag).to(beTrue())
      }
      
      it("should reload view after interactor getting a update notification") {
        // delegate must be connected
        expect(self.interactorMock.delegate).toNot(beNil())
        self.interactorMock.notifyInvoiceAwardsUpdated()
        expect(self.interactorMock.notifyInvoiceAwardsUpdatedFlag).to(beTrue())
        expect(self.viewMock.reloadContentsFlag).to(beTrue())
      }
    }
    
  }
  
}

class KeyboardCheckerViewMock : KeyboardCheckerView {
  
  var presentChangedCheckingOptionFlag = false
  var presentValidationResultFlag = false
  var presentMonthSelectorContentFlag = false
  var reloadContentsFlag = false
  
  func presentChangedCheckingOption(_ option: String) {
    presentChangedCheckingOptionFlag = true
  }
  
  func presentValidationResult(_ viewModel: ShortInvoiceValidationViewModel) {
    presentValidationResultFlag = true
  }
  
  func presentMonthSelectorContent(_ invoiceAwards: (this: InvoiceAwards?, previous: InvoiceAwards?)) {
    presentMonthSelectorContentFlag = true
  }
  
  func reloadContents() {
    reloadContentsFlag = true
  }
  
}

class KeyboardCheckerRouterMock : KeyboardCheckerRouter {
  
}

class KeyboardCheckerInteractorMock : KeyboardCheckerInteractor {
  
  var delegate: KeyboardCheckerInteractorDelegate?

  var checkingOptionMonth: WhichMonth = .this
  
  var invoiceAwards: (this: InvoiceAwards?, previous: InvoiceAwards?) {
    let this =
      InvoiceAwards(firstSpecialPrize: "12345678",
                  specialPrize: "12345678",
                  firstPrizes: ["12345678","12345678","12345678"],
                  additionSixthPrizes: ["996"],
                  period: (106,3,4))!
    let previous =
      InvoiceAwards(firstSpecialPrize: "12345678",
                    specialPrize: "12345678",
                    firstPrizes: ["12345678","12345678","12345678"],
                    additionSixthPrizes: ["996"],
                    period: (106,3,4))!
    return (this, previous)
  }
  
  var notifyInvoiceAwardsUpdatedFlag = false
  func notifyInvoiceAwardsUpdated() {
    notifyInvoiceAwardsUpdatedFlag = true
    delegate?.invoiceAwardsDidUpdate()
  }
  
  var setFlag = false
  func set(changed checkingOptionMonth: WhichMonth) {
    setFlag = true
  }
  
  var validateFlag = false
  func validate(_ numbers: String) -> ShortInvoiceValidationResult {
    validateFlag = true
    return .noPrize
  }
  
}
