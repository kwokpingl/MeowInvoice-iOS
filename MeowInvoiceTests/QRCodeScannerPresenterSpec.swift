//
//  QRCodeScannerPresenterSpec.swift
//  MeowInvoice
//
//  Created by David on 2017/6/20.
//  Copyright © 2017年 david. All rights reserved.
//

import Quick
import Nimble
@testable import MeowInvoice

class QRCodeScannerPresenterSpec: QuickSpec {
  
  var presenter: InvoiceQRCodeScannerDefaultPresenter!
  var viewMock: InvoiceQRCodeScannerViewMock!
  var routerMock: InvoiceQRCodeScannerRouterMock!
  var interactorMock: InvoiceQRCodeScannerInteractorMock!
  
  override func spec() {
    beforeEach {
      self.viewMock = InvoiceQRCodeScannerViewMock()
      self.routerMock = InvoiceQRCodeScannerRouterMock()
      self.interactorMock = InvoiceQRCodeScannerInteractorMock()
      
      self.presenter =
        InvoiceQRCodeScannerDefaultPresenter(interactor: self.interactorMock,
                                             router: self.routerMock,
                                             view: self.viewMock)
    }
    
    it("should call navigate to settings page") {
      self.presenter.gotoAppSettingsPage()
      expect(self.routerMock.navigateToAppSettingsPageFlag).to(beTrue())
    }
    
    it("should display result when scanning qrcode") { 
      self.presenter.presentResult(with: [])
      expect(self.interactorMock.validateCalled).to(beTrue())
      expect(self.viewMock.didDisplayScanResult).to(beTrue())
    }
    
  }
  
}

class InvoiceQRCodeScannerInteractorMock : InvoiceQRCodeScannerInteractor {
  
  var validateCalled = false
  
  func validate(qrCodes: [String]) -> InvoiceQRCodeScanResult {
    validateCalled = true
    return .winning(prize: InvoicePrize.first, invoice: Invoice(number: 11111111)!)
  }
  
}

class InvoiceQRCodeScannerViewMock : InvoiceQRCodeScannerView {
  
  var didDisplayScanResult = false
  
  func displayScanResult(_ viewModel: InvoiceQRCodeScanResultViewModel) {
    didDisplayScanResult = true
  }
  
}

class InvoiceQRCodeScannerRouterMock : InvoiceQRCodeScannerRouter {
  
  var navigateToAppSettingsPageFlag = false
  
  func navigateToAppSettingsPage() {
    navigateToAppSettingsPageFlag = true
  }
  
}
