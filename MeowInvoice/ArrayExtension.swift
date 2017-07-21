import Foundation

extension Array {
    
  /// You can get a random element in this array
  ///
  /// - Returns: any element in this array, return nil if this array doesn't have anything in it.
  func random() -> Element? {
    guard count > 0 else { return nil }
    let index = Int.random() % self.count
    return self[index]
  }
    
  @discardableResult
  mutating func popFirst() -> Element? {
    guard count > 0 else { return nil }
    return remove(at: 0)
  } 
    
}