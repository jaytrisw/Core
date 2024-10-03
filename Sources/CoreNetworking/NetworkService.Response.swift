import Foundation

public typealias Response = Result<(data: Data?, response: Request.Response), CoreNetworking.Request.Error>

extension Response: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
            case .success(let successResult):
                return [
                    "Success",
                    successResult.response.debugDescription,
                    "Data: \(successResult.data?.debugString ?? "-")"
                ].joined(separator: "\n")
            case .failure(let error):
                return [
                    "Failure",
                    error.description
                ].joined(separator: "\n")
        }
    }
}

import CoreLogging

extension Response: ContentRepresentable {
    public var contentRepresentation: String {
        switch self {
            case .success(let successResult):
                return successResult.data?.jsonRepresentation ?? successResult.data?.string(using: .utf8) ?? ""
            case .failure(let error):
                return "Result.failure(\(error.localizedDescription)"
        }
    }
}

extension Response {
    
    func toSuccess<T: Decodable>(
        type: T.Type = T.self,
        decoder: JSONDecoder) -> Result<CoreNetworking.Success<T>, CoreNetworking.Request.Error> {
            switch self {
                case .success(let result):
                    guard let data = result.data else {
                        return .failure(CoreNetworking.Request.Error.noData(
                            statusCode: result.response.statusCode,
                            response: result.response))
                    }
                    do {
                        let parsedItem = try decoder.decode(type, from: data)
                        return .success(CoreNetworking.Success(value: parsedItem, response: result.response))
                    } catch {
                        return .failure(CoreNetworking.Request.Error.unknown(error: error, response: result.response))
                    }
                    
                case .failure(let responseError):
                    return .failure(responseError)
                    
            }
        }
    
}


extension Data {
    var jsonRepresentation: String? {
        guard let jsonDict = try? JSONSerialization.jsonObject(with: self, options: .allowFragments),
              let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return .none
        }
        return jsonString
    }
}
