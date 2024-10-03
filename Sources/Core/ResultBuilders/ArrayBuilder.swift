import Foundation

@resultBuilder
public enum ArrayBuilder<Element> {
    public static func buildPartialBlock(
        first: Element) -> Array<Element> {
            [first]
        }
    public static func buildPartialBlock(
        first: Array<Element>) -> Array<Element> {
            first
        }
    public static func buildPartialBlock(
        accumulated: Array<Element>,
        next: Element) -> Array<Element> {
            accumulated + [next]
        }
    public static func buildPartialBlock(
        accumulated: Array<Element>,
        next: Array<Element>) -> Array<Element> {
            accumulated + next
        }
    public static func buildBlock() -> Array<Element> {
        .empty
    }
    public static func buildEither(
        first: Array<Element>) -> Array<Element> {
            first
        }
    public static func buildEither(
        second: Array<Element>) -> Array<Element> {
            second
        }
    public static func buildIf(
        _ element: Array<Element>?) -> Array<Element> {
            guard let element else {
                return .empty
            }
            return element
        }
    public static func buildPartialBlock(
        first: Never) -> Array<Element> {
            // Fatal Error
        }
}
