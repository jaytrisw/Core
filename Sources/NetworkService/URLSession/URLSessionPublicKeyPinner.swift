import Foundation
import CryptoKit
import CommonCrypto
import Log

public typealias ProtectedHosts = Dictionary<Host, Hash>
public typealias Host = String
public typealias Hash = String

@available(iOS 12.0, *)
final class URLSessionPublicKeyPinner: NSObject {
    
    private let protectedHosts: ProtectedHosts
    private let logger: Loggable?
    
    init(
        protectedHosts: ProtectedHosts,
        logger: Loggable?) {
            self.protectedHosts = protectedHosts
            self.logger = logger
        }
    
}

@available(iOS 12.0, *)
private extension URLSessionPublicKeyPinner {
    
    static let rsa2048Asn1Header: [UInt8] = [
        0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
    ]
    
    func sha256(data: Data) -> String? {
        var keyWithHeader = Data(Self.rsa2048Asn1Header)
        keyWithHeader.append(data)
        
        guard #available(iOS 13.0, *) else {
            var hash = Array<UInt8>(repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            keyWithHeader.withUnsafeBytes { dataBytes in
                guard let buffer = dataBytes.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                    return
                }
                CC_SHA256(buffer, CC_LONG(keyWithHeader.count), &hash)
            }
            return Data(hash)
                .base64EncodedString()
        }
        
        return Data(SHA256.hash(data: keyWithHeader))
            .base64EncodedString()
    }
    
}

@available(iOS 12.0, *)
extension URLSessionPublicKeyPinner: URLSessionDelegate {
    
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            let protectedHost = challenge.protectionSpace.host
            guard let protectedHash = self.protectedHosts
                    .first(where: { return protectedHost.contains($0.key) }) else {
                        self.logger?.log(
                            "\(protectedHost) not found in protected urls",
                            level: .secure)
                        
                        completionHandler(.performDefaultHandling, nil)
                        return
                    }
            
            guard let serverTrust = challenge.protectionSpace.serverTrust,
                  let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0),
                  let serverPublicKey = SecCertificateCopyKey(serverCertificate),
                  let serverPublicKeyData = SecKeyCopyExternalRepresentation(serverPublicKey, nil)?.asData,
                  let serverHashKey = self.sha256(data: serverPublicKeyData),
                  protectedHash.value == serverHashKey else {
                      self.logger?.log(
                        "Certificate Pinning Failed",
                        level: .insecure)
                      
                      completionHandler(.cancelAuthenticationChallenge, nil)
                      return
                  }
            self.logger?.log(
                "Certificate Pinning Success",
                level: .secure)
            
            let urlCredential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, urlCredential)
        }
    
}

extension CFData {
    
    var asData: Data {
        return self as Data
    }
    
}
