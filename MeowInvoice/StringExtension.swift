import Foundation
import UIKit

extension String {
	
	func last(_ lastCount: Int) -> String {
    return substring(from: index(endIndex, offsetBy: -lastCount))
  }
  
  var isNumeric: Bool {
      return Double(self) != nil
  }
  
  func trimFirst(_ offset: Int) -> String {
    return substring(from: index(startIndex, offsetBy: offset))
  }
  
  func string(from: Int, to: Int) -> String {
    let start = index(startIndex, offsetBy: from)
    let end = index(startIndex, offsetBy: to + 1)
    return substring(with: start..<end)
  }
	
	/// To check if this is a valid url string
	var isValidURLString: Bool {
		return (URL(string: self) != nil)
	}
	
	/// To get a Int value from this string
	var int: Int? {
		return Int(self)
	}
	
	/// Encode the string, will return a utf8 encoded string.
	/// 
	/// If fail to generate a encoded string, will return a uuid string
	var uuidEncode: String {
		if let data = self.data(using: String.Encoding.utf8, allowLossyConversion: true) {
			return ("\(data)").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "")
		} else {
			return UUID().uuidString
		}
	}
    
    /// If the url does have unicode charaters, you will have to encode it first.
    var encodedURL: String? {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
	
	/// Check if this string is an valid email string
	var isValidEmail: Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailTest.evaluate(with: self)
	}
	
	/// Check if this string is an valid TW mobile number
	var isTaiwanMobileNumber: Bool {
		let mobileRegex = "^\\+?886\\d{9}"
		let mobileTest = NSPredicate(format: "SELF MATCHES %@", mobileRegex)
		return mobileTest.evaluate(with: self)
	}
	
	func toTaiwanMobileNumber() -> String? {
		if self.isTaiwanMobileNumber {
			if self.characters.first == "+" {
				return "0" + self.substring(from: self.characters.index(self.startIndex, offsetBy: 4))
			} else {
				return "0" + self.substring(from: self.characters.index(self.startIndex, offsetBy: 3))
			}
		} else {
			return nil
		}
	}
	
	/// Check if this string is an valid mobile number string
	var isValidMobileNumber: Bool {
		let mobileRegex = "09\\d{8}"
		let mobileTest = NSPredicate(format: "SELF MATCHES %@", mobileRegex)
		return mobileTest.evaluate(with: self)
	}
	
	/// Return a NSURL if the string is a valid url string
	var url: URL? {
		return URL(string: self)
	}
	
	/// Get charater at index
	func charaterAtIndex(_ index: Int) -> String? {
		guard index < self.characters.count else { return nil }
		let startIndex = self.characters.index(self.startIndex, offsetBy: index)
		let range = startIndex...startIndex
		return self[range]
	}

	/// get preferred text width by given font size
	func preferredTextWidth(constraintByFontSize size: CGFloat) -> CGFloat {
		let attrString = NSAttributedString(string: self, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: size)])
		let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: size)
		let boundingBox = attrString.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
		return ceil(boundingBox.width)
	}
	
	/// Get preferred text height by given width
	func preferredTextHeight(withConstrainedWidth width: CGFloat, andFontSize size: CGFloat) -> CGFloat {
		let attrString = NSAttributedString(string: self, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: size)])
		let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
		let boundingBox = attrString.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
		return ceil(boundingBox.height)
	}
	
	/// Get preferred text width by given height
	func preferredTextWidth(withConstrainedHeight height: CGFloat, andFontSize size: CGFloat) -> CGFloat {
		let attrString = NSAttributedString(string: self, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: size)])
		let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
		let boundingBox = attrString.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
		return ceil(boundingBox.width)
  }
    
  func bounds(for width: CGFloat, fontSize: CGFloat) -> CGRect {
    let defaultFont = UIFont.systemFont(ofSize: fontSize)
    return bounds(for: width, font: defaultFont)
  }

  func bounds(for width: CGFloat, font: UIFont) -> CGRect {
    let nsString = (self as NSString)
    let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    let options: NSStringDrawingOptions = [.usesLineFragmentOrigin]
    let attributes: [String : Any] = [NSFontAttributeName: font]
    return nsString.boundingRect(with: size,
                                 options: options,
                                 attributes: attributes,
                                 context: nil)
  }
    
	/// Transform string into secret dot text
	var dottedString: String {
		let count = self.characters.count
		var dottedString = ""
		for _ in 1...count {
			dottedString += "●"
		}
		return dottedString
	}
	
}