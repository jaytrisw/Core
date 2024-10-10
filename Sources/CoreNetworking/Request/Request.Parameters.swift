import Foundation

public extension Request {
    typealias Parameters = [Parameter]
}

public extension Request {
    struct Parameter {
        public let key: String
        public let value: AnyHashable

        init<Value>(key: String, value: Value) where Value: Hashable {
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

        @_disfavoredOverload
        public init<T>(_ key: String, _ value: Dictionary<String, T>) where T: CustomStringConvertible {
            self.init(key: key, value: value.mapValues(\.description))
        }

        @_disfavoredOverload
        public init<T>(_ key: String, _ value: Array<T>) where T: CustomStringConvertible {
            self.init(key: key, value: value.map(\.description))
        }

        @_disfavoredOverload
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

        @_disfavoredOverload
        public init<T>(_ key: String, _ value: Dictionary<String, T>?) where T: CustomStringConvertible {
            self.init(key: key, value: value?.mapValues(\.description))
        }

        @_disfavoredOverload
        public init<T>(_ key: String, _ value: Array<T>?) where T: CustomStringConvertible {
            self.init(key: key, value: value?.map(\.description))
        }

        @_disfavoredOverload
        public init<T>(_ key: String, _ value: Dictionary<String, T?>) where T: CustomStringConvertible {
            self.init(key: key, value: value.compactMapValues { $0?.description })
        }

        @_disfavoredOverload
        public init<T>(_ key: String, _ value: Array<T?>) where T: CustomStringConvertible {
            self.init(key: key, value: value.compactMap { $0?.description })
        }

        @_disfavoredOverload
        public init(_ key: String, _ value: CustomStringConvertible?) {
            self.init(key: key, value: value?.description)
        }

        public init(_ key: String, _ value: Request.Parameters) {
            self.init(key: key, value: value.compactMap { Request.Parameter(key: $0.key, value: $0.value) })
        }
    }
}

extension Request.Parameter: Equatable {}
extension Request.Parameter: Hashable {}
extension Request.Parameter: @unchecked Sendable {}
