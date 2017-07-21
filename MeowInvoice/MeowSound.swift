//
//  SoundPlayService.swift
//  MeowInvoice
//
//  Created by David on 2017/7/12.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation
import SwiftySound

final public class MeowSound {
  
  private let soundStore: DefaultSoundStoreService
  
  public class func play() -> MeowSound {
    
    struct Static {
      static let instance = MeowSound()
    }
    
    return Static.instance
  }
  
  private init() {
    soundStore = DefaultSoundStoreService()
  }
  
  public func tick() {
    Sound.play(file: "tick.wav")
  }
  
  public func error() {
    Sound.play(file: "error.wav")
  }
  
  public func winning() {
    switch soundStore.prizeAlertSoundName {
    case .meow: Sound.play(file: "meow_win.wav")
    case .dingdone: Sound.play(file: "ringtone_win.wav")
    case .human: Sound.play(file: "google_win.wav")
    }
  }
  
  public func fail() {
    switch soundStore.prizeAlertSoundName {
    case .meow: Sound.play(file: "meow_fail.wav")
    case .dingdone: Sound.play(file: "ringtone_fail.wav")
    case .human: Sound.play(file: "google_fail.wav")
    }
  }
  
}
