//
//  MeowNavigationInteractor.swift
//  MeowInvoice
//
//  Created by David on 2017/6/15.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation

public protocol MeowNavigationInteractor {
  func updateInvoiceAwards()
  func retryUpdate()
}

final public class MeowNavigationDefaultInteractor : MeowNavigationInteractor {
  
  private let awardsStore: InvoiceAwardsStoreService
  private let fetcher: FetchInvoiceAwardsService
  
  public init(awardsStore: InvoiceAwardsStoreService, fetcher: FetchInvoiceAwardsService) {
    self.awardsStore = awardsStore
    self.fetcher = fetcher
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(MeowNavigationDefaultInteractor.updateInvoiceAwards),
                                           name: NSNotification.Name.UIApplicationWillEnterForeground,
                                           object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc public func updateInvoiceAwards() {
    fetcher.makeRequest().then(execute: { [weak self] (this, previous) -> Void in
      self?.awardsStore.updateInvoiceAwards(with: (this, previous))
      NotificationCenter.default.post(name: MeowNotification.invoiceAwardsUpdateNotificatoin, object: nil)
    }).catch(execute: { [weak self] e in
      self?.retryUpdate()
    })
  }
  
  public func retryUpdate() {
    _ = Queue.delayInMainQueue(for: 3.0).then(execute: { [weak self] () -> () in
      self?.updateInvoiceAwards()
    })
  }
  
}
