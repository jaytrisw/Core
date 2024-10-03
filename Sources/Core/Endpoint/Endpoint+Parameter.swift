import Foundation

public extension Endpoint {
    struct Parameter {
        public let label: String
        public let value: AnyHashable

        init<Value>(label: String, value: Value) where Value: Hashable, Value: Sendable {
            self.label = label
            self.value = .init(value)
        }

        public init<Value>(_ label: String, _ value: Value) where Value: Hashable, Value: Sendable {
            self.init(label: label, value: value)
        }
    }
}

extension Endpoint.Parameter: Equatable {}
extension Endpoint.Parameter: Hashable {}
extension Endpoint.Parameter: @unchecked Sendable {}
