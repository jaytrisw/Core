import Foundation
import Core
import NetworkService

extension Request {
    
    public enum Preprocessed {
        case urlEncoding(encodedUrl: URL)
        case httpBody(data: Data, headers: Request.Headers)
    }
    
}

extension Request.Preprocessed: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        switch self {
            case .urlEncoding(let encodedUrl):
                hasher.combine(encodedUrl)
            case .httpBody(let data, let headers):
                hasher.combine(data)
                hasher.combine(headers)
        }
    }
    
}

public protocol Preprocessing: Hashable {
    
    func preprocess(
        request: Request) -> Request.Preprocessed?
    
}

extension AnyPreprocessing {
    
    public static func request(
        parameters: Request.Parameters = [:],
        encoding: Request.Parameters.Encoding = .json) -> AnyPreprocessing {
            let requestPreprocessor = RequestPreprocessor(
                parameters: parameters,
                encoding: encoding)
            return AnyPreprocessing(requestPreprocessor)
        }
    
}

extension AnyPreprocessing {
    
    public static func upload(
        boundary: String = .uuidString,
        parameters: Request.Parameters = [:],
        media: [Media]) -> AnyPreprocessing {
            let uploadPreprocessor = UploadPreprocessor(
                boundary: boundary,
                parameters: parameters,
                media: media)
            return AnyPreprocessing(uploadPreprocessor)
        }
    
}

extension Preprocessing {
    
    typealias EquatableSelf = Self
    
}

public struct AnyPreprocessing {
    
    private let preprocessClosure: (Request) -> Request.Preprocessed?
    private let base: AnyHashable
    private let isEqual: (AnyPreprocessing) -> Bool
    
    public init<P>(_ base: P) where P: Preprocessing {
        self.base = base
        self.preprocessClosure = { request in
            return base.preprocess(request: request)
        }
        self.isEqual = { rhs in
            guard let rhs = rhs.base as? P.EquatableSelf else {
                return false
            }
            return base == rhs
        }
        
    }
    
}

extension AnyPreprocessing: Preprocessing {
    
    public func preprocess(
        request: Request) -> Request.Preprocessed? {
            return self.preprocessClosure(request)
        }
    
}

extension AnyPreprocessing: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.base)
    }
    
}

extension AnyPreprocessing: Equatable {
    
    public static func == (lhs: AnyPreprocessing, rhs: AnyPreprocessing) -> Bool {
        return lhs.isEqual(rhs)
    }
    
}

//public struct AnyEquatable: Equatable {
//
//    let value: Any
//    let isEqual: (AnyEquatable) -> Bool
//
//    init<T : Equatable>(_ value: T) {
//        self.value = value
//        self.isEqual = {r in
//            guard let other = r.value as? T.EqualSelf else { return false }
//            return value == other
//        }
//    }
//
//    static public func == (lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
//        return lhs.isEqual(rhs)
//    }
//
//}

public struct RequestPreprocessor {
    
    // MARK: Properties
    public let parameters: Request.Parameters
    public let encoding: Request.Parameters.Encoding
    
    // MARK: Life Cycle
    public init(
        parameters: Request.Parameters,
        encoding: Request.Parameters.Encoding) {
            self.parameters = parameters
            self.encoding = encoding
        }
    
}

// MARK: - Preprocessing
extension RequestPreprocessor: Preprocessing {
    
    public func preprocess(request: Request) -> Request.Preprocessed? {
        switch self.encoding {
            case .url:
                var urlComponents = URLComponents(
                    url: request.endpoint.url,
                    resolvingAgainstBaseURL: false)
                
                urlComponents?.queryItems = parameters.map { key, value in
                    return URLQueryItem(name: key, value: "\(value)")
                }
                
                guard let url = urlComponents?.url else {
                    return nil
                }
                
                return .urlEncoding(encodedUrl: url)
            case .json:
                guard let data = try? JSONSerialization.data(
                    withJSONObject: parameters,
                    options: []) else {
                        return nil
                    }
                let headers: Request.Headers = [
                    "Content-Type": MIMEType.applicationJson.description
                ]
                return .httpBody(data: data, headers: headers)
        }
    }
    
}

public struct UploadPreprocessor {
    
    // MARK: Properties
    public let boundary: String
    public let parameters: Request.Parameters
    public let media: [Media]
    
    // MARK: Life Cycle
    public init(
        boundary: String,
        parameters: Request.Parameters,
        media: [Media]) {
            self.boundary = boundary
            self.parameters = parameters
            self.media = media
        }
    
}

// MARK: - Preprocessing
extension UploadPreprocessor: Preprocessing {
    
    public func preprocess(request: Request) -> Request.Preprocessed? {
        let lineBreak = "\r\n"
        var data = Data()
        
        self.parameters.forEach { (key, value) in
            data.append("--\(self.boundary + lineBreak)")
            data.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
            data.append("\("\(value)" + lineBreak)")
        }
        
        self.media.forEach { item in
            data.append("--\(boundary + lineBreak)")
            data.append("Content-Disposition: form-data; name=\"\(item.key)\"; filename=\"\(item.filename)\"\(lineBreak)")
            data.append("Content-Type: \(item.mimeType.description + lineBreak + lineBreak)")
            data.append(item.data)
            data.append(lineBreak)
        }
        
        data.append("--\(self.boundary)--\(lineBreak)")
        
        let contentLength = "\(data.count)"
        
        let headers: Request.Headers = [
            "Content-Length": contentLength,
            "Content-Type": "multipart/form-data; boundary=\(self.boundary)"
        ]
        
        return .httpBody(data: data, headers: headers)
    }
    
}
