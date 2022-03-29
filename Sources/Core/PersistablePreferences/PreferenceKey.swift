import Foundation

public struct PreferenceKey<WrappedType> {
    
    // MARK: Properties
    public let type: WrappedType.Type
    public let key: Key
    
    // MARK: Life Cycle
    public init(
        _ type: WrappedType.Type = WrappedType.self,
        key: Key) {
            self.type = type
            self.key = key
        }
    
}
