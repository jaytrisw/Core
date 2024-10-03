import Foundation

// MARK: - Application
extension MIMEType {
    
    private static let application: String = "application"
    
    public static var applicationJson: MIMEType {
        return MIMEType(
            type: MIMEType.application,
            subtype: "json")
    }
    
    public static var applicationRar: MIMEType {
        return MIMEType(
            type: MIMEType.application,
            subtype: "vnd.rar")
    }
    
    public static var applicationZip: MIMEType {
        return MIMEType(
            type: MIMEType.application,
            subtype: "zip")
    }
    
}
