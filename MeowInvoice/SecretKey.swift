//
//  SecretKey.swift
//  MeowInvoice
//
//  Created by David on 2017/7/12.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation

final public class SecretKey {
  
  private init() { }
  
  private class func getAPIKey(file: String) -> String {
    // The string that results from reading the bundle resource contains a trailing
    // newline character, which we must remove now because Fabric/Crashlytics
    // can't handle extraneous whitespace.
    let resourceURL = Bundle.main.url(forResource: file + ".apikey", withExtension: nil)!
    return try! String(contentsOf: resourceURL).trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  public static var fabricAPIKey: String {
    return getAPIKey(file: "fabric")
  }
  
  public static var admobAPIKey: String {
    return getAPIKey(file: "admob")
  }
  
  public static var adUnitID: String {
    return getAPIKey(file: "adUnitID")
  }
  
  public static var amplitudeAPIKey: String {
    return getAPIKey(file: "amplitude")
  }
  
  public static var amplitudeDevAPIKey: String {
    return getAPIKey(file: "amplitude-dev")
  }
  
}
