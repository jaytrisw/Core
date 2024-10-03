import Foundation

extension String: @retroactive ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Character...) {
        self.init(elements.map { "\($0)" }.joined())
    }
}
