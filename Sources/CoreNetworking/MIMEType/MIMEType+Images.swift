import Foundation

// MARK: - Image
extension MIMEType {
    
    private static let image: String = "image"
    
    public static var imageGif: MIMEType {
        return MIMEType(
            type: MIMEType.image,
            subtype: "gif")
    }
    
    public static var imageJpeg: MIMEType {
        return MIMEType(
            type: MIMEType.image,
            subtype: "jpeg")
    }
    
    public static var imagePng: MIMEType {
        return MIMEType(
            type: MIMEType.image,
            subtype: "png")
    }
    
    public static var imageSvg: MIMEType {
        return MIMEType(
            type: MIMEType.image,
            subtype: "svg+xml")
    }
    
    public static var imageTiff: MIMEType {
        return MIMEType(
            type: MIMEType.image,
            subtype: "tiff")
    }
    
}
