import Foundation

public func set<Root: AnyObject, Value>(
    _ keyPath: ReferenceWritableKeyPath<Root, Value>,
    onObject object: Root) -> ((Value) -> Void) {
        return { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
