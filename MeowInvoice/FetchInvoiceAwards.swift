//
//  FetchInvoiceAwards.swift
//  MeowInvoice
//
//  Created by David on 2017/5/29.
//  Copyright © 2017年 david. All rights reserved.
//

import Foundation
import NetworkRequestKit
import PromiseKit
import Alamofire
import SwiftyJSON

public protocol FetchInvoiceAwardsService {
  func makeRequest() -> Promise<(thisMonth: InvoiceAwards, previousMonth: InvoiceAwards)>
}

final public class FetchInvoiceAwards : NetworkRequest, FetchInvoiceAwardsService {
  public typealias ResponseType = RawJSONResult
  
  public var endpoint: String { return "" }
  public var method: HTTPMethod { return .get }
  
  public func makeRequest() -> Promise<(thisMonth: InvoiceAwards, previousMonth: InvoiceAwards)> {
    return networkClient.performRequest(self).then(execute: dataParser)
  }
  
  public func dataParser(_ data: Data) throws -> (thisMonth: InvoiceAwards, previousMonth: InvoiceAwards) {
    return try InvoiceAwards.fromHTMLParser(parseWith: data)
  }
  
}
