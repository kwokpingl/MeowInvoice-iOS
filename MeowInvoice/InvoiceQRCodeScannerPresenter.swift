//
//  InvoiceQRCodeScannerPresenter.swift
//  MeowInvoice
//
//  Created by David on 2017/6/1.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation

public struct InvoiceQRCodeScanResultViewModel {
  public let result: String
  public let detailResult: String
  public let subtitle: String
  public let detailSubtitle: String
  public let shouldMeowCry: Bool
  public let play: (win: Bool, fail: Bool, error: Bool)
}

public protocol InvoiceQRCodeScannerPresenter {
  func presentResult(with qrcodes: [String])
  func gotoAppSettingsPage()
}

final public class InvoiceQRCodeScannerDefaultPresenter: InvoiceQRCodeScannerPresenter {
  
  // need interactor, router, view
  fileprivate let interactor: InvoiceQRCodeScannerInteractor
  fileprivate let router: InvoiceQRCodeScannerRouter
  fileprivate weak var view: InvoiceQRCodeScannerView?
  
  required public init(interactor: InvoiceQRCodeScannerInteractor, router: InvoiceQRCodeScannerRouter, view: InvoiceQRCodeScannerView) {
    self.interactor = interactor
    self.router = router
    self.view = view
  }
  
  // need view model builder?
  private let viewModelBuilder = InvoiceQRCodeScanResultViewModelBuilder()
  
  // MARK: - InvoiceQRCodeScannerPresenter
  public func presentResult(with qrcodes: [String]) {
    let result = interactor.validate(qrCodes: qrcodes)
    if let viewModel = viewModelBuilder.buildViewModel(result) {
      view?.displayScanResult(viewModel)
      AnalyticsHelper.instance().logScanQRCodeEvent(result: result)
    }
  }
  
  public func gotoAppSettingsPage() {
    router.navigateToAppSettingsPage()
  }
  
}

fileprivate struct InvoiceQRCodeScanResultViewModelBuilder {
  
  public func buildViewModel(_ result: InvoiceQRCodeScanResult) -> InvoiceQRCodeScanResultViewModel? {
    var resultMessage = ""
    var detailResultMessage = ""
    var subtitleMessage = ""
    var detailSubtitleMessage = ""
    var shouldMeowCry = false
    var play: (win: Bool, fail: Bool, error: Bool) = (false, false, false)
    switch result {
    case .noPrize(invoice: let invoice):
      resultMessage = "沒中"
      detailResultMessage = invoice.fullInvoice
      subtitleMessage = "請繼續努力"
      shouldMeowCry = true
      play.fail = true
    case .unableToRecognize:
      resultMessage = "無法辨識"
      detailResultMessage = "????????"
      subtitleMessage = "掃描失敗"
      detailSubtitleMessage = "建議使用鍵盤對奬"
      shouldMeowCry = true
      play.error = true
    case let .winning(prize: prize, invoice: invoice):
      resultMessage = "中獎"
      detailResultMessage = invoice.fullInvoice
      subtitleMessage = prize.prizeAmount.nsNumber.currencyFormatString ?? "" + "元"
      play.win = true
    case .expired(invoice: let invoice):
      resultMessage = "已過期"
      detailResultMessage = invoice.fullInvoice
      subtitleMessage = "下次請早"
      shouldMeowCry = true
      play.error = true
    case .lotteryNotYetOpened(invoice: let invoice):
      resultMessage = "未開獎"
      detailResultMessage = invoice.fullInvoice
      subtitleMessage = "下一期再來"
      shouldMeowCry = true
      play.error = true
    case .error:
      resultMessage = "沒有對獎資訊"
      subtitleMessage = "請確認網路連線狀態"
      shouldMeowCry = true
      play.error = true
    case let .redeemDataError(invoice: invoice, thisAwards: thisAwards, previousAwards: _):
      resultMessage = "對獎資訊錯誤"
      detailResultMessage = "尚未取得最新發票資料"
      subtitleMessage = "發票開立日：\(invoice.issuedDate.yearOfRepublicEra)/\(invoice.issuedDate.month)/\(invoice.issuedDate.day)"
      detailSubtitleMessage = "最新發票資料：\(thisAwards.period.year)年\(thisAwards.period.fromMonth)、\(thisAwards.period.toMonth)月"
      shouldMeowCry = true
      play.error = true
    case .inputRepeat, .noQRCode, .onlyOneQRCode:
      return nil
    }
    
    return InvoiceQRCodeScanResultViewModel(result: resultMessage,
                                            detailResult: detailResultMessage,
                                            subtitle: subtitleMessage,
                                            detailSubtitle: detailSubtitleMessage,
                                            shouldMeowCry: shouldMeowCry,
                                            play: play)
  }
  
}
