import Foundation

public extension String {
    static var uuid: String {
        UUID().uuidString
    }
}
