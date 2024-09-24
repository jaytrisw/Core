import CoreTracking
import FirebaseCore
import FirebaseAnalytics

public actor FirebaseTracking {
    init() {
        
    }
}

extension FirebaseTracking: Trackable {
    public nonisolated func track(
        _ event: any EventRepresentable,
        properties: [any PropertyRepresentable]) {
            Analytics.logEvent(event.name, parameters: properties.firebaseDictionary)
    }
}

extension Array where Element == PropertyRepresentable {
    var dictionary: [String: PropertyValue] {
        .init(map { ($0.key, $0.value) }, uniquingKeysWith: { _, new in new })
    }
}

extension Array where Element == PropertyRepresentable {
    var firebaseDictionary: [String: Any] {
        dictionary
            .mapValues(\.any)
    }
}

extension PropertyValue {
    var `any`: Any {
        switch self {
            case let .string(string):
                string
            case let .integer(integer):
                integer
            case let .double(double):
                double
            case let .boolean(boolean):
                boolean
            case let .date(date):
                date
            case let .url(url):
                url
            case let .array(array):
                array.map(\.any)
            case let .dictionary(dictionary):
                dictionary.mapValues(\.any)
        }
    }
}
