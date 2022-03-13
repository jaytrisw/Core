import Foundation

extension URLSessionConfiguration {
    
    public static var mock: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        return configuration
    }
    
}
