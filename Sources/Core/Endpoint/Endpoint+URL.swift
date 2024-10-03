import Foundation

public extension Endpoint {
    func url() throws -> URL {
        var components = URLComponents()
        components.scheme = scheme.stringValue
        components.host = host
        components.path = path.ensureLeadingSlash()
        if parameters.isEmpty == false {
            components.queryItems = parameters.map { URLQueryItem(name: $0.label, value: "\($0.value)") }
        }

        guard let url = components.url else {
            throw URL.Error.invalid
        }
        return url
    }
}

private extension String {
    func ensureLeadingSlash() -> String {
        if isEmpty {
            return "/"
        }

        if first != "/" {
            return "/" + self
        }

        return self
    }
}
