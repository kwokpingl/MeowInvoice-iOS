//
//  MeowFrontPageRouter.swift
//  MeowInvoice
//
//  Created by David on 2017/6/7.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

public protocol MeowFrontPageRouter {
  func navigateToPreviewInvoice(with selectedInvoiceAwards: InvoiceAwards, invoiceAwards: (this: InvoiceAwards, previous: InvoiceAwards))
}

final public class MeowFrontPageDefaultRouter : MeowFrontPageRouter {
  
  public weak var viewController: UIViewController?
  private let transitionManager = MeowNavigationTransitioningDelegate()
  
  public init(viewController: UIViewController) {
    self.viewController = viewController
  }
  
  public func navigateToPreviewInvoice(with selectedInvoiceAwards: InvoiceAwards, invoiceAwards: (this: InvoiceAwards, previous: InvoiceAwards)) {
    AnalyticsHelper.instance().logClickToEnterPreviewPageEvent()
    let module = PreviewInvoiceViewController(invoiceAwards: invoiceAwards, selectedAwards: selectedInvoiceAwards)
    transitionManager.presentingViewController = module
    viewController?.asyncPresent(module, animated: true)
  }
  
}
