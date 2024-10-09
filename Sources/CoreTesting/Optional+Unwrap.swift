import Foundation

public extension Optional {
    func unwrap(
        _ message: @autoclosure () -> String = "",
        _ file: StaticString = #filePath,
        _ line: UInt = #line) -> Wrapped {
            guard case let .some(wrapped) = self else {
                return raise(.invalidArgumentException, message())
            }
            return wrapped
        }
}

public func weakCapture<Object: AnyObject, Value>(
    _ object: Object,
    return keyPath: KeyPath<Object, Value>,
    message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line) -> Value {
        scope { [weak object] in
            guard let object else {
                return raise(.objectNotAvailableException, message())
            }
            return object[keyPath: keyPath]
        }
    }

public func scope<T>(
    _ returning: T.Type = T.self,
    closure: () throws -> T) rethrows -> T {
        return try closure()
        }

public func raise<T>(
    _ name: NSExceptionName,
    _ message: @autoclosure () -> String,
    userInfo: [String: Any]? = .none) -> T {
        NSException(name: name, reason: message(), userInfo: userInfo).raise()

        fatalError(message())
    }
