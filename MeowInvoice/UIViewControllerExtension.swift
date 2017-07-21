import UIKit

public extension UIViewController {
    
	/// Async present a view controller. 
	/// Will be executed in main thread.
	///
	/// - Parameters:
	///   - viewControllerToPresent: a view controller to present.
	///   - animated: determine whetehr present it with animation.
	///   - completion: a completion call back, default is nil.
	public func asyncPresent(_ viewControllerToPresent: UIViewController?, animated: Bool, completion: (() -> Void)? = nil) {
		Queue.main {
			if let viewControllerToPresent = viewControllerToPresent {
				self.present(viewControllerToPresent, animated: animated, completion: completion)
			}
		}
	}
	
  /// Async dismiss a view controller.
  /// Will be executed in main thread.
	///
	/// - Parameters:
	///   - animated: determine whetehr dismiss it with animation.
	///   - completion: a completion call back, default is nil.
	public func asyncDismiss(_ animated: Bool, completion: (() -> Void)? = nil) {
		Queue.main {
			self.dismiss(animated: animated, completion: {
        // after dismiss, set transitioning delegate to nil to avoid crash.
				self.transitioningDelegate = nil
				completion?()
			})
		}
	}
	
	/// Hide keyboard showing on view controller
	public func hideKeyboard() {
		view.endEditing(true)
	}
    
    /// Dismiss modal stack and return to root view controller
  /// **Caution**: Will dismiss all view controllers that are presented in modal style.
  ///
  /// - Parameters:
  ///   - animated: dismiss with animation.
  ///   - completion: completion call back, default is nil.
  public func dismissModalStackAndReturnToRoot(animated: Bool, completion: (() -> Void)? = nil) {
    var vc = self.presentingViewController
    // find the view controller that is presenting current view controller.
    while vc?.presentingViewController != nil {
      // try to find the previous view controller.
      vc = vc?.presentingViewController!
    }
    vc?.asyncDismiss(animated, completion: completion)
    if vc == nil {
      completion?()
    }
  }
    
  /// Dismiss modal stack.
  /// **Caution**: Will dismiss all view controllers that are presented in modal style.
  ///
  /// - Parameters:
  ///   - animated: dismiss with animation.
  ///   - completion: completion call back, default is nil.
  public func dismissModalStack(animated: Bool, completion: (() -> Void)? = nil) {
    var vc = self.presentedViewController
    // find the view controller that current view controller had presented.
    while vc?.presentedViewController != nil {
      vc = vc?.presentedViewController!
    }
    vc?.dismissModalStackAndReturnToRoot(animated: animated, completion: completion)
    if vc == nil {
      completion?()
    }
  }
    
}
