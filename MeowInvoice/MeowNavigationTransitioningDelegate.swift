//
//  MeowNavigationTransitioningDelegate.swift
//  MeowInvoice
//
//  Created by David on 2017/7/6.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

final public class MeowNavigationTransitioningDelegate: UIPercentDrivenInteractiveTransition {
  
  fileprivate var isInteractive = false
  fileprivate var isPresenting = false
  public var animationDuration: TimeInterval = 0.3
  
  public var presentingViewController: UIViewController! {
    didSet {
      exitingEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self,
                                                            action: #selector(MeowNavigationTransitioningDelegate.handleExitingEdgeGesture(_:)))
      exitingEdgeGesture.edges = .left
      presentingViewController.transitioningDelegate = self
      presentingViewController.view.addGestureRecognizer(exitingEdgeGesture)
    }
  }
  
  fileprivate var exitingEdgeGesture: UIScreenEdgePanGestureRecognizer!
  @objc fileprivate func handleExitingEdgeGesture(_ gesture: UIScreenEdgePanGestureRecognizer) {
    
    // get offset
    let translation = gesture.translation(in: presentingViewController.view)
    // calculate the progress
    // max from x to 0 to prevent negative progress
    // min from x to 1 is to prevent progress to exceed 0~1
    let progress = min(max((translation.x / UIScreen.main.bounds.width), 0), 1)
    
    // handle gesture
    switch gesture.state {
    case .began:
      // while began, mark interactive flag to true
      isInteractive = true
      // start the dismiss work
      presentingViewController.dismiss(animated: true, completion: nil)
    case .changed:
      // update ui according to the progress
      update(progress)
    default:
      // finished, cancelled, interrupted
      isInteractive = false
      // check the progress, larger than 50% will finish the transition
      progress > 0.4 ? finish() : cancel()
    }
  }
  
}

extension MeowNavigationTransitioningDelegate : UIViewControllerTransitioningDelegate {
  
  public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    isPresenting = false
    return self
  }
  
  public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    isPresenting = true
    return self
  }
  
  public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return isInteractive ? self : nil
  }
  
  public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return isInteractive ? self : nil
  }
  
}

extension MeowNavigationTransitioningDelegate : UIViewControllerAnimatedTransitioning {
  
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return animationDuration
  }
  
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let container = transitionContext.containerView
    let screen: (from: UIViewController, to: UIViewController) =
      (transitionContext.viewController(forKey: .from)!, transitionContext.viewController(forKey: .to)!)
    
    let mainViewController = isPresenting ? screen.from : screen.to
    let presentingViewController = isPresenting ? screen.to : screen.from
    
    let duration = transitionDuration(using: transitionContext)
    
    container.addSubview(mainViewController.view)
    container.addSubview(presentingViewController.view)
    
    if isPresenting {
      onStageMain(mainViewController)
      offStagePresenting(presentingViewController)
    } else {
      offStageMain(mainViewController)
      onStagePresenting(presentingViewController)
    }
    
    UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
      guard let strongSelf = self else { return }
      if strongSelf.isPresenting {
        strongSelf.offStageMain(mainViewController)
        strongSelf.onStagePresenting(presentingViewController)
      } else {
        strongSelf.onStageMain(mainViewController)
        strongSelf.offStagePresenting(presentingViewController)
      }
    }, completion: { done in
      if transitionContext.transitionWasCancelled {
        // transition was cancelled, not completing the transition
        transitionContext.completeTransition(false)
        // from view is still in presenting
        screen.from.view.transform = CGAffineTransform.identity
        UIApplication.shared.keyWindow?.addSubview(screen.from.view)
      } else {
        // transition completed
        transitionContext.completeTransition(true)
        screen.to.view.transform = CGAffineTransform.identity
        UIApplication.shared.keyWindow?.addSubview(screen.to.view)
        if !self.isPresenting {
          // if not presenting and transition complete, remove transitioning delegate
          presentingViewController.transitioningDelegate = nil
        }
      }
    })
  }
  
  private func onStageMain(_ viewController: UIViewController) {
    viewController.view.alpha = 1
    viewController.view.transform = CGAffineTransform.identity
  }
  
  private func offStageMain(_ viewController: UIViewController) {
    viewController.view.alpha = 0.7
    let translation = CGAffineTransform(translationX: -90, y: 0)
    viewController.view.transform = translation
  }
  
  private func onStagePresenting(_ viewController: UIViewController) {
    viewController.view.transform = CGAffineTransform.identity
  }
  
  private func offStagePresenting(_ viewController: UIViewController) {
    let translation = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
    viewController.view.transform = translation
  }
  
}
