import Foundation

/// A marker protocol that provides methods for dynamically setting values using key paths.
///
/// The `KeyPathSettable` protocol allows both reference and value types to update their properties via key paths. For reference types, methods are provided to update properties directly or fluently using a chainable API. For value types, mutating methods are provided to facilitate updating properties.
///
/// - Version: 1.0
@_marker public protocol KeyPathSettable {}
