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

        public init(_ key: String, _ value: String) {
            self.init(key: key, value: value)
        }

        public init(_ key: String, _ value: Int) {
            self.init(key: key, value: value)
        }

        public init(_ key: String, _ value: Double) {
            self.init(key: key, value: value)
        }

        public init(_ key: String, _ value: Bool) {
            self.init(key: key, value: value)
        }

        public init<T>(_ key: String, _ value: Dictionary<String, T>) where T: CustomStringConvertible {
            self.init(key: key, value: value.mapValues(\.description))
        }

        public init<T>(_ key: String, _ value: Array<T>) where T: CustomStringConvertible {
            self.init(key: key, value: value.map(\.description))
        }

        public init(_ key: String, _ value: CustomStringConvertible) {
            self.init(key: key, value: value.description)
        }

        public init(_ key: String, _ value: String?) {
            self.init(key: key, value: value)
        }

        public init(_ key: String, _ value: Int?) {
            self.init(key: key, value: value)
        }

        public init(_ key: String, _ value: Double?) {
            self.init(key: key, value: value)
        }

        public init(_ key: String, _ value: Bool?) {
            self.init(key: key, value: value)
        }

        public init<T>(_ key: String, _ value: Dictionary<String, T>?) where T: CustomStringConvertible {
            self.init(key: key, value: value?.mapValues(\.description))
        }

        public init<T>(_ key: String, _ value: Array<T>?) where T: CustomStringConvertible {
            self.init(key: key, value: value?.map(\.description))
        }

        public init<T>(_ key: String, _ value: Dictionary<String, T?>) where T: CustomStringConvertible {
            self.init(key: key, value: value.compactMapValues { $0?.description })
        }

        public init<T>(_ key: String, _ value: Array<T?>) where T: CustomStringConvertible {
            self.init(key: key, value: value.compactMap { $0?.description })
        }

        public init(_ key: String, _ value: CustomStringConvertible?) {
            self.init(key: key, value: value?.description)
        }
    }
}

extension Request.Parameter: Equatable {}
extension Request.Parameter: Hashable {}
extension Request.Parameter: @unchecked Sendable {}
