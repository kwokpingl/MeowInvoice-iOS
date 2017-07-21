import Foundation

extension Collection {
    
  /// Safe indexing of a collection type
  /// Will return a optional type of _Element of a collection.
  subscript(safe index: Index) -> _Element? {
    return index >= startIndex && index < endIndex ? self[index] : nil
  }
    
}