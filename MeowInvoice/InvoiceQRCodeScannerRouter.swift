//
//  InvoiceQRCodeScannerRouter.swift
//  MeowInvoice
//
//  Created by David on 2017/6/1.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

public protocol InvoiceQRCodeScannerRouter {
  func navigateToAppSettingsPage()
}

final public class InvoiceQRCodeScannerDefaultRouter : InvoiceQRCodeScannerRouter {
  
  public weak var viewController: UIViewController?
  
  public init(viewController: UIViewController) {
    self.viewController = viewController
  }
  
  public func navigateToAppSettingsPage() {
    guard let url = URL(string: UIApplicationOpenSettingsURLString) else { return }
    UIApplication.shared.openURL(url)
  }
  
}
