//
//  AppDelegate.swift
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        window?.overrideUserInterfaceStyle = .light
        window?.rootViewController = AppCoordiator()
//        window?.rootViewController = PaywallViewController(paywallType: .rect)
        window?.makeKeyAndVisible()
        
        configureNavBar()
        
        startAllServices()
        
        return true
    }

}

//MARK: - Start Services

extension AppDelegate {
    
    func startAllServices() {
        SFGalleryFinder.shared.start()
        SFContactFinder.shared.start()
    }
    
}

extension AppDelegate {

    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    var appCoordiator: AppCoordiator {
        return window!.rootViewController as! AppCoordiator
    }

}

extension AppDelegate {
    
    func configureNavBar() {
        UINavigationBar.appearance().tintColor = Generated.Color.buttonBackground
    }
    
}
