

#if canImport(UIKit) && (os(iOS) || os(tvOS))
import UIKit
import SnapKit

public extension UIViewController {
    
    // MARK: - Layout
    
    /**
     CleanerAppsLibrary: System safe area without `additionalSafeAreaInsets`.
     
     Usually same as window's safe area, but not always if you use not full screen controller. For solve it trouble use it for have valid safe area to view.
     */
    var systemSafeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(
            top: view.safeAreaInsets.top - additionalSafeAreaInsets.top,
            left: view.safeAreaInsets.left - additionalSafeAreaInsets.left,
            bottom: view.safeAreaInsets.bottom - additionalSafeAreaInsets.bottom,
            right: view.safeAreaInsets.right - additionalSafeAreaInsets.right
        )
    }
    
    // MARK: - Containers
    
    /**
     CleanerAppsLibrary: Wrap controller to navigation controller.
     
     - parameter prefersLargeTitles: A Boolean value indicating whether the title should be displayed in a large format.
     */
    @objc func wrapToNavigationController(prefersLargeTitles: Bool) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: self)
        #if os(iOS)
        navigationController.navigationBar.prefersLargeTitles = prefersLargeTitles
        #endif
        return navigationController
    }
    
    /**
     CleanerAppsLibrary: Adds the specified view controller as a child of the current view controller.
     
     - parameter childController: Specific controller which using as child.
     - parameter containerView: Conteiner which using to add a view of child controller.
     */
    func addChildWithView(_ childController: UIViewController, to containerView: UIView) {
        addChild(childController)
        
        switch childController {
        case let collectionController as UICollectionViewController:
            containerView.addSubview(collectionController.collectionView)
        case let tableController as UITableViewController:
            containerView.addSubview(tableController.tableView)
        default:
            containerView.addSubview(childController.view)
        }
        
        childController.didMove(toParent: self)
    }
    
    /**
     CleanerAppsLibrary: Sets the received view on top of the view controller to full screen
     
     - parameter view: view to set
     */
    func setRootView(_ view: UIView) {
        self.view.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Present, Dismiss and Destruct
    
    /**
     CleanerAppsLibrary: Indicate if controller is loaded and presented.
     */
    var isVisible: Bool {
        return isViewLoaded && view.window != nil
    }
    
    /**
     CleanerAppsLibrary: Removed property `animated`, always `true`.
     */
    func present(_ viewControllerToPresent: UIViewController, completion: (() -> Swift.Void)? = nil) {
        self.present(viewControllerToPresent, animated: true, completion: completion)
    }
    
    /**
     CleanerAppsLibrary: If scene name is same as
     */
    @available(iOS 13, tvOS 13, *)
    @available(iOSApplicationExtension, unavailable)
    @available(tvOSApplicationExtension, unavailable)
    func destruct(scene name: String) {
        guard let session = view.window?.windowScene?.session else {
            dismissAnimated()
            return
        }
        if session.configuration.name == name {
            UIApplication.shared.requestSceneSessionDestruction(session, options: nil)
        } else {
            dismissAnimated()
        }
    }
    
    /**
     CleanerAppsLibrary: Dismiss always animated.
     */
    @objc func dismissAnimated() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Bar Button Items
    
    /**
     CleanerAppsLibrary: Make bar button item which automatically dismiss controller animated.
     */
    #if os(iOS)
    @available(iOS 13, *)
    var closeBarButtonItem: UIBarButtonItem {
        if #available(iOS 14.0, *) {
            return UIBarButtonItem.init(systemItem: .close, primaryAction: .init(handler: { [weak self] (action) in
                self?.dismissAnimated()
            }), menu: nil)
        } else {
            return UIBarButtonItem.init(barButtonSystemItem: .close, target: self, action: #selector(self.dismissAnimated))
        }
    }
    #endif
    
    /**
     CleanerAppsLibrary: Make bar button item which automatically dismiss controller animated and if available, try close scene.
     
     Scene compared with id which passing.
     
     - parameter sceneName: ID of scene if which detected will be closed.
     */
    #if os(iOS)
    @available(iOS 14, *)
    @available(iOSApplicationExtension, unavailable)
    func closeBarButtonItem(sceneName: String? = nil) -> UIBarButtonItem {
        return UIBarButtonItem.init(systemItem: .close, primaryAction: .init(handler: { [weak self] (action) in
            guard let self = self else { return }
            if let name = sceneName {
                self.destruct(scene: name)
            } else {
                self.dismissAnimated()
            }
        }), menu: nil)
    }
    #endif
    
    // MARK: - Keyboard
    
    /**
     CleanerAppsLibrary: Added gester which observe when tap need hide keyboard.
     Shoud add below of using views like textfuilds.
     */
    func dismissKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboardTappedAround(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    /**
     CleanerAppsLibrary: Internal method which process tap around for hide keyboard.
     No need call it manually.
     */
    @objc func dismissKeyboardTappedAround(_ gestureRecognizer: UIPanGestureRecognizer) {
        dismissKeyboard()
    }
    
    /**
     CleanerAppsLibrary: Hide keyboard.
     */
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
#endif

