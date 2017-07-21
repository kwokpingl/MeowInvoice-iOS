//
//  KeyboardCheckerInteractor.swift
//  MeowInvoice
//
//  Created by David on 2017/6/14.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation

public protocol KeyboardCheckerInteractorDelegate: class {
  func invoiceAwardsDidUpdate()
}

public protocol KeyboardCheckerInteractor {
  var delegate: KeyboardCheckerInteractorDelegate? { get set }
  func validate(_ numbers: String) -> ShortInvoiceValidationResult
  var invoiceAwards: (this: InvoiceAwards?, previous: InvoiceAwards?) { get }
  var checkingOptionMonth: WhichMonth { get set }
  func set(changed checkingOptionMonth: WhichMonth)
  func notifyInvoiceAwardsUpdated()
}

final public class KeyboardCheckerDefaultInteractor : KeyboardCheckerInteractor {
  
  private let validator: ShortInvoiceValidationService
  private let invoiceAwardsStore: InvoiceAwardsStoreService
  public var checkingOptionMonth: WhichMonth = .this
  
  public weak var delegate: KeyboardCheckerInteractorDelegate?
  
  required public init(validator: ShortInvoiceValidationService, invoiceAwardsStore: InvoiceAwardsStoreService) {
    self.validator = validator
    self.invoiceAwardsStore = invoiceAwardsStore
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(KeyboardCheckerDefaultInteractor.notifyInvoiceAwardsUpdated),
                                           name: MeowNotification.invoiceAwardsUpdateNotificatoin,
                                           object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  public func validate(_ numbers: String) -> ShortInvoiceValidationResult {
    guard let thisMonth = invoiceAwardsStore.thisMonth, let previousMonth = invoiceAwardsStore.previousMonth else { return .error(message: "沒有最新發票資料") }
    guard let invoice = ShortInvoice(number: numbers) else { return .noPrize }
    switch checkingOptionMonth {
    case .this:
      return validator.validate(invoice, with: thisMonth)
    case .previous:
      return validator.validate(invoice, with: previousMonth)
    case .both:
      let thisMonthResult = validator.validate(invoice, with: thisMonth)
      if thisMonthResult != .noPrize {
        return thisMonthResult
      } else {
        // if this month got no prize, validate previous one then return.
        return validator.validate(invoice, with: previousMonth)
      }
    }
  }
  
  public var invoiceAwards: (this: InvoiceAwards?, previous: InvoiceAwards?) {
    return (invoiceAwardsStore.thisMonth, invoiceAwardsStore.previousMonth)
  }
  
  public func set(changed checkingOptionMonth: WhichMonth) {
    self.checkingOptionMonth = checkingOptionMonth
  }
  
  @objc public func notifyInvoiceAwardsUpdated() {
    delegate?.invoiceAwardsDidUpdate()
  }
  
}
