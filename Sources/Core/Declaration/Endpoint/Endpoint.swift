import Foundation

/// Structure used to declare an API endpoint
public struct Endpoint {
    
    // MARK: Properties
    /// <#Description#>
    var scheme: Endpoint.Scheme
    /// <#Description#>
    var host: String
    /// <#Description#>
    var path: String
    
    // MARK: Life Cycle
    /// <#Description#>
    /// - Parameters:
    ///   - scheme: <#scheme description#>
    ///   - host: <#host description#>
    ///   - path: <#path description#>
    public init(
        scheme: Endpoint.Scheme = .https,
        host: String,
        path: String) {
            self.scheme = scheme
            self.host = host
            self.path = path
        }
    
}

extension Endpoint {
    
    /// <#Description#>
    public enum Scheme: String {
        case http = "http"
        case https = "https"
    }
    
}

extension Endpoint {
    
    /// Constructs a `URL` object for an instance of `Endpoint`
    public var url: URL {
        var components = URLComponents()
        components.scheme = self.scheme.rawValue
        components.host = self.host
        
        guard var url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        
        url.appendPathComponent(self.path)
        
        return url
    }
    
}

extension Endpoint: Equatable {}
extension Endpoint: Hashable {}
