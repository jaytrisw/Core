import Core
import CoreTracking
@preconcurrency import Mixpanel

public actor MixpanelTracker {

    private let instance: MixpanelInstance

    init(token: String, trackAutomaticEvents: Bool = true) {
        self.instance = Mixpanel.initialize(token: token, trackAutomaticEvents: trackAutomaticEvents)

        instance.people.set(property: "email", to: "ghj")
    }

    @globalActor actor Actor {
        static var shared: Actor = .init()
    }
}

protocol UserPropertyRepresentable: PropertyRepresentable {}

struct UserProperty: UserPropertyRepresentable {
    let key: String
    let value: PropertyValue
}

extension UserPropertyRepresentable where Self == UserProperty {
    static func emailAddress(_ value: String) -> Self {
        .init(key: "email", value: .string(value))
    }
}

extension MixpanelTracker: Trackable {
    nonisolated public func track(
        _ event: EventRepresentable,
        properties: [PropertyRepresentable]) {
            Task { @MixpanelTracker.Actor in
                await instance.track(event: event.name, properties: properties.mixpanelDictionary)
            }
        }

    func set(_ properties: UserPropertyRepresentable...) {
        Task { @MixpanelTracker.Actor in
            for property in properties {
                await instance.people.set(property: property.key, to: property.value.mixpanelType)
            }
        }
    }
}

extension Array where Element == PropertyRepresentable {
    var dictionary: [String: PropertyValue] {
        .init(map { ($0.key, $0.value) }, uniquingKeysWith: { _, new in new })
    }
}

extension Array where Element == PropertyRepresentable {
    var mixpanelDictionary: [String: MixpanelType] {
        dictionary
            .mapValues(\.mixpanelType)
    }
}

extension PropertyValue {
    var mixpanelType: MixpanelType {
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
                array.map(\.mixpanelType)
            case let .dictionary(dictionary):
                dictionary.mapValues(\.mixpanelType)
        }
    }
}

public extension Trackable where Self == MixpanelTracker {
    static func mixpanel(_ token: String, trackAutomaticEvents: Bool = true) -> Self {
        .init(token: token, trackAutomaticEvents: trackAutomaticEvents)
    }
}
