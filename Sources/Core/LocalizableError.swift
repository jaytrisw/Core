import Foundation

public struct LocalizableError {
    public let titleKey: String
    public let messageKey: String
    public let error: Error?

    public init(_ titleKey: String, messageKey: String, error: Error? = nil) {
        self.titleKey = titleKey
        self.messageKey = messageKey
        self.error = error
    }
}

extension LocalizableError: Error {}
extension LocalizableError: Sendable {}
