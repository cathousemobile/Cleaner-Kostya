

#if canImport(UIKit) && (os(iOS) || os(tvOS))
import UIKit

public extension UINavigationBar {
 
    /**
     CleanerAppsLibrary: Change font of title.
     
     - parameter font: New font of title.
     */
    func setTitleFont(_ font: UIFont) {
        titleTextAttributes = [.font: font]
    }
    
    /**
     CleanerAppsLibrary: Change color of title.
     
     - parameter color: New color of title.
     */
    func setTitleColor(_ color: UIColor) {
        titleTextAttributes = [.foregroundColor: color]
    }
    
    /**
     CleanerAppsLibrary: Change background and title colors.
     
     - parameter backgroundColor: New background color of navigation.
     - parameter textColor: New text color of title.
     */
    func setColors(backgroundColor: UIColor, textColor: UIColor) {
        isTranslucent = false
        self.backgroundColor = backgroundColor
        barTintColor = backgroundColor
        setBackgroundImage(UIImage(), for: .default)
        tintColor = textColor
        titleTextAttributes = [.foregroundColor: textColor]
    }

    /**
     CleanerAppsLibrary: Make transparent of background of navigation.
     */
    func makeTransparent() {
        isTranslucent = true
        backgroundColor = .clear
        barTintColor = .clear
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
    }
    
    /**
     CleanerAppsLibrary: Reset all styles for navigation.
     */
    func makeDefault() {
        isTranslucent = true
        backgroundColor = nil
        barTintColor = nil
        setBackgroundImage(nil, for: .default)
        shadowImage = nil
    }
    
    /**
     CleanerAppsLibrary: Set opacity for background view.
     */
    func setBackgroundAlpha(_ value: CGFloat) {
        for (index, view) in subviews.enumerated() {
            // Hide background for navigation bar.
            // Usually it first view.
            if index == .zero {
                view.alpha = value
            }
        }
    }
}
#endif
