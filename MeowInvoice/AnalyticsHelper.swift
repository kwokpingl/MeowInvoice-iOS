//
//  AnalyticsHelper.swift
//  MeowInvoice
//
//  Created by David on 2017/7/9.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation
import Amplitude_iOS

fileprivate enum AnalyticEvent {
  case appLaunch
  case showSettingsPage, changeSoundSetting, changeNotificationSetting
  case switchToFrontPage, switchToKeyboardPage, switchToQRCodeScanPage
  case clickToEnterPreviewPage, clickToSwitchPreviewMonth
  case clickAD
  case changeMonthOption
  case keyboardInput
  case scanQRCode
  
  public var eventName: String {
    switch self {
    case .appLaunch: return "App 開啟"
    case .showSettingsPage: return "進入設定頁面"
    case .changeSoundSetting: return "改變聲音設定"
    case .changeNotificationSetting: return "改變推播通知設定"
    case .switchToFrontPage: return "切換到首頁"
    case .switchToKeyboardPage: return "切換到鍵盤頁面"
    case .switchToQRCodeScanPage: return "切換到掃描QRCode頁面"
    case .clickToEnterPreviewPage: return "按下查看號碼按鈕以顯示對獎資訊頁面"
    case .clickToSwitchPreviewMonth: return "按下切換對獎資訊按鈕"
    case .clickAD: return "點擊廣告"
    case .changeMonthOption: return "改變對獎月份"
    case .keyboardInput: return "鍵盤輸入兌獎"
    case .scanQRCode: return "掃描QRCode兌獎"
    }
  }
}

final public class AnalyticsHelper {
  
  public class func instance() -> AnalyticsHelper {
    
    struct Static {
      static let instance: AnalyticsHelper = AnalyticsHelper()
    }
    
    return Static.instance
  }
  
  private init() { }
  
  public func initialize() {
    // Amplitude
    if Release.mode {
      Amplitude.instance().initializeApiKey(SecretKey.amplitudeAPIKey)
    } else {
      Amplitude.instance().initializeApiKey(SecretKey.amplitudeDevAPIKey)
    }
  }
  
  public func setInitialUserProperties() {
    setUserSound(soundName: .meow)
  }
  
  // MARK: - User Properties
  private func setUserSound(soundName: SoundName) {
    Amplitude.instance().setUserProperties(["soundName": soundName.value], replace: true)
  }
  
  private func setUserNotification(state on: Bool) {
    Amplitude.instance().setUserProperties(["getNotificatoin": on], replace: true)
  }
  
  // MARK: -
  private func logEvent(_ event: AnalyticEvent, parameters: [String : Any]? = nil) {
    Amplitude.instance().logEvent(event.eventName, withEventProperties: parameters)
  }
  
  // MARK: - Log Event
  public func logAppLaunchEvent() {
    logEvent(.appLaunch)
  }
  
  public func logShowSettingsPageEvent() {
    logEvent(.showSettingsPage)
  }
  
  public func logChangeSoundSettingEvent(soundName: SoundName) {
    let parameters: [String : Any]? = ["soundName": soundName.value]
    logEvent(.changeSoundSetting, parameters: parameters)
    setUserSound(soundName: soundName)
  }
  
  public func logChangeNotificationSettingEvent(on: Bool) {
    let parameters: [String : Any]? = ["notificationOn": on]
    logEvent(.changeNotificationSetting, parameters: parameters)
    setUserNotification(state: on)
  }
  
  public func logSwitchToFrontPageEvent() {
    logEvent(.switchToFrontPage)
  }
  
  public func logSwitchToKeyboardPageEvent() {
    logEvent(.switchToKeyboardPage)
  }
  
  public func logSwitchToQRCodeScanPageEvent() {
    logEvent(.switchToQRCodeScanPage)
  }
  
  public func logClickToEnterPreviewPageEvent() {
    logEvent(.clickToEnterPreviewPage)
  }
  
  public func logClickToSwitchPreviewMonthEvent(month: String) {
    let parameters: [String : Any]? = ["method": "按鈕", "period": month]
    logEvent(.clickToSwitchPreviewMonth, parameters: parameters)
  }
  
  public func logSwipeToSwitchPreviewMonthEvent(month: String) {
    let parameters: [String : Any]? = ["method": "滑動", "period": month]
    logEvent(.clickToSwitchPreviewMonth, parameters: parameters)
  }
  
  public func logClickADEvent() {
    logEvent(.clickAD)
  }
  
  public func logChangeMonthOptionEvent(month: WhichMonth) {
    let parameters: [String : Any]? = ["month": month.rawValue]
    logEvent(.changeMonthOption, parameters: parameters)
  }
  
  public func logKeyboardInputEvent(number: String, result: ShortInvoiceValidationResult, month: WhichMonth) {
    let prize = { () -> String in
      switch result {
      case .seemsLikeWinningFirstSpecialPrize: return "特別獎"
      case .seemsLikeWinningSpecialPrize: return "特獎"
      case .seemsLikeWinningFirstPrize: return "頭獎"
      case .seemsLikeWinningAdditionalPrize: return "增開六獎"
      default: return "沒有中獎"
      }
    }()
    let parameters: [String : Any]? = ["number": number,
                                       "prize": prize,
                                       "month": month.rawValue]
    logEvent(.keyboardInput, parameters: parameters)
  }
  
  public func logScanQRCodeEvent(result: InvoiceQRCodeScanResult) {
    let validationResult = { () -> String in
      switch result {
      case .noPrize: return "沒有中獎"
      case let .winning(prize: prize, invoice: _): return prize.stringValue
      case .lotteryNotYetOpened: return "發票尚未開獎"
      case .expired: return "發票過期"
      case .redeemDataError: return "兌獎時沒有最新發票資料"
      default: return "無法辨識發票"
      }
    }()
    let invoice: QRCodeInvoice? = { () -> QRCodeInvoice? in
      switch result {
      case let .noPrize(invoice: invoice): return invoice
      case let .winning(prize: _, invoice: invoice): return invoice
      case let .lotteryNotYetOpened(invoice: invoice): return invoice
      case let .expired(invoice: invoice): return invoice
      default: return nil
      }
    }()
    let issuedDate = { () -> String in
      guard let issuedDate = invoice?.issuedDate else { return "N/A" }
      let issuedYear = issuedDate.yearOfRepublicEra.string
      let issuedMonth = (issuedDate.month < 10 ? ("0" + issuedDate.month.string) : (issuedDate.month.string))
      let issuedDay = (issuedDate.day < 10 ? ("0" + issuedDate.day.string) : (issuedDate.day.string))
      return issuedYear + issuedMonth + issuedDay
    }()
    let parameters: [String : Any]? = ["number": invoice?.fullInvoice ?? "**********",
                                       "issuedDate": issuedDate,
                                       "validationResult": validationResult]
    logEvent(.scanQRCode, parameters: parameters)
  }
  
}

