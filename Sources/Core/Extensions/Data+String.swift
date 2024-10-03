import Foundation

public extension Data {
    func string(using encoding: String.Encoding) -> String? {
        .init(data: self, encoding: encoding)
    }
}
