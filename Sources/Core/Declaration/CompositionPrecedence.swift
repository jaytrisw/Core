import Foundation

precedencegroup CompositionPrecedence {
    associativity: left
}

infix operator ..: CompositionPrecedence

public func .. <T, U, V>(lhs: @escaping (T) -> U, rhs: @escaping (U) -> V) -> (T) -> V {
    return { rhs(lhs($0)) }
}
