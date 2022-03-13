import Foundation

extension Array {
    
    public mutating func reserveCapacity(_ minimumCapacity: UInt) {
        self.reserveCapacity(Int(minimumCapacity))
    }
    
}
