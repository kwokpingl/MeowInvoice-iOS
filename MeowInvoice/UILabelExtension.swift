import UIKit

extension UILabel {
    
  @discardableResult
  func changeFont(to font: UIFont) -> Self {
    self.font = font
    return self
  }
  
  @discardableResult
  func changeFontSize(to size: CGFloat) -> Self {
    guard let font = self.font else { return self }
    self.font = UIFont.init(name: font.fontName, size: size)
    return self
  }
  
  @discardableResult
  func changeTextColor(to color: UIColor) -> Self {
    self.textColor = color
    return self
  }
  
  @discardableResult
  func changeTextAlignment(to alignment: NSTextAlignment) -> Self {
    self.textAlignment = alignment
    return self
  }
  
  @discardableResult
  func changeNumberOfLines(to lines: Int) -> Self {
    self.numberOfLines = lines
    return self
  }
  
  @discardableResult
  func addTextShadow(shadowOpacity: Float, shadowRadius: CGFloat, shadowColor: UIColor, shadowOffset: CGSize) -> Self {
    layer.shadowOpacity = shadowOpacity
    layer.shadowRadius = shadowRadius
    layer.shadowColor = shadowColor.cgColor
    layer.shadowOffset = shadowOffset
    return self
  }
    
}
