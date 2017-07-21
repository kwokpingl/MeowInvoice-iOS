//
//  ShortInvoice.swift
//  MeowInvoice
//
//  Created by David on 2017/5/31.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation

public struct ShortInvoice {
  public let number: String
  
  public init?(number: String) {
    guard number.characters.count == 3, number.isNumeric else { return nil }
    self.number = number
  }
  
}

extension ShortInvoice : Equatable {
  
  static public func ==(lhs: ShortInvoice, rhs: ShortInvoice) -> Bool {
    return lhs.number == rhs.number
  }
  
}
