//
//  UIViewExtension.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/14.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

extension UIView {
  
  func applyCircleShadow(shadowRadius: CGFloat = 2,
                         shadowOpacity: Float = 0.3,
                         shadowColor: UIColor = UIColor.black,
                         shadowOffset: CGSize = CGSize.zero) {
    layer.cornerRadius = frame.size.height / 2
    layer.masksToBounds = false
    layer.shadowColor = shadowColor.cgColor
    layer.shadowOffset = shadowOffset
    layer.shadowRadius = shadowRadius
    layer.shadowOpacity = shadowOpacity
  }
  
  func applyShadow(shadowRadius: CGFloat, shadowOpacity: Float, shadowColor: UIColor, shadowOffset: CGSize) {
    layer.shadowColor = shadowColor.cgColor
    layer.shadowOffset = shadowOffset
    layer.shadowRadius = shadowRadius
    layer.shadowOpacity = shadowOpacity
  }
  
  /// Can anchor self to a view
  ///
  /// A reverse thought of adding a subview
  @discardableResult func anchor(to view: UIView?) -> Self {
    view?.addSubview(self)
    return self
  }
  
  /// Anchor view to a view and below a subview on the view.
  ///
  /// - Parameters:
  ///   - view: a view to anchor on to
  ///   - below: a subview on the view
  @discardableResult func anchor(to view: UIView?, below: UIView) -> Self {
    view?.insertSubview(self, belowSubview: below)
    return self
  }
  
  /// Anchor view to a view and above a subview on the view.
  ///
  /// - Parameters:
  ///   - view: a view to anchor on to
  ///   - above: a subview on the view
  @discardableResult func anchor(to view: UIView?, above: UIView) -> Self {
    view?.insertSubview(self, aboveSubview: above)
    return self
  }
  
  /// Hide view
  func hide() {
    self.isHidden = true
  }
  
  /// Show view
  func show() {
    self.isHidden = false
  }
  
  /// Make a view center horizontally to superview.
  ///
  /// Only works if the view has a superview
  func centerHorizontallyToSuperview() {
    if let superview = self.superview {
      self.center.x = superview.bounds.midX
    }
  }
  
  /// Show border
  func showGreenBorder() {
    self.layer.borderWidth = 1.0
    self.layer.borderColor = UIColor.green.cgColor
  }
  
  /// Show border
  func showRedBorder() {
    self.layer.borderWidth = 1.0
    self.layer.borderColor = UIColor.red.cgColor
  }
  
  /// Show border
  func showBlueBorder() {
    self.layer.borderWidth = 1.0
    self.layer.borderColor = UIColor.blue.cgColor
  }
  
  /// To check if cgpoint is inside the view
  func containsPoint(_ point: CGPoint) -> Bool {
    return self.bounds.contains(point)
  }
  
  /// Get bounds' center x.
  /// Its different from center.x, because center.x is according to frame
  var centerXOfBounds: CGFloat {
    return bounds.midX
  }
  
  /// Get bounds' center y.
  /// Its different from center.y, because center.y is according to frame
  var centerYOfBounds: CGFloat {
    return bounds.midY
  }
  
}

extension UIView {
  
  @discardableResult func equalTop(to view: UIView) -> Self {
    self.frame.origin.y = view.frame.origin.y
    return self
  }
  
  @discardableResult func equalLeft(to view: UIView) -> Self {
    self.frame.origin.x = view.frame.origin.x
    return self
  }
  
  @discardableResult func equalRight(to view: UIView) -> Self {
    self.frame.origin.x = view.frame.maxX - self.bounds.width
    return self
  }
  
  @discardableResult func equalBottom(to view: UIView) -> Self {
    self.frame.origin.y = view.frame.maxY - self.bounds.height
    return self
  }
  
  /// Move below given point and view
  @discardableResult func move(_ point: CGFloat, pointBelow view: UIView) -> Self {
    self.frame.origin.y = point.point(below: view)
    return self
  }
  
  /// Move below given point and view
  @discardableResult func move(_ point: CGFloat, pointTopOf view: UIView) -> Self {
    self.frame.origin.y = view.frame.origin.y - self.bounds.height - point
    return self
  }
  
  /// Center x inside given view
  @discardableResult func centerX(inside view: UIView) -> Self {
    self.center.x = view.bounds.midX
    return self
  }
  
  /// Center y inside given view
  @discardableResult func centerY(inside view: UIView) -> Self {
    self.center.y = view.bounds.midY
    return self
  }
  
  @discardableResult func centerX(to view: UIView) -> Self {
    self.center.x = view.center.x
    return self
  }
  
  @discardableResult func centerY(to view: UIView) -> Self {
    self.center.y = view.center.y
    return self
  }
  
  /// Move view in view to its right
  /// This is used when you want to arrange a view to the right side inside the view.
  @discardableResult func move(_ point: CGFloat, pointsTrailingToAndInside view: UIView) -> Self {
    self.frame.origin.x = view.bounds.width - self.bounds.width - point
    return self
  }
  
  @discardableResult func move(_ point: CGFloat, pointsLeadingToAndInside view: UIView) -> Self {
    self.frame.origin.x = point
    return self
  }
  
  @discardableResult func move(_ point: CGFloat, pointsBottomToAndInside view: UIView) -> Self {
    self.frame.origin.y = view.bounds.height - self.bounds.height - point
    return self
  }
  
  @discardableResult func move(_ point: CGFloat, pointsTopToAndInside view: UIView) -> Self {
    self.frame.origin.y = point
    return self
  }
  
  /// Move view in view's right
  /// This is used to move to a view's right, not inside the view.
  @discardableResult func move(_ point: CGFloat, pointsRightFrom view: UIView) -> Self {
    self.frame.origin.x = view.frame.maxX + point
    return self
  }
  
  @discardableResult func move(_ point: CGFloat, pointsLeftFrom view: UIView) -> Self {
    self.frame.origin.x = view.frame.origin.x - self.bounds.width - point
    return self
  }
  
  @discardableResult
  func change(width: CGFloat) -> Self {
    frame.size.width = width
    return self
  }
  
  @discardableResult
  func change(height: CGFloat) -> Self {
    frame.size.height = height
    return self
  }
  
  @discardableResult
  func change(cornerRadius: CGFloat) -> Self {
    layer.cornerRadius = cornerRadius
    return self
  }
  
  @discardableResult
  func changeCircleRadius() -> Self {
    layer.cornerRadius = bounds.width / 2
    return self
  }
  
  @discardableResult
  func clipedToBounds() -> Self {
    clipsToBounds = true
    return self
  }
  
  @discardableResult
  func change(borderWidth: CGFloat) -> Self {
    layer.borderWidth = borderWidth
    return self
  }
  
  @discardableResult
  func change(borderColor: UIColor) -> Self {
    layer.borderColor = borderColor.cgColor
    return self
  }
  
}

extension UIView {
  
  /// Get super view's view controller
  var superViewController: UIViewController? {
    return self.superview?.next as? UIViewController
  }
  
  func removeAllSubviews() {
    subviews.forEach { $0.removeFromSuperview() }
  }
  
  func screenShot(width: CGFloat) -> UIImage? {
    let imageBounds = CGRect(origin: CGPoint.zero,
                             size: CGSize(width: width, height: bounds.size.height * (width / bounds.size.width)))
    
    UIGraphicsBeginImageContextWithOptions(imageBounds.size, true, 0)
    drawHierarchy(in: imageBounds, afterScreenUpdates: true)
    
    var image: UIImage?
    guard let contextImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
    guard let cgImage = contextImage.cgImage else { return nil }
    
    image = UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: contextImage.imageOrientation)
    
    UIGraphicsEndImageContext()
    
    return image
  }
  
  func screenShot() -> UIImage? {
    return screenShot(width: bounds.width)
  }
  
}
