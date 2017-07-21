import UIKit

extension UITableView {
    
  func register<T: UITableViewCell>(cellType: T.Type) {
    let className = cellType.className
    if Bundle.main.path(forResource: className, ofType: "nib") != nil {
      // register for nib
      let nib = UINib(nibName: className, bundle: nil)
      register(nib, forCellReuseIdentifier: className)
    } else {
      // register for class
      register(cellType, forCellReuseIdentifier: className)
    }
  }

  func register<T: UITableViewCell>(cellTypes: [T.Type]) {
    cellTypes.forEach { register(cellType: $0) }
  }

  func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
    return dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
  }
    
}