import Foundation

public struct Media {
    
    // MARK: Properties
    public let key: String
    public let filename: String
    public let data: Data
    public let mimeType: MIMEType
    
    // MARK: Life Cycle
    public init(
        key: String,
        filename: String,
        data: Data,
        mimeType: MIMEType) {
            self.key = key
            self.filename = filename
            self.data = data
            self.mimeType = mimeType
        }
    
}

extension Media: Equatable {}
extension Media: Hashable {}
extension Media: Sendable {}
