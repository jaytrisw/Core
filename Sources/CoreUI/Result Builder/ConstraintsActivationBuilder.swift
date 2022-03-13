import UIKit

@resultBuilder
public struct ConstraintsActivationBuilder {
    
    /// <#Description#>
    /// - Parameter components: <#components description#>
    /// - Returns: <#description#>
    public static func buildBlock(_ components: NSLayoutConstraint...) -> [NSLayoutConstraint] {
        return components.compactMap { $0 }
    }
    
}

extension NSLayoutConstraint {
    
    /// <#Description#>
    /// - Parameter constraints: <#constraints description#>
    public static func activate(@ConstraintsActivationBuilder constraints: () -> [NSLayoutConstraint]) {
        self.activate(constraints())
    }
    
}
