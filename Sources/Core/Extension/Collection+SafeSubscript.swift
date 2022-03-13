import Foundation

extension Collection {
    
    public func element(at index: Self.Index) -> Element? {
        return self[safeIndex: index]
    }
    
    public subscript(safeIndex index: Self.Index) -> Element? {
        guard index >= self.startIndex, index < self.endIndex else {
            return nil
        }
        
        return self[index]
    }
    
}
