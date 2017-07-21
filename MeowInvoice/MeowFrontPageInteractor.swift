//
//  MeowFrontPageInteractor.swift
//  MeowInvoice
//
//  Created by David on 2017/6/6.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation

public protocol MeowFrontPageInteractorDelegate: class {
  func invoiceAwardsDidUpdate()
}

public protocol MeowFrontPageInteractor {
  var delegate: MeowFrontPageInteractorDelegate? { get set }
  var daysUntilNextOpenLotteryDay: Int { get }
  var nextOpenLotteryDate: Date { get }
  var invoiceAwards: (thisMonth: InvoiceAwards?, previousMonth: InvoiceAwards?) { get }
  func notifyInvoiceAwardupdate()
}

final public class MeowFrontPageDefaultInteractor : MeowFrontPageInteractor {
  
  private let countDownService: OpenLotteryCountDownService
  private let invoiceAwardsStore: InvoiceAwardsStoreService
  
  public weak var delegate: MeowFrontPageInteractorDelegate?
  
  required public init(countDownService: OpenLotteryCountDownService, invoiceAwardsStore: InvoiceAwardsStoreService) {
    self.countDownService = countDownService
    self.invoiceAwardsStore = invoiceAwardsStore
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(MeowFrontPageDefaultInteractor.notifyInvoiceAwardupdate),
                                           name: MeowNotification.invoiceAwardsUpdateNotificatoin,
                                           object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc public func notifyInvoiceAwardupdate() {
    delegate?.invoiceAwardsDidUpdate()
  }
  
  public var daysUntilNextOpenLotteryDay: Int {
    return countDownService.daysUntilNextOpenLotteryDate
  }
  
  public var nextOpenLotteryDate: Date {
    return countDownService.nextOpenLotteryDate
  }
  
  public var invoiceAwards: (thisMonth: InvoiceAwards?, previousMonth: InvoiceAwards?) {
    return (invoiceAwardsStore.thisMonth, invoiceAwardsStore.previousMonth)
  }
  
}
