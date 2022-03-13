import Foundation

@propertyWrapper
/// <#Description#>
public struct Localizable {
    
    // MARK: Properties
    /// <#Description#>
    private let key: Key
    /// <#Description#>
    private let tableName: String?
    /// <#Description#>
    private let bundle: Bundle
    /// <#Description#>
    private let defaultValue: String
    /// <#Description#>
    private let comment: String
    
    // MARK: Wrapped Value
    /// <#Description#>
    public var wrappedValue: String {
        get {
            NSLocalizedString(
                self.key.value,
                tableName: self.tableName,
                bundle: self.bundle,
                value: self.defaultValue,
                comment: self.comment)
        }
    }
    
    // MARK: Life Cycle
    /// <#Description#>
    /// - Parameters:
    ///   - key: <#key description#>
    ///   - tableName: <#tableName description#>
    ///   - bundle: <#bundle description#>
    ///   - defaultValue: <#defaultValue description#>
    ///   - comment: <#comment description#>
    public init(
        key: Key,
        tableName: String?,
        bundle: Bundle,
        defaultValue: String,
        comment: String) {
            self.key = key
            self.tableName = tableName
            self.bundle = bundle
            self.defaultValue = defaultValue
            self.comment = comment
        }
    
}
import Foundation
