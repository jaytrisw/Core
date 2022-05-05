import Foundation

public extension AdditiveArithmetic {
    
    @discardableResult
    func adding(_ value: Self) -> Self {
        return self + value
    }
    
    @discardableResult
    func subtracting(_ value: Self) -> Self {
        return self - value
    }
    
}

public extension Numeric {
    
    @discardableResult
    func multiplying(_ value: Self) -> Self {
        return self * value
    }
    
}

public extension FloatingPoint {

    @discardableResult
    func dividing(_ value: Self) -> Self {
        return self / value
    }
    
}

