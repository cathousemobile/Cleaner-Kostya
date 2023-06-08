

#if canImport(UIKit)
import UIKit

extension UIEdgeInsets {
    
    /**
     CleanerAppsLibrary: Create insets by same for horizontal and vertical values.
     
     - parameter horizontal: Insets for left and right.
     - parameter vertical: Insets for top and bottom.
     */
    public init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
    /**
     CleanerAppsLibrary: Create insets by same for horizontal and vertical values.
     
     - parameter side: Insets for left right, top and bottom.
     */
    public init(side: CGFloat) {
        self.init(top: side, left: side, bottom: side, right: side)
    }
}
#endif
