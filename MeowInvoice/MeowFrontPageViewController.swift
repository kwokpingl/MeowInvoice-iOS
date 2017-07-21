//
//  MeowFrontPageViewController.swift
//  MeowInvoice
//
//  Created by David on 2017/6/4.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

public protocol MeowFrontPageView: class {
  func updateCountDownInformation(_ viewModel: CountDownInformationViewModel)
  func updateInvoiceAwardsInformation(_ viewModel: FrontPageInvoiceAwardsViewModel)
  func reloadFrontPageContent()
}

final public class MeowFrontPageViewController: UIViewController, MeowFrontPageView {
  
  private var checkInvoiceView: CheckInvoiceView!
  private let leftMargin = 12.cgFloat
  private var circularCountdownView: CircularCountdownView!
  private var meowFootPrintImageView: UIImageView!
  
  public var presenter: MeowFrontPagePresenter?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    configureCheckInvoiceView()
    configureCircularConutdownView()
    configureMeowFootPrint()
    
    view.backgroundColor = MeowInvoiceColor.backgroundOrange
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    presenter?.loadCountDownInformation()
    presenter?.loadInvoiceAwardsInformation()
  }
  
  public override func didMove(toParentViewController parent: UIViewController?) {
    super.didMove(toParentViewController: parent)
    
    rearrangeSubviews()
  }
  
  public func rearrangeSubviews() {
    checkInvoiceView
      .move(leftMargin, pointsBottomToAndInside: view)
      .centerX(to: view)
    
    circularCountdownView.center.y = (view.bounds.height - checkInvoiceView.bounds.height - leftMargin) / 2
    meowFootPrintImageView
      .move(0, pointsRightFrom: circularCountdownView)
      .move(-50, pointBelow: circularCountdownView)
  }
  
  private func configureCheckInvoiceView() {
    checkInvoiceView = CheckInvoiceView(width: view.bounds.width - leftMargin * 2)
    checkInvoiceView.anchor(to: view)
    checkInvoiceView.delegate = self
  }
  
  private func configureCircularConutdownView() {
    circularCountdownView = CircularCountdownView(size: 206.25)
    
    circularCountdownView
      .centerX(inside: view)
      .anchor(to: view)
    
    circularCountdownView.center.y = (view.bounds.height - checkInvoiceView.bounds.height - leftMargin) / 2
  }
  
  private func configureMeowFootPrint() {
    meowFootPrintImageView = UIImageView()
    meowFootPrintImageView
      .change(width: 51)
      .change(height: 71)
    meowFootPrintImageView.contentMode = .scaleAspectFill
    meowFootPrintImageView.image = #imageLiteral(resourceName: "meow_foot_print")
    meowFootPrintImageView
      .move(0, pointsRightFrom: circularCountdownView)
      .move(-50, pointBelow: circularCountdownView)
      .anchor(to: view)
  }
  
  // MARK: - MeowFrontPageView
  public func updateCountDownInformation(_ viewModel: CountDownInformationViewModel) {
    circularCountdownView.updateContent(with: viewModel)
  }
  
  public func updateInvoiceAwardsInformation(_ viewModel: FrontPageInvoiceAwardsViewModel) {
    checkInvoiceView.update(with: viewModel)
  }
  
  public func reloadFrontPageContent() {
    presenter?.loadInvoiceAwardsInformation()
  }
  
}

extension MeowFrontPageViewController : CheckInvoiceViewDelegate {
  
  public func checkInvoiceView(didRequestToCheck invoiceAwards: InvoiceAwards) {
    presenter?.present(invoiceAwards: invoiceAwards)
  }
  
}
