import Foundation

public extension Array {
    /// Returns a new array by merging the elements of the current array with another array, ensuring uniqueness based on the specified key path.
    ///
    /// This method combines the elements of the current array with another array (`other`) and eliminates duplicates by keeping the last occurrence of elements based on the value of the specified key path. The merging is done using a dictionary where the keys are derived from the elements' key path values.
    ///
    /// - Parameters:
    ///   - keyPath: A key path that specifies the property of each element to be used as the key for uniqueness.
    ///   - other: The array to merge with the current array.
    /// - Returns: A new array containing the merged elements, with duplicates removed based on the specified key path value.
    ///
    /// - Complexity: O(n), where n is the total number of elements in both arrays.
    ///
    /// - Note: If multiple elements share the same key path value, the element from `other` will replace the one from the current array.
    ///
    /// ```swift
    /// struct Item: Hashable {
    ///     let id: Int
    ///     let name: String
    /// }
    ///
    /// let array1 = [Item(id: 1, name: "A"), Item(id: 2, name: "B")]
    /// let array2 = [Item(id: 2, name: "C"), Item(id: 3, name: "D")]
    ///
    /// let merged = array1.merging(\.id, array2)
    /// // merged: [Item(id: 1, name: "A"), Item(id: 2, name: "C"), Item(id: 3, name: "D")]
    /// ```
    ///
    /// - Version: 1.0
    func merging<Value: Hashable>(
        _ keyPath: KeyPath<Element, Value>,
        _ other: Self) -> Self {
            let combined = self + other
            let mergedDictionary = Dictionary(combined.map { ($0[keyPath: keyPath], $0) }, uniquingKeysWith: { _, new in new })

            return .init(mergedDictionary.values)
        }
}
