import Foundation

public indirect enum PropertyValue: PropertyValueType {
    case string(_ string: String)
    case integer(_ integer: Int)
    case double(_ double: Double)
    case boolean(_ boolean: Bool)
    case date(_ date: Date)
    case url(_ url: URL)
    case array(_ array: [PropertyValue])
    case dictionary(_ dictionary: [String: PropertyValue])
}
