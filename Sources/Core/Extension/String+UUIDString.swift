import Foundation

extension String {
    
    public static var uuidString: String {
        return UUID()
            .uuidString
    }
    
}
