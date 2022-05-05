import Foundation

public struct Queue<Element> {
    
    // MARK: Properties
    private var storage: Array<Element>
    
    public var count: Int {
        return self.storage.count
    }
    
    public var isEmpty: Bool {
        return self.storage.isEmpty
    }
    
    public mutating func enqueue(_ element: Element) {
        self.storage.append(element)
    }
    
    @discardableResult
    public mutating func dequeue() -> Element? {
        guard self.isEmpty == false else {
            return nil
        }
        return self.storage.removeFirst()
    }
    
    public var peak: Element? {
        return self.storage.first
    }
    
    public mutating func reserveCapacity(minimumCapacity: UInt) {
        self.storage.reserveCapacity(minimumCapacity)
    }
    
}

extension Queue: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: Element...) {
        self.storage = elements
    }
    
}

extension Queue: Sequence {
    
    public func makeIterator() -> Array<Element>.Iterator {
        return self.storage.makeIterator()
    }
    
}
