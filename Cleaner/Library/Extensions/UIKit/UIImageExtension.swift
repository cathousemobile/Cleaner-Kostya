

#if canImport(UIKit)

import UIKit

public extension UIImage {
    
    // MARK: - Init
    
    /**
     CleanerAppsLibrary: Create new `UIImage` object by color and size.
     
     Create filled image with specific color.
     
     - parameter color: Color.
     - parameter size: Size.
     */
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        defer {
            UIGraphicsEndImageContext()
        }
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        }
        self.init(cgImage: aCgImage)
    }
    
    /**
     CleanerAppsLibrary: Create `SFSymbols` image.
     
     - parameter name: Name of system image..
     */
    @available(iOS 13, tvOS 13, *)
    static func system(_ name: String) -> UIImage {
        return UIImage.init(systemName: name) ?? UIImage()
    }
    
    /**
     CleanerAppsLibrary: Create `SFSymbols` image with specific configuration.
     
     - parameter name: Name of system image.
     - parameter pointSize: Font size of image.
     - parameter weight: Weight of font of image.
     */
    @available(iOS 13, tvOS 13, *)
    static func system(_ name: String, pointSize: CGFloat, weight: UIImage.SymbolWeight) -> UIImage {
        let configuration = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight)
        return UIImage(systemName: name, withConfiguration: configuration) ?? UIImage()
    }
    
    /**
     CleanerAppsLibrary: Create `SFSymbols` image with specific configuration.
     
     - parameter name: Name of system image.
     - parameter font: Font  of image.
     */
    @available(iOS 13, tvOS 13, *)
    static func system(_ name: String, font: UIFont) -> UIImage {
        let configuration = UIImage.SymbolConfiguration(font: font)
        return UIImage(systemName: name, withConfiguration: configuration) ?? UIImage()
    }
    
    // MARK: - Helpers
    
    /**
     CleanerAppsLibrary: Get size of image in bytes.
     */
    var bytesSize: Int {
        return jpegData(compressionQuality: 1)?.count ?? 0
    }
    
    /**
     CleanerAppsLibrary: Get size of image in kilibytes.
     */
    var kilobytesSize: Int {
        return (jpegData(compressionQuality: 1)?.count ?? 0) / 1024
    }
    
    /**
     CleanerAppsLibrary: Compress image.
     
     - parameter quality: Factor of compress. Can be in 0...1.
     */
    func compresse(quality: CGFloat = 0.5) -> UIImage? {
        guard let data = jpegData(compressionQuality: quality) else { return nil }
        return UIImage(data: data)
    }
    
    /**
     CleanerAppsLibrary: Compress data of image.
     
     - parameter quality: Factor of compress. Can be in 0...1.
     */
    func compressedData(quality: CGFloat = 0.5) -> Data? {
        return jpegData(compressionQuality: quality)
    }
    
    // MARK: - Appearance
    
    /**
     CleanerAppsLibrary: Always original render mode.
     */
    var alwaysOriginal: UIImage {
        return withRenderingMode(.alwaysOriginal)
    }
    
    /**
     CleanerAppsLibrary: Always original render mode.
     
     - parameter color: Color of image.
     */
    @available(iOS 13.0, tvOS 13.0, *)
    func alwaysOriginal(with color: UIColor) -> UIImage {
        return withTintColor(color, renderingMode: .alwaysOriginal)
    }
    
    /**
     CleanerAppsLibrary: Always template render mode.
     */
    var alwaysTemplate: UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
    
    /**
     CleanerAppsLibrary: Get average color of image.
     */
    #if canImport(CoreImage)
    func averageColor() -> UIColor? {
        guard let ciImage = ciImage ?? CIImage(image: self) else { return nil }
        let parameters = [kCIInputImageKey: ciImage, kCIInputExtentKey: CIVector(cgRect: ciImage.extent)]
        guard let outputImage = CIFilter(name: "CIAreaAverage", parameters: parameters)?.outputImage else {
            return nil
        }
        var bitmap = [UInt8](repeating: 0, count: 4)
        let workingColorSpace: Any = cgImage?.colorSpace ?? NSNull()
        let context = CIContext(options: [.workingColorSpace: workingColorSpace])
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)
        return UIColor(red: CGFloat(bitmap[0]) / 255.0,
                       green: CGFloat(bitmap[1]) / 255.0,
                       blue: CGFloat(bitmap[2]) / 255.0,
                       alpha: CGFloat(bitmap[3]) / 255.0)
    }
    #endif
}

#endif
