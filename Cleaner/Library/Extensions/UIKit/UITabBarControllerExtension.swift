

#if canImport(UIKit) && (os(iOS) || os(tvOS))
import UIKit

public extension UITabBarController {
    
    /**
     CleanerAppsLibrary: Add tab bar.
     
     - parameter controller: Controller which show by tap on bar.
     - parameter title: Title of bar.
     - parameter image: Default image for bar.
     - parameter selectedImage: Selected image for bar, If nil, using  default.
     */
    func addTabBarItem(with controller: UIViewController, title: String, image: UIImage, selectedImage: UIImage? = nil) {
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage ?? image)
        controller.tabBarItem = tabBarItem
        if self.viewControllers == nil { self.viewControllers = [controller] }
        else { self.viewControllers?.append(controller) }
    }
    
    /**
     CleanerAppsLibrary: Add tab bar.
     
     - parameter controller: Controller which show by tap on bar.
     - parameter item: System items that can be used on a tab bar..
     - parameter tag: The receiver’s tag, an integer that you can use to identify bar item objects in your application..
     */
    func addTabBarItem(with controller: UIViewController, _ item: UITabBarItem.SystemItem, tag: Int) {
        let tabBarItem = UITabBarItem.init(tabBarSystemItem: item, tag: tag)
        controller.tabBarItem = tabBarItem
        if self.viewControllers == nil { self.viewControllers = [controller] }
        else { self.viewControllers?.append(controller) }
    }
}
#endif
