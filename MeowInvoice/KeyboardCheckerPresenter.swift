//
//  KeyboardCheckerPresenter.swift
//  MeowInvoice
//
//  Created by David on 2017/6/14.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation
import UIKit

public protocol KeyboardCheckerPresenter {
  func presentResultOf(lastThree numbers: String)
  func loadContents()
  func changeCheckingOption(bySelecting month: WhichMonth)
}

final public class KeyboardCheckerDefaultPresenter : KeyboardCheckerPresenter {
  
  fileprivate private(set) weak var view: KeyboardCheckerView?
  private let router: KeyboardCheckerRouter
  private var interactor: KeyboardCheckerInteractor
  
  private let builder = KeyboardCheckerViewModelBuilder()
  
  required public init(view: KeyboardCheckerView, router: KeyboardCheckerRouter, interactor: KeyboardCheckerInteractor) {
    self.view = view
    self.router = router
    self.interactor = interactor
    self.interactor.delegate = self
  }
  
  public func presentResultOf(lastThree numbers: String) {
    let result = interactor.validate(numbers)
    AnalyticsHelper.instance().logKeyboardInputEvent(number: numbers, result: result, month: interactor.checkingOptionMonth)
    let vm = builder.buildViewModel(result, month: interactor.checkingOptionMonth)
    view?.presentValidationResult(vm)
  }
  
  public func loadContents() {
    view?.presentMonthSelectorContent(interactor.invoiceAwards)
    let information = builder.buildChangeMonthOptionInformation(month: interactor.checkingOptionMonth, invoiceAwards: interactor.invoiceAwards)
    view?.presentChangedCheckingOption(information)
  }
  
  public func changeCheckingOption(bySelecting month: WhichMonth) {
    interactor.set(changed: month)
    let information = builder.buildChangeMonthOptionInformation(month: interactor.checkingOptionMonth, invoiceAwards: interactor.invoiceAwards)
    view?.presentChangedCheckingOption(information)
  }
  
}

extension KeyboardCheckerDefaultPresenter : KeyboardCheckerInteractorDelegate {
  
  public func invoiceAwardsDidUpdate() {
    view?.reloadContents()
  }
  
}

public struct ShortInvoiceValidationViewModel {
  let title: String
  let subtitle: NSAttributedString
  let shouldPlayWinningSound: Bool
}

fileprivate struct KeyboardCheckerViewModelBuilder {
  
  private func generateSubtitle(_ frontPartString: String, _ secondPartString: String) -> NSAttributedString {
    let frontPartAttribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName: MeowInvoiceColor.darkTextColor]
    let frontPartAttributeString = NSMutableAttributedString(string: frontPartString, attributes: frontPartAttribute)
    let secondPartAttribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName: UIColor.white]
    let secondPartAttributeString = NSAttributedString(string: secondPartString, attributes: secondPartAttribute)
    frontPartAttributeString.append(secondPartAttributeString)

    return frontPartAttributeString
  }
  
  func buildViewModel(_ result: ShortInvoiceValidationResult, month: WhichMonth) -> ShortInvoiceValidationViewModel {
    switch result {
    case let .seemsLikeWinningAdditionalPrize(awards: awards, additionalSixthPrize: additionalSixthPrize):
      switch month {
      case .this, .previous:
        let frontPartString = "\(awards.period.fromMonth).\(awards.period.toMonth)月增開六獎"
        let secondPartString = "\(additionalSixthPrize.number)"
        let subtitle = generateSubtitle(frontPartString, secondPartString)
        return ShortInvoiceValidationViewModel(title: "中獎", subtitle: subtitle, shouldPlayWinningSound: true)
      case .both:
        let frontPartString = "是否為\(awards.period.fromMonth).\(awards.period.toMonth)月增開六獎"
        let secondPartString = "\(additionalSixthPrize.number)"
        let subtitle = generateSubtitle(frontPartString, secondPartString)
        return ShortInvoiceValidationViewModel(title: "中了？", subtitle: subtitle, shouldPlayWinningSound: true)
      }
    case let .seemsLikeWinningFirstSpecialPrize(awards: awards, suspectFirstSpecialPrize: suspectFirstSpecialPrize):
      let frontPartString = "是否為\(awards.period.fromMonth).\(awards.period.toMonth)月特別獎\(suspectFirstSpecialPrize.number.string(from: 0, to: 4))"
      let secondPartString = "\(suspectFirstSpecialPrize.shortInvoice.number)"
      let subtitle = generateSubtitle(frontPartString, secondPartString)
      return ShortInvoiceValidationViewModel(title: "中了？", subtitle: subtitle, shouldPlayWinningSound: true)
    case let .seemsLikeWinningSpecialPrize(awards: awards, suspectSpecialPrize: suspectSpecialPrize):
      let frontPartString = "是否為\(awards.period.fromMonth).\(awards.period.toMonth)月特獎\(suspectSpecialPrize.number.string(from: 0, to: 4))"
      let secondPartString = "\(suspectSpecialPrize.shortInvoice.number)"
      let subtitle = generateSubtitle(frontPartString, secondPartString)
      return ShortInvoiceValidationViewModel(title: "中了？", subtitle: subtitle, shouldPlayWinningSound: true)
    case let .seemsLikeWinningFirstPrize(awards: awards, suspectFirstPrize: suspectFirstPrize):
      let frontPartString = "是否為\(awards.period.fromMonth).\(awards.period.toMonth)月頭獎\(suspectFirstPrize.number.string(from: 0, to: 4))"
      let secondPartString = "\(suspectFirstPrize.shortInvoice.number)"
      let subtitle = generateSubtitle(frontPartString, secondPartString)
      return ShortInvoiceValidationViewModel(title: "中了？", subtitle: subtitle, shouldPlayWinningSound: true)
    case .noPrize:
      let string = "請繼續努力"
      let attribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName: MeowInvoiceColor.darkTextColor]
      let attributeString = NSAttributedString(string: string, attributes: attribute)
      return ShortInvoiceValidationViewModel(title: "沒中", subtitle: attributeString, shouldPlayWinningSound: false)
    case .error:
      return ShortInvoiceValidationViewModel(title: "沒有對獎資訊", subtitle: NSAttributedString(string: "請確認網路連線狀態"), shouldPlayWinningSound: false)
    }
  }
  
  public func buildChangeMonthOptionInformation(month: WhichMonth, invoiceAwards: (this: InvoiceAwards?, previous: InvoiceAwards?)) -> String {
    switch month {
    case .this:
      guard let this = invoiceAwards.this else { return "" }
      return "\(this.period.fromMonth).\(this.period.toMonth)月"
    case .previous:
      guard let previous = invoiceAwards.previous else { return "" }
      return "\(previous.period.fromMonth).\(previous.period.toMonth)月"
    case .both:
      return "一起對"
    }
  }
  
}
