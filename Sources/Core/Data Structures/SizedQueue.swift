import Foundation

public struct SizedQueue<Element> {
    
    // MARK: Properties
    private(set) public var storage: Queue<Element>
    private let maximumCapacity: UInt
    
    // MARK: Life Cycle
    public init(maximumCapacity: UInt) {
        self.maximumCapacity = maximumCapacity
        self.storage = []
        self.storage.reserveCapacity(minimumCapacity: maximumCapacity)
    }
    
    public mutating func enqueue(_ element: Element) {
        if self.storage.count >= self.maximumCapacity {
            self.storage.dequeue()
        }
        self.storage.enqueue(element)
    }
    
    @discardableResult
    public mutating func dequeue() -> Element? {
        return self.storage.dequeue()
    }
    
}
