//
//  MeowNavigationController.swift
//  MeowInvoice
//
//  Created by David on 2017/6/4.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit
import GoogleMobileAds

public protocol MeowNavigationView: class {
  
}

final public class MeowNavigationController: UIViewController, MeowNavigationView {
  
  public private(set) var navigationBar: MeowNavigationBar!
  
  private var containerView: UIScrollView!
  private var adBannerView: GADBannerView!
  
  fileprivate private(set) var frontPageViewController: MeowFrontPageViewController!
  fileprivate private(set) var keyboardCheckerViewController: KeyboardCheckerViewController!
  fileprivate private(set) var qrCodeScannerViewController: InvoiceQRCodeScannerViewController!
  
  fileprivate var currentViewController: UIViewController? {
    willSet {
      // log to analytics helper
      if newValue != currentViewController {
        if newValue == frontPageViewController {
          AnalyticsHelper.instance().logSwitchToFrontPageEvent()
        } else if newValue == keyboardCheckerViewController {
          AnalyticsHelper.instance().logSwitchToKeyboardPageEvent()
        } else {
          AnalyticsHelper.instance().logSwitchToQRCodeScanPageEvent()
        }
      }
      // check if qrcode scanner
      if newValue == qrCodeScannerViewController {
        qrCodeScannerViewController.startCapturingQRCode()
      } else {
        qrCodeScannerViewController.stopCapturingQRCode()
      }
    }
  }
  
  public var presenter: MeowNavigationPresenter?
  
  // Getter
  fileprivate var childViewControllerSize: CGSize {
//    if UIApplication.shared.statusBarFrame.size.height > 20 {
//      // in call status
//      let height = view.bounds.height - (navigationBar.bounds.height - 20) - adBannerView.bounds.height
//      return CGSize(width: view.bounds.width, height: height)
//    } else {
      let height = view.bounds.height - navigationBar.bounds.height - adBannerView.bounds.height
      return CGSize(width: view.bounds.width, height: height)
//    }
  }
  
  // MARK: - Life Cycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    configureNavigationBar()
    configureADBannerView()
    configureContainerView()
    configureFrontPageViewController()
    configureKeyboardCheckerViewController()
    configureQRCodeScannerViewController()
    
    showAllChildVCs()
    showChild(viewController: frontPageViewController)
    
