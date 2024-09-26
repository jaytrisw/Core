import Combine

public extension Publisher {
    /// Combines the output of this publisher with a given value and returns a new publisher.
    ///
    /// This method transforms the output of the publisher by attaching the provided `other` value to each emitted element. The resulting publisher emits a `WithOutput` type that contains the external value (`other`) and the original output of the publisher. The failure type remains unchanged.
    ///
    /// - Parameters:
    ///   - other: The additional value to be combined with the publisher's output.
    /// - Returns: A publisher that emits `WithOutput` consisting of the provided `other` value and the output of the original publisher.
    ///
    /// ```swift
    /// let publisher = Just(42)
    /// let otherValue = "Context"
    ///
    /// let combined = publisher.with(otherValue)
    ///
    /// combined.sink { value in
    ///     print(value.other, value.output)  // Output: Context 42
    /// }
    /// ```
    /// - Version: 1.0
    func with<Other>(_ other: Other) -> Publishers.Map<Self, Publishers.WithOutput<Other, Output>> {
        map { .init(other, $0) }
    }
}
