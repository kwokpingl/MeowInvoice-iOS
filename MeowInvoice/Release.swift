//
//  Release.swift
//  MeowInvoice
//
//  Created by David on 2017/7/15.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation

final public class Release {
  // Add "-D DEBUG" to other swift flag in Build Settings
  #if DEBUG
  public static let mode = false
  #else
  public static let mode = true
  #endif
  
//  private init() { }
}
