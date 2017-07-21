//
//  QRCodeDecoderService.swift
//  MeowInvoice
//
//  Created by David on 2017/6/1.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation

public protocol QRCodeDecoderService {
  func decode(qrCodes: [String]) -> QRCodeInvoice?
}

public struct DefaultQRCodeDecoderService : QRCodeDecoderService {
  
  public func decode(qrCodes: [String]) -> QRCodeInvoice? {
    return QRCodeInvoice(qrCodes: qrCodes)
  }
  
}
