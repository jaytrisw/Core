import Foundation
import Combine

public struct Decoding<Value> {
    
    public var decode: (Decoder) throws -> Value
    
    public init(
        decode: @escaping (Decoder) throws -> Value) {
            self.decode = decode
        }
    
}

// MARK: - Operators
public extension Decoding {
    
    func map<NewValue>(
        _ transform: @escaping (Value) -> NewValue) -> Decoding<NewValue> {
            return Decoding<NewValue> { newValue in
                try transform(self.decode(newValue))
            }
        }
    
    func replaceNil<T>(
        with defaultValue: T) -> Decoding<T> where Value == T? {
            self.map { $0 ?? defaultValue }
        }
    
}

// MARK: - Decoder API
fileprivate extension Decoding {
    
    struct Proxy: Decodable {
        
        let decoder: Decoder
        
        init(from decoder: Decoder) {
            self.decoder = decoder
        }
        
        func decode<Value>(
            using decoding: Decoding<Value>) throws -> Value {
                try decoding.decode(self.decoder)
            }
        
    }
    
}

public extension TopLevelDecoder {
    
    func decode<Value>(
        _ input: Input,
        using decoding: Decoding<Value>) throws -> Value {
             try self.decode(Decoding<Value>.Proxy.self, from: input)
                .decode(using: decoding)
        }
    
}

// MARK: - Build-in decodings
public extension Decoding where Value: Decodable {
    
    static var singleValue: Decoding<Value> {
        return Decoding { decoder in
            let container = try decoder.singleValueContainer()
            return try container.decode(Value.self)
        }
    }
    
    static var unkeyed: Decoding<Value> {
        return Decoding { decoder in
            var container = try decoder.unkeyedContainer()
            return try container.decode(Value.self)
        }
    }
    
    static func withKey<Key: CodingKey>(
        _ key: Key) -> Decoding<Value> {
            return Decoding { decoder in
                let container = try decoder.container(keyedBy: Key.self)
                return try container.decode(Value.self, forKey: key)
            }
        }
    
    static var optionalUnkeyed: Decoding<Value?> {
        return Decoding<Value?> { decoder in
            var container = try decoder.unkeyedContainer()
            return try container.decodeIfPresent(Value.self)
        }
    }
    
    static func optionalWithKey<Key: CodingKey>(
        _ key: Key) -> Decoding<Value?> {
            return Decoding<Value?> { decoder in
                let container = try decoder.container(keyedBy: Key.self)
                return try container.decodeIfPresent(Value.self, forKey: key)
            }
        }
    
    static var array: Decoding<[Value]> {
        return Decoding<Value>
            .arrayOf(.singleValue)
    }
    
}

public extension Decoding {
    
    func withKey<Key: CodingKey>(
        _ key: Key) -> Decoding<Value> {
            return Decoding { decoder in
                let container = try decoder.container(keyedBy: Key.self)
                return try self.decode(container.superDecoder(forKey: key))
            }
        }
    
    func optionalWithKey<Key: CodingKey>(
        _ key: Key) -> Decoding<Value?> {
            return Decoding<Value?> { decoder in
                let container = try decoder.container(keyedBy: Key.self)
                guard container.contains(key) else {
                    return nil
                }
                return try self.decode(container.superDecoder(forKey: key))
            }
        }
    
}

// MARK: - Collections
public extension Decoding {
    
    static func arrayOf(
        _ decoding: Self) -> Decoding<[Value]> {
            return Decoding<[Value]> { decoder in
                var container = try decoder.unkeyedContainer()
                var result: [Value] = []
                while !container.isAtEnd {
                    try result.append(decoding.decode(container.superDecoder()))
                }
                return result
            }
        }
    
}
