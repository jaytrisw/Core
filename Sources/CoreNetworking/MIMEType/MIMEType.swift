import Foundation

public struct MIMEType {
    
    // MARK: Properties
    public let type: String
    public let subtype: String
    
    // MARK: Life Cycle
    public init(
        type: String,
        subtype: String) {
            self.type = type
            self.subtype = subtype
        }

}

extension MIMEType: CustomStringConvertible {
    
    public var description: String {
        return [
            self.type,
            self.subtype
        ].joined(separator: "/")
    }
    
}

extension MIMEType: Equatable {}
extension MIMEType: Hashable {}
extension MIMEType: Sendable {}
