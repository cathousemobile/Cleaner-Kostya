

#if canImport(UIKit) && (os(iOS) || os(tvOS))
import UIKit

public extension UIButton {
    
    /**
     CleanerAppsLibrary: Set title for all states.
     
     - parameter title: Title for button.
     */
    func setTitle(_ title: String) {
        setTitle(title, for: .normal)
    }
    
    /**
     CleanerAppsLibrary: Set title color for all states.
     Also adding higlight color automatically for clear press event.
     
     - parameter color: Color of title.
     */
    func setTitleColor(_ color: UIColor) {
        setTitleColor(color, for: .normal)
        setTitleColor(color.withAlphaComponent(0.7), for: .highlighted)
    }
    
    /**
     CleanerAppsLibrary: Set image for all states.
     
     - parameter image: Image for button.
     */
    func setImage(_ image: UIImage?) {
        setImage(image, for: .normal)
        setImage(image, for: .highlighted)
        setImage(image, for: .disabled)
    }
    
    /**
     CleanerAppsLibrary: Remove all targets.
     */
    func removeAllTargets() {
        self.removeTarget(nil, action: nil, for: .allEvents)
    }
}
#endif
