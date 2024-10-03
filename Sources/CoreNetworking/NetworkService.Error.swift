import Core
import Foundation

public extension Request {
    enum Error: Swift.Error {
        case parameterEncoding(parameters: Request.Parameters?)
        case statusCode(statusCode: Int, response: Request.Response? = nil)
        case noData(statusCode: Int, response: Request.Response? = nil)
        case network(error: Swift.Error, response: Request.Response? = nil)
        case unknown(error: Swift.Error? = nil, response: Request.Response? = nil)
    }
}

extension Request.Error: Sendable {}

public extension CoreNetworking.Request.Error {
    var response: Request.Response? {
        switch self {
            case .parameterEncoding:
                return nil
            case let .statusCode(_, response):
                return response
            case let .noData(_, response):
                return response
            case let .network(_, response):
                return response
            case let .unknown(_, response):
                return response
        }
    }
    
    var localizableError: LocalizableError {
        switch self {
            case .parameterEncoding:
                return .init("network.service.error.parameter.encoding", error: self)
            case .statusCode:
                return .init("network.service.error.status.code", error: self)
            case .noData:
                return .init("network.service.error.no.data", error: self)
            case .network:
                return .init("network.service.error.request.error", error: self)
            case .unknown:
                return .init("network.service.error.unknown.error", error: self)
        }
    }
}

extension CoreNetworking.Request.Error: CustomStringConvertible {
    
    public var description: String {
        switch self {
            case .parameterEncoding(let parameters):
                guard let parameters = parameters else {
                    return "Request Encoding"
                }
                return [
                    "Parameter Encoding",
                    parameters.description
                ].joined(separator: "\n")
            case .statusCode(let statusCode, let response):
                return [
                    "Status Code: \(statusCode)",
                    response?.data?.string(using: .utf8)
                ]
                    .compactMap { $0 }.joined(separator: ", ")
            case .noData(let statusCode, _):
                return "No Data (Status Code: \(statusCode))"
            case .network(let error, let response):
                return [
                    "Response:\n\(String(describing: response))",
                    "Error: \(error)"
                ].joined(separator: "\n")
            case .unknown(let error, _):
                guard let error = error else {
                    return "Unknown Error"
                }
                return [
                    "Unknown Error",
                    error.localizedDescription
                ].joined(separator: "\n")
        }
    }
    
}

internal extension LocalizableError {
    init(_ messageKey: String, error: Error? = nil) {
        self.init("network.service.error.title", messageKey: messageKey, error: error)
    }
}
