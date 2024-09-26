import Combine

public extension Publishers {

    /// A type that represents the combination of an additional value and the output from a publisher.
    ///
    /// `WithOutput` holds an additional value of type `Other` and the output from a publisher of type `Output`. It is used by the `with(_:)` method to package the additional value with each output from the original publisher.
    ///
    /// - Parameters:
    ///   - Other: The type of the additional value.
    ///   - Output: The type of the publisher's output.
    ///
    /// ### Example:
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
    @frozen
    struct WithOutput<Other, Output> {
        /// The additional value being combined with the publisher's output.
        public let other: Other

        /// The original output of the publisher.
        public let output: Output

        /// Initializes a new instance of `WithOutput`.
        ///
        /// - Parameters:
        ///   - other: The additional value to combine with the publisher's output.
        ///   - output: The output of the original publisher.
        public init(_ other: Other, _ output: Output) {
            self.other = other
            self.output = output
        }
    }
}
