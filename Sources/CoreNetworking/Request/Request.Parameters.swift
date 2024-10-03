import Foundation

public extension Request {
    typealias Parameters = [Parameter]
}

public extension Request {
    struct Parameter {
        public let key: String
        public let value: AnyHashable

        init<Value>(key: String, value: Value) where Value: Hashable, Value: Sendable {
            self.key = key
            self.value = .init(value)
        }

        public init<Value>(_ key: String, _ value: Value) where Value: Hashable, Value: Sendable {
            self.init(key: key, value: value)
        }
    }
}

extension Request.Parameter: Equatable {}
extension Request.Parameter: Hashable {}
extension Request.Parameter: @unchecked Sendable {}
