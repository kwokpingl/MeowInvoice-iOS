//
//  MeowFrontPagePresenter.swift
//  MeowInvoice
//
//  Created by David on 2017/6/6.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation

public protocol MeowFrontPagePresenter {
  func loadCountDownInformation()
  func loadInvoiceAwardsInformation()
  func present(invoiceAwards: InvoiceAwards)
}

final public class MeowFrontPageDefaultPresenter : MeowFrontPagePresenter {
  
  public private(set) weak var view: MeowFrontPageView?
  private var interactor: MeowFrontPageInteractor
  private let viewModelBuilder = MeowFrontPageViewModelBuilder()
  private let router: MeowFrontPageRouter
  
  public required init(interactor: MeowFrontPageInteractor, router: MeowFrontPageRouter, view: MeowFrontPageView) {
    self.view = view
    self.interactor = interactor
    self.router = router
    self.interactor.delegate = self
  }
  
  public func loadInvoiceAwardsInformation() {
    let viewModel = viewModelBuilder.bulidViewModel(interactor.invoiceAwards)
    view?.updateInvoiceAwardsInformation(viewModel)
  }
  
  public func loadCountDownInformation() {
    let countDownDays = interactor.daysUntilNextOpenLotteryDay
    let nextDate = interactor.nextOpenLotteryDate
    let viewModel = viewModelBuilder.buildViewModel(countDownDays: countDownDays, nextDate: nextDate)
    view?.updateCountDownInformation(viewModel)
  }
  
  public func present(invoiceAwards: InvoiceAwards) {
    guard let this = interactor.invoiceAwards.thisMonth, let previous = interactor.invoiceAwards.previousMonth else { return }
    router.navigateToPreviewInvoice(with: invoiceAwards, invoiceAwards: (this, previous))
  }
  
}

extension MeowFrontPageDefaultPresenter : MeowFrontPageInteractorDelegate {
  
  public func invoiceAwardsDidUpdate() {
    view?.reloadFrontPageContent()
  }
  
}

public struct CountDownInformationViewModel {
  let countDownDays: Int
  let nextOpenLotteryDate: Date
}

public struct FrontPageInvoiceAwardsViewModel {
  let thisMonth: InvoiceAwards?
  let previousMonth: InvoiceAwards?
}

fileprivate struct MeowFrontPageViewModelBuilder {
  
  func buildViewModel(countDownDays: Int, nextDate: Date) -> CountDownInformationViewModel {
    return CountDownInformationViewModel(countDownDays: countDownDays, nextOpenLotteryDate: nextDate)
  }
  
  func bulidViewModel(_ invoiceAwards: (thisMonth: InvoiceAwards?, previousMonth: InvoiceAwards?)) -> FrontPageInvoiceAwardsViewModel {
    return FrontPageInvoiceAwardsViewModel(thisMonth: invoiceAwards.thisMonth, previousMonth: invoiceAwards.previousMonth)
  }
  
}