    view.backgroundColor = MeowInvoiceColor.lightBackgroundColor
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    presenter?.loadContent()
  }
  
  public override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  private func configureNavigationBar() {
    navigationBar = MeowNavigationBar(width: view.bounds.width)
    navigationBar.delegate = self
    navigationBar.anchor(to: view)
  }
  
  private func configureADBannerView() {
    adBannerView = GADBannerView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50))
    adBannerView.backgroundColor = .gray
    adBannerView.move(0, pointsBottomToAndInside: view).anchor(to: view)
    
    let request = GADRequest()
    adBannerView.adUnitID = SecretKey.adUnitID
    adBannerView.rootViewController = self
    adBannerView.load(request)
    adBannerView.delegate = self
  }
  
  private func configureContainerView() {
    containerView = UIScrollView(frame: CGRect(x: 0,
                                               y: navigationBar.bounds.height,
                                               width: childViewControllerSize.width,
                                               height: childViewControllerSize.height))
    containerView.anchor(to: view, below: adBannerView)
    containerView.contentSize = CGSize(width: childViewControllerSize.width * 3,
                                       height: childViewControllerSize.height)
    containerView.isPagingEnabled = true
    containerView.showsHorizontalScrollIndicator = false
    containerView.delegate = self
  }
  
  private func configureFrontPageViewController() {
    frontPageViewController = MeowFrontPageDefaultBuilder().buildMeowFrontPageModule() as! MeowFrontPageViewController
    frontPageViewController.view.frame.size = childViewControllerSize
  }
  
  private func configureKeyboardCheckerViewController() {
    keyboardCheckerViewController = KeyboardCheckerDefaultBuilder().buildKeyboardCheckerModule() as! KeyboardCheckerViewController
    keyboardCheckerViewController.view.frame.size = childViewControllerSize
    keyboardCheckerViewController.view.frame.origin.x = childViewControllerSize.width
  }
  
  private func configureQRCodeScannerViewController() {
    qrCodeScannerViewController = InvoiceQRCodeScannerDefaultBuilder().buildInvoiceQRCodeModule() as! InvoiceQRCodeScannerViewController
    qrCodeScannerViewController.view.frame.size = childViewControllerSize
    qrCodeScannerViewController.view.frame.origin.x = childViewControllerSize.width * 2
  }
  
  fileprivate func showAllChildVCs() {
    let vcs: [UIViewController] = [frontPageViewController, keyboardCheckerViewController, qrCodeScannerViewController].flatMap({ $0 })
    for vc in vcs {
      addChildViewController(vc)
      containerView.addSubview(vc.view)
      vc.view.move(0, pointsTopToAndInside: containerView)
      vc.didMove(toParentViewController: self)
    }
  }
  
  fileprivate func showChild(viewController: UIViewController) {
    switch viewController {
    case frontPageViewController:
      moveContainer(to: 0)
    case keyboardCheckerViewController:
      moveContainer(to: childViewControllerSize.width)
    case qrCodeScannerViewController:
      moveContainer(to: childViewControllerSize.width * 2)
    default:
      break
    }
  }
  
  private func moveContainer(to xOffset: CGFloat) {
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
      self?.containerView.contentOffset.x = xOffset
    }, completion: { [weak self] _ in
      self?.endTransition(xOffset: xOffset)
    })
  }
  
  public func updateNavigationController(with newStatusBarFrame: CGRect) {
    let statusBarFrameChangeAnimationTimeDuration: TimeInterval = 0.3
    UIView.animate(withDuration: statusBarFrameChangeAnimationTimeDuration) { [weak self] in
      guard let strongSelf = self else { return }
      if newStatusBarFrame.size.height > 20 {
        // in call status
        strongSelf.containerView.frame.size.height = strongSelf.childViewControllerSize.height - 20
        strongSelf.adBannerView.move(20, pointsBottomToAndInside: strongSelf.view)
      } else {
        strongSelf.containerView.frame.size.height = strongSelf.childViewControllerSize.height + 20
        strongSelf.adBannerView.move(-20, pointsBottomToAndInside: strongSelf.view)
      }
      strongSelf.frontPageViewController.view.frame.size = strongSelf.containerView.bounds.size
      strongSelf.frontPageViewController.rearrangeSubviews()
      strongSelf.keyboardCheckerViewController.view.frame.size = strongSelf.containerView.bounds.size
      strongSelf.keyboardCheckerViewController.rearrangeSubviews()
      strongSelf.qrCodeScannerViewController.view.frame.size = strongSelf.containerView.bounds.size
      strongSelf.qrCodeScannerViewController.rearrangeSubviews()
    }
  }
  
}

extension MeowNavigationController : MeowNavigationBarDelegate {
  
  public func meowNavigationBar(didChangeTo tab: MeowNavigationTab) {
    switch tab {
    case .frontPage: showChild(viewController: frontPageViewController)
    case .keyboard: showChild(viewController: keyboardCheckerViewController)
    case .scanQRCode: showChild(viewController: qrCodeScannerViewController)
    }
  }
  
  public func meowNavigationBarDidClickMoreOptionButton() {
    presenter?.presentMoreOptionView()
  }
  
}

extension MeowNavigationController : UIScrollViewDelegate {
  
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let xOffset = scrollView.contentOffset.x
    let progress = xOffset / childViewControllerSize.width
    navigationBar.updateTabIndicator(with: progress)
  }
  
  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    endTransition(xOffset: scrollView.contentOffset.x)
  }
  
  fileprivate func endTransition(xOffset: CGFloat) {
    if xOffset + 10 > childViewControllerSize.width * 2 {
      // scroll to qrcode scanner
      currentViewController = qrCodeScannerViewController
    } else if xOffset + 10 > childViewControllerSize.width {
      // keyboard
      currentViewController = keyboardCheckerViewController
    } else {
      // front page
      currentViewController = frontPageViewController
    }
  }
  
}

extension MeowNavigationController : GADBannerViewDelegate {
  
  public func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
    AnalyticsHelper.instance().logClickADEvent()
  }
  
}
