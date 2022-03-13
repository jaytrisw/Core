import Foundation

extension URLRequest {
    
    mutating func httpBodyStreamToData() {
        guard self.httpBody == nil,
              let stream = self.httpBodyStream else {
                  return
              }
        
        var buffer = Array<UInt8>(repeating: 0, count: 100)
        var data = Data()
        
        stream.open()
        while stream.hasBytesAvailable {
            let count = stream.read(&buffer, maxLength: buffer.count)
            data.append(buffer, count: count)
        }
        
        stream.close()
        self.httpBodyStream = nil
        self.httpBody = data
    }
    
}
