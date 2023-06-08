
#if canImport(UIKit) && (os(iOS) || os(tvOS))
import UIKit

public extension UIView {
    
    /**
     CleanerAppsLibrary: Init `UIView` object with background color.
     
     - parameter backgroundColor: Color which using for background.
     */
    convenience init(backgroundColor color: UIColor) {
        self.init()
        backgroundColor = color
    }
    
    // MARK: - Helpers
    
    /**
     CleanerAppsLibrary: Get controller, on which place current view.
     
     - warning:
     If view not added to any controller, return nil.
     */
    var viewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    /**
     CleanerAppsLibrary: Add many subviews as array.
     
     - parameter subviews: Array of `UIView` objects.
     */
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
    
    /**
     CleanerAppsLibrary: Remove all subviews.
     */
    func removeSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    /**
     CleanerAppsLibrary: Take screenshoot of view as `UIImage`.
     */
    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    // MARK: - Appearance
    
    /**
     CleanerAppsLibrary: Correct rounded corners by current frame.
     
     - important:
     Need call after changed frame. Better leave it in `layoutSubviews` method.
     
     - parameter corners: Case of `CACornerMask`
     - parameter radius: Amount of radius.
     */
    func roundCorners(_ corners: CACornerMask = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], radius: CGFloat, continuous: Bool = false) {
        layer.cornerRadius = radius
        layer.maskedCorners = corners
        
        if #available(iOS 13, *), continuous {
            layer.cornerCurve = .continuous
        }
    }
    
    /**
     CleanerAppsLibrary: Rounded corners to maximum of corner radius.
     
     - important:
     Need call after changed frame. Better leave it in `layoutSubviews` method.
     */
    func roundCorners() {
        layer.cornerRadius = min(frame.width, frame.height) / 2
    }
    
    /**
     CleanerAppsLibrary: Correct rounded corners by current frame.
     
     - important:
     Need call after changed frame. Better leave it in `layoutSubviews` method.
     
     - parameter corners: Case of `CACornerMask`
     - parameter radius: Amount of radius.
     - parameter masksToBounds: A Boolean indicating whether sublayers are clipped to the layer’s bounds.
     */
    func roundCorners(_ corners: CACornerMask = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], radius: CGFloat, continuous: Bool = false, masksToBounds: Bool = false) {
        layer.cornerRadius = radius
        layer.maskedCorners = corners
        layer.masksToBounds = masksToBounds
        
        if #available(iOS 13, *), continuous {
            layer.cornerCurve = .continuous
        }
    }
    
    /**
     CleanerAppsLibrary: Rounded corners to maximum of corner radius.
     
     - important:
     Need call after changed frame. Better leave it in `layoutSubviews` method.
     
     - parameter masksToBounds: A Boolean indicating whether sublayers are clipped to the layer’s bounds.
     */
    func roundCorners(masksToBounds: Bool = false) {
        layer.cornerRadius = min(frame.width, frame.height) / 2
        layer.masksToBounds = masksToBounds
    }
    
    /**
     CleanerAppsLibrary: Add shadow.
     
     - parameter color: Color of shadow.
     - parameter radius: Blur radius of shadow.
     - parameter offset: Vertical and horizontal offset from center fro shadow.
     - parameter opacity: Alpha for shadow view.
     */
    func addShadow(ofColor color: UIColor, radius: CGFloat, offset: CGSize, opacity: Float) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    
    /**
     CleanerAppsLibrary: Add backgorund image.
     
     - parameter color: Color of shadow.
     - parameter radius: Blur radius of shadow.
     - parameter offset: Vertical and horizontal offset from center fro shadow.
     - parameter opacity: Alpha for shadow view.
     */
    func addBackgroundImage(_ image: UIImage?, contentMode: ContentMode = .scaleAspectFill, opacity: Float = 1, tintColor: UIColor? = nil) {
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = contentMode
        imageView.alpha = CGFloat(opacity)
        if let tintColor = tintColor {
            imageView.tintColor = tintColor
        }
        
        insertSubview(imageView, at: 0)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    /**
     CleanerAppsLibrary: Add paralax. Depended by angle of device.
     Can be not work is user reduce motion on settins device.
     
     - parameter amount: Amount of paralax effect.
     */
    func addParalax(amount: CGFloat) {
        motionEffects.removeAll()
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        self.addMotionEffect(group)
    }
    
    /**
     CleanerAppsLibrary: Remove paralax.
     */
    func removeParalax() {
        motionEffects.removeAll()
    }
    
    /**
     CleanerAppsLibrary: Appear view with fade in animation.
     
     - parameter duration: Duration of animation.
     - parameter completion: Completion when animation ended.
     */
    func fadeIn(duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: .zero, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
            self.alpha = 1
        }, completion: completion)
    }
    
    /**
     CleanerAppsLibrary: Hide view with fade out animation.
     
     - parameter duration: Duration of animation.
     - parameter completion: Completion when animation ended.
     */
    func fadeOut(duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: .zero, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
            self.alpha = 0
        }, completion: completion)
    }
}
#endif

