//
//  InvoiceQRCodeScannerDefaultBuilder.swift
//  MeowInvoice
//
//  Created by David on 2017/6/1.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

public protocol InvoiceQRCodeScannerBuilder {
  func buildInvoiceQRCodeModule() -> UIViewController?
}

public struct InvoiceQRCodeScannerDefaultBuilder : InvoiceQRCodeScannerBuilder {
  
  public func buildInvoiceQRCodeModule() -> UIViewController? {
    let vc = InvoiceQRCodeScannerViewController()
    
    let qrCodeDecoder = DefaultQRCodeDecoderService()
    let invoiceValidator = DefaultInvoiceValidationService()
    let qrCodeValidator = DefaultQRCodeInvoiceValidationService(validator: invoiceValidator)
    let awardsStore = DefaultInvoiceAwardsStoreService()
    let interactor =
      InvoiceQRCodeScannerDefaultInteractor(qrCodeDecoder: qrCodeDecoder,
                                            validator: qrCodeValidator,
                                            awardsStore: awardsStore)
    let router = InvoiceQRCodeScannerDefaultRouter(viewController: vc)
    
    let presenter = InvoiceQRCodeScannerDefaultPresenter(
      interactor: interactor,
      router: router,
      view: vc)
    
    vc.presenter = presenter
    
    return vc
  }
  
}
