import Foundation

/// A marker protocol used to identify standard library primitive types.
///
/// Types conforming to this protocol can be handled by strategies that operate on common primitive types
///
/// - Version: 1.0
@_marker public protocol StandardLibraryPrimitive {}

extension Int: StandardLibraryPrimitive {}
extension Int16: StandardLibraryPrimitive {}
extension Int32: StandardLibraryPrimitive {}
extension Int64: StandardLibraryPrimitive {}
extension String: StandardLibraryPrimitive {}
extension Bool: StandardLibraryPrimitive {}
extension Double: StandardLibraryPrimitive {}
extension Float: StandardLibraryPrimitive {}
extension Date: StandardLibraryPrimitive {}
extension Data: StandardLibraryPrimitive {}
extension Array: StandardLibraryPrimitive where Element: StandardLibraryPrimitive {}
extension Dictionary: StandardLibraryPrimitive where Key: StandardLibraryPrimitive, Value: StandardLibraryPrimitive {}
