//
//  PreviewInvoiceViewController.swift
//  MeowInvoice
//
//  Created by David on 2017/6/7.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

final public class PreviewInvoiceViewController: UIViewController {
  
  private var navigationBar: MeowPresentModallyNavigationBar!
  private var containerView: UIScrollView!
  private var thisInformationView: InvoiceAwardsInformationView!
  private var previousInformationView: InvoiceAwardsInformationView!
  
  private let informationLeftMargin = 12.cgFloat
  
  fileprivate private(set) var invoiceAwards: (this: InvoiceAwards, previous: InvoiceAwards)!
  fileprivate private(set) var selectedAwards: InvoiceAwards!
  
  public convenience init(invoiceAwards: (this: InvoiceAwards, previous: InvoiceAwards), selectedAwards: InvoiceAwards) {
    self.init(nibName: nil, bundle: nil)
    
    self.invoiceAwards = invoiceAwards
    self.selectedAwards = selectedAwards
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    configureNavigationBar()
    configureContainerView()
    
    scrollToShow(invoiceAwards: selectedAwards)
    
    view.backgroundColor = MeowInvoiceColor.backgroundOrange
  }
  
  private func configureNavigationBar() {
    let title = "\(selectedAwards.period.year)年\(selectedAwards.period.fromMonth).\(selectedAwards.period.toMonth)月"
    navigationBar = MeowPresentModallyNavigationBar(title: title, rightButtonTitle: "上一期")
    navigationBar.delegate = self
    navigationBar.anchor(to: view)
  }
  
  private func configureContainerView() {
    containerView = UIScrollView(frame: view.bounds)
    containerView.frame.origin.y = navigationBar.bounds.height
    containerView.frame.size.height = view.bounds.height - navigationBar.bounds.height
    containerView.contentSize = view.bounds.size
    containerView.anchor(to: view, below: navigationBar)
    
    containerView.isPagingEnabled = true
    containerView.delegate = self
    
    configureInformationViews()
    
    containerView.contentSize.height = view.bounds.height - navigationBar.bounds.height
    containerView.contentSize.width = view.bounds.width * 2
    containerView.showsHorizontalScrollIndicator = false
  }
  
  private func configureInformationViews() {
    previousInformationView = InvoiceAwardsInformationView(width: view.bounds.width - 2 * informationLeftMargin,
                                                           invoiceAwards: invoiceAwards.previous)
    
    let previousContainer = generateSubcontainer(width: view.bounds.width,
                                                 height: previousInformationView.bounds.height + 2 * informationLeftMargin)
    
    previousInformationView
      .move(informationLeftMargin, pointsLeadingToAndInside: previousContainer)
      .move(informationLeftMargin, pointsTopToAndInside: previousContainer)
      .anchor(to: previousContainer)
    
    previousContainer.anchor(to: containerView)
    
    thisInformationView = InvoiceAwardsInformationView(width: view.bounds.width - 2 * informationLeftMargin,
                                                       invoiceAwards: invoiceAwards.this)
    
    let thisContainer = generateSubcontainer(width: view.bounds.width,
                                             height: thisInformationView.bounds.height + 2 * informationLeftMargin)
    
    thisInformationView
      .move(informationLeftMargin, pointsLeadingToAndInside: thisContainer)
      .move(informationLeftMargin, pointsTopToAndInside: thisContainer)
      .anchor(to: thisContainer)
    
    thisContainer.move(0, pointsRightFrom: previousContainer).anchor(to: containerView)
  }
  
  private func generateSubcontainer(width: CGFloat, height: CGFloat) -> UIScrollView {
    let containerView = UIScrollView(frame: view.bounds)
    containerView.frame.size.height = view.bounds.height - navigationBar.bounds.height
    
    containerView.contentSize.height = height
    containerView.contentSize.width = width
    containerView.showsVerticalScrollIndicator = false
    
    return containerView
  }
  
  public override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  fileprivate func scrollToShow(invoiceAwards: InvoiceAwards, animated: Bool = false) {
    navigationBar.titleLabel.text = "\(invoiceAwards.period.year)年\(invoiceAwards.period.fromMonth).\(invoiceAwards.period.toMonth)月"
    if invoiceAwards == self.invoiceAwards.this {
      navigationBar.rightButton?.setTitle("上一期", for: .normal)
      containerView.setContentOffset(CGPoint(x: view.bounds.width, y: 0), animated: animated)
    } else {
      navigationBar.rightButton?.setTitle("下一期", for: .normal)
      containerView.setContentOffset(.zero, animated: animated)
    }
  }
  
}

extension PreviewInvoiceViewController : MeowPresentModallyNavigationBarDelegate {
  
  public func meowPresentModallyNavigationBarDidTapCrossButton() {
    asyncDismiss(true)
  }
  
  public func meowPresentModallyNavigationBar(rightButtonClicked button: UIButton) {
    if button.titleLabel?.text == "上一期" {
      // show previous
      scrollToShow(invoiceAwards: invoiceAwards.previous, animated: true)
      AnalyticsHelper.instance().logClickToSwitchPreviewMonthEvent(month: "上一期")
    } else {
      scrollToShow(invoiceAwards: invoiceAwards.this, animated: true)
      AnalyticsHelper.instance().logClickToSwitchPreviewMonthEvent(month: "下一期")
    }
  }
  
}

extension PreviewInvoiceViewController : UIScrollViewDelegate {
  
  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.x + 10 > view.bounds.width {
      // this month
      scrollToShow(invoiceAwards: invoiceAwards.this)
      AnalyticsHelper.instance().logSwipeToSwitchPreviewMonthEvent(month: "下一期")
    } else {
      // previous month
      scrollToShow(invoiceAwards: invoiceAwards.previous)
      AnalyticsHelper.instance().logSwipeToSwitchPreviewMonthEvent(month: "上一期")
    }
  }
  
}
