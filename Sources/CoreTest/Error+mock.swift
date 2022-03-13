import Foundation

extension Swift.Error {
    
    public static func mock(
        domain: String = "ERROR",
        code: Int = Int.max,
        userInfo: [String: Any]? = nil) -> NSError {
            return NSError(domain: domain, code: code, userInfo: userInfo)
        }
    
}
