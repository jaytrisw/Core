import Foundation

extension Data {
    var debugString: String? {
        guard let jsonDict = try? JSONSerialization.jsonObject(with: self, options: .allowFragments),
              let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
                  return String(data: self, encoding: .utf8)
              }
        return jsonString
    }
}
