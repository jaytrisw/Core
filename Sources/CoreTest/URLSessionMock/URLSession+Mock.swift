import Foundation

extension URLSession {
    
    public static var mockEndpoints: [URL: EndpointMockable] = [:]
    
    public static var mock: URLSession {
        return URLSession(configuration: .mock)
    }
    
}
