//
//  VIPERRouter.swift
//  MeowInvoice
//
//  Created by David on 2017/6/7.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

public protocol VIPERRouter {
  weak var viewController: UIViewController? { get set }
  init(viewController: UIViewController)
}
