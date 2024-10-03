import Foundation

public struct Success<T: Decodable> {
    
    // MARK: Properties
    public var value: T
    public var response: Request.Response?
    
    // MARK: Life Cycle
    init(
        value: T,
        response: Request.Response?) {
            self.value = value
            self.response = response
        }
    
}
