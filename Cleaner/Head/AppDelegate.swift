//
//  AppDelegate.swift
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        AppManager.shared.start(application: application, window: window)
        configureNavBar()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppKit.shared.applicactionDidBecomeActive()
        AppManager.shared.applicationDidBecomeActive(application)
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
