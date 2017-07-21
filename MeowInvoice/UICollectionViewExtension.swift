import Foundation
import UIKit

extension UICollectionView {
    
  /// Deselect all selected items of a collection view.
  /// You should need to reload data after this.
  /// Wont update ui for you.
  public func deselectSelectedItems() {
    guard let selectedIndexPaths = indexPathsForSelectedItems else { return }
    for indexPath in selectedIndexPaths {
      deselectItem(at: indexPath, animated: false)
    }
  }
    
  func register<T: UICollectionViewCell>(cellType: T.Type) {
    let className = cellType.className
    if Bundle.main.path(forResource: className, ofType: "nib") != nil {
      // register for nib
      let nib = UINib(nibName: className, bundle: nil)
      register(nib, forCellWithReuseIdentifier: className)
    } else {
      // register for class
      register(cellType, forCellWithReuseIdentifier: className)
    }
  }
    
  func register<T: UICollectionViewCell>(cellTypes: [T.Type]) {
    cellTypes.forEach { register(cellType: $0) }
  }
    
  func register<T: UICollectionReusableView>(reusableViewType: T.Type, of kind: String = UICollectionElementKindSectionHeader) {
    let className = reusableViewType.className
    if Bundle.main.path(forResource: className, ofType: "nib") != nil {
      // register for nib
      let nib = UINib(nibName: className, bundle: nil)
      register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: className)
    } else {
      // register for class
      register(reusableViewType, forSupplementaryViewOfKind: kind, withReuseIdentifier: className)
    }
  }
    
  func register<T: UICollectionReusableView>(reusableViewTypes: [T.Type], of kind: String = UICollectionElementKindSectionHeader) {
    reusableViewTypes.forEach { register(reusableViewType: $0, of: kind) }
  }

  func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
    return dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as! T
  }

  func dequeueReusableView<T: UICollectionReusableView>(with type: T.Type, for indexPath: IndexPath, of kind: String = UICollectionElementKindSectionHeader) -> T {
    return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.className, for: indexPath) as! T
  }
    
}