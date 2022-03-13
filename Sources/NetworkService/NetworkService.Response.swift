import Foundation

public typealias Response = Result<(data: Data?, response: Request.Response), NetworkService.Error>

extension Response: CustomStringConvertible {
    
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

extension Response {
    
    func toSuccess<T: Decodable>(
        type: T.Type = T.self,
        decoder: JSONDecoder) -> Result<NetworkService.Success<T>, NetworkService.Error> {
            switch self {
                case .success(let result):
                    guard let data = result.data else {
                        return .failure(NetworkService.Error.noData(statusCode: result.response.statusCode))
                    }
                    do {
                        let parsedItem = try decoder.decode(type, from: data)
                        return .success(NetworkService.Success(value: parsedItem, response: result.response))
                    } catch {
                        return .failure(NetworkService.Error.unknown(error: error))
                    }
                    
                case .failure(let responseError):
                    return .failure(responseError)
                    
            }
        }
    
}

