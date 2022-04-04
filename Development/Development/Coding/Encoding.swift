import Foundation
import Combine

public struct Encoding<Value> {
    
    public var encode: (Value, Encoder) throws -> Void
    
    public init(
        encode: @escaping (Value, Encoder) throws -> Void) {
            self.encode = encode
        }
    
}

// MARK: - Operators
public extension Encoding {
    
    static func combine(
        _ encodings: Self...) -> Encoding<Value> {
            return Encoding { value, encoder in
                try encodings.forEach { encoding in
                    try encoding.encode(value, encoder)
                }
            }
        }
    
    func pullback<NewValue>(
        _ transform: @escaping (NewValue) -> Value) -> Encoding<NewValue> {
            return Encoding<NewValue> { newValue, encoder in
                try self.encode(transform(newValue), encoder)
            }
        }
    
    func optional() -> Encoding<Value?> {
        return Encoding<Value?> { value, encoder in
            guard let value = value else {
                return
            }
            try self.encode(value, encoder)
        }
    }
    
    func replaceNil(
        with replacementValue: Value) -> Encoding<Value?> {
            return Encoding<Value?> { value, encoder in
                try self.encode(value ?? replacementValue, encoder)
            }
        }
    
    func withKey<Key: CodingKey>(
        _ key: Key) -> Encoding<Value> {
            return Encoding { value, encoder in
                var container = encoder.container(keyedBy: Key.self)
                try self.encode(value, container.superEncoder(forKey: key))
            }
        }
    
}

// MARK: - Encoder API
fileprivate extension Encoding {
    
    struct Proxy: Encodable {
        
        let value: Value
        let encoding: Encoding<Value>
        
        init(value: Value, encoding: Encoding<Value>) {
            self.value = value
            self.encoding = encoding
        }
        
        func encode(to encoder: Encoder) throws {
            try self.encoding.encode(value, encoder)
        }
        
    }
    
}

public extension TopLevelEncoder {
    
    func encode<Value>(
        _ value: Value,
        using encoding: Encoding<Value>) throws -> Output {
            try self.encode(Encoding<Value>.Proxy(value: value, encoding: encoding))
        }
    
}

// MARK: - Built-in encodings
public extension Encoding where Value: Encodable {
    
    static var singleValue: Encoding<Value> {
        return Encoding { value, encoder in
            var container = encoder.singleValueContainer()
            try container.encode(value)
        }
    }
    
    static var unkeyed: Encoding<Value> {
        return Encoding { value, encoder in
            var container = encoder.unkeyedContainer()
            try container.encode(value)
        }
    }
    
    static func withKey<Key: CodingKey>(
        _ key: Key) -> Encoding<Value> {
            return Encoding { value, encoder in
                var container = encoder.container(keyedBy: Key.self)
                try container.encode(value, forKey: key)
            }
        }
}

public extension Encoding where Value: Sequence {
    
    static func arrayOf(
        _ encoding: Encoding<Value.Element>) -> Encoding<Value> {
            return Encoding { value, encoder in
                var container = encoder.unkeyedContainer()
                for element in value {
                    try encoding.encode(element, container.superEncoder())
                }
            }
        }
    
}

public extension Encoding {
    
    static var nullValue: Encoding<Value> {
        return Encoding { _, encoder in
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
    
    static func nullValue<Key: CodingKey>(
        key: Key) -> Encoding<Value> {
            return Encoding { _, encoder in
                var container = encoder.container(keyedBy: Key.self)
                try container.encodeNil(forKey: key)
            }
        }
    
}
//
//// MARK: - Property Wrapper
//@propertyWrapper
//public struct UsesEncoding<Value>: Encodable {
//    public let wrappedValue: Value
//    public let encoding: Encoding<Value>
//    
//    public init(wrappedValue: Value, _ encoding: Encoding<Value>) {
//        self.wrappedValue = wrappedValue
//        self.encoding = encoding
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        try encoding.encode(wrappedValue, encoder)
//    }
//    
//}
