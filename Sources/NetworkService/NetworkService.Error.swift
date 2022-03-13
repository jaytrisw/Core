import Foundation

public enum Error: Swift.Error {
    case parameterEncoding(parameters: Request.Parameters?)
    case statusCode(statusCode: Int)
    case noData(statusCode: Int)
    case network(error: Swift.Error, response: Request.Response? = nil)
    case unknown(error: Swift.Error? = nil)
}

extension NetworkService.Error: CustomStringConvertible {
    
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
            case .statusCode(let statusCode):
                return "Status Code: \(statusCode)"
            case .noData(let statusCode):
                return "No Data (Status Code: \(statusCode))"
            case .network(let error, let response):
                return [
                    "Response:\n\(String(describing: response))",
                    "Error: \(error)"
                ].joined(separator: "\n")
            case .unknown(let error):
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
