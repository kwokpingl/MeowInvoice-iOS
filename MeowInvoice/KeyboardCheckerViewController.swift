//
//  KeyboardCheckerViewController.swift
//  MeowInvoice
//
//  Created by David on 2017/6/5.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

public protocol KeyboardCheckerView: class {
  func presentValidationResult(_ viewModel: ShortInvoiceValidationViewModel)
  func presentMonthSelectorContent(_ invoiceAwards: (this: InvoiceAwards?, previous: InvoiceAwards?))
  func presentChangedCheckingOption(_ option: String)
  func reloadContents()
}

final public class KeyboardCheckerViewController: UIViewController, KeyboardCheckerView {
  
  private var keyboard: MeowKeyboardView!
  
  private let resultDisplayerViewHeight: CGFloat = 128
  private let inputContentViewHeight: CGFloat = 98
  private var keyboardHeight: CGFloat {
    return view.bounds.height - resultDisplayerViewHeight - inputContentViewHeight
  }
  
  fileprivate private(set) var inputContentView: KeyboardInputView!
  fileprivate private(set) var resultDisplayerView: ResultDisplayerView!
  fileprivate private(set) var checkingOptionLabel: UILabel!
  
  fileprivate private(set) var monthSeletorView: MonthDropDownSelectorView!
  
  public var presenter: KeyboardCheckerPresenter?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    configureKeyboard()
    configureInputContentView()
    configureResultDisplayerView()
    configureCheckingOptionLabel()
    configureMonthSelectorView()
    
    presenter?.loadContents()
    
    view.backgroundColor = MeowInvoiceColor.lightBackgroundColor
  }
  
  public override func didMove(toParentViewController parent: UIViewController?) {
    super.didMove(toParentViewController: parent)
    
    rearrangeSubviews()
  }
  
  public func rearrangeSubviews() {
    keyboard.adjustHeight(to: keyboardHeight)
  }
  
  private func configureKeyboard() {
    keyboard = MeowKeyboardView(width: view.bounds.width, height: keyboardHeight)
    keyboard
      .anchor(to: view)
      .move(resultDisplayerViewHeight + inputContentViewHeight, pointsTopToAndInside: view)
    keyboard.delegate = self
  }
  
  private func configureInputContentView() {
    inputContentView = KeyboardInputView(width: view.bounds.width)
    inputContentView
      .move(0, pointTopOf: keyboard)
      .centerX(inside: view)
      .anchor(to: view)
    inputContentView.delegate = self
  }
  
  private func configureResultDisplayerView() {
    resultDisplayerView = ResultDisplayerView(width: view.bounds.width, height: resultDisplayerViewHeight)
    resultDisplayerView.anchor(to: view)
    resultDisplayerView.clearResult()
  }
  
  private func configureCheckingOptionLabel() {
    let left = 16.cgFloat
    checkingOptionLabel = UILabel()
    checkingOptionLabel
      .changeTextAlignment(to: .right)
      .changeFontSize(to: 12)
      .changeTextColor(to: MeowInvoiceColor.darkTextColor)
      .change(width: "00.00月 ▼".preferredTextWidth(constraintByFontSize: 12))
      .change(height: 12)
      .move(16, pointsTopToAndInside: resultDisplayerView)
      .move(left, pointsTrailingToAndInside: resultDisplayerView)
      .anchor(to: resultDisplayerView)
    checkingOptionLabel.text = "-.-月 ▼"
    checkingOptionLabel.isUserInteractionEnabled = true
    checkingOptionLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(KeyboardCheckerViewController.tappedOnCheckingOptionLabel)))
    
    let extendedView = HitTestExtendedView(withWidth: checkingOptionLabel.bounds.width, andReceiverView: checkingOptionLabel)
    extendedView.centerX(to: checkingOptionLabel).centerY(to: checkingOptionLabel).anchor(to: view)
  }
  
  private func configureMonthSelectorView() {
    monthSeletorView = MonthDropDownSelectorView()
    monthSeletorView
      .anchor(to: view)
      .equalRight(to: checkingOptionLabel)
      .move(8, pointBelow: checkingOptionLabel)
    monthSeletorView.dismiss()
    monthSeletorView.delegate = self
  }
  
  public func presentValidationResult(_ viewModel: ShortInvoiceValidationViewModel) {
    resultDisplayerView.update(with: viewModel)
    viewModel.shouldPlayWinningSound ? MeowSound.play().winning() : MeowSound.play().fail()
  }
  
  public func presentMonthSelectorContent(_ invoiceAwards: (this: InvoiceAwards?, previous: InvoiceAwards?)) {
    monthSeletorView.updateUI(with: invoiceAwards)
    let fromMonth = invoiceAwards.this?.period.fromMonth.string ?? "-"
    let toMonth = invoiceAwards.this?.period.toMonth.string ?? "-"
    let value = fromMonth + "." + toMonth + "月"
    checkingOptionLabel.text = value + " ▼"
  }
  
  public func presentChangedCheckingOption(_ option: String) {
    checkingOptionLabel.text = option + " ▼"
    resultDisplayerView.clearResult()
    inputContentView.clear()
  }
  
  public func reloadContents() {
    presenter?.loadContents()
  }
  
  @objc private func tappedOnCheckingOptionLabel() {
    monthSeletorView.isHidden ? monthSeletorView.dropDown() : monthSeletorView.dismiss()
  }
  
}

extension KeyboardCheckerViewController : MeowKeyboardViewDelegate {
  
  public func meowKeyboardView(didTapOn keyPad: MeowKeyPad) {
    resultDisplayerView.clearResult()
    inputContentView.input(key: keyPad)
  }
  
}

extension KeyboardCheckerViewController : KeyboardInputViewDelegate {
  
  public func keyboardInputView(didEnterInvoice number: String) {
    presenter?.presentResultOf(lastThree: number)
  }
  
}

extension KeyboardCheckerViewController : MonthDropDownSelectorViewDelegate {
  
  public func monthDropDownSelector(didSelect month: WhichMonth) {
    AnalyticsHelper.instance().logChangeMonthOptionEvent(month: month)
    presenter?.changeCheckingOption(bySelecting: month)
  }
  
}
