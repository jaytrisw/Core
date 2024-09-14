import Foundation

public extension Property {
    init(
        _ key: String,
        value: String) {
            self.init(key, value: .string(value))
        }

    init(
        _ key: String,
        value: Int) {
            self.init(key, value: .integer(value))
        }

    init(
        _ key: String,
        value: Double) {
            self.init(key, value: .double(value))
        }

    init(
        _ key: String,
        value: Bool) {
            self.init(key, value: .boolean(value))
        }

    init(
        _ key: String,
        value: Date) {
            self.init(key, value: .date(value))
        }

    init(
        _ key: String,
        value: URL) {
            self.init(key, value: .url(value))
        }

    init(
        _ key: String,
        value: [PropertyValue]) {
            self.init(key, value: .array(value))
        }

    init(
        _ key: String,
        value: [String: PropertyValue]) {
            self.init(key, value: .dictionary(value))
        }
}
