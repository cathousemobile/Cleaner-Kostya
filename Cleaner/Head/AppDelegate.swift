//
//  AppDelegate.swift
//

import UIKit
import AppsFlyerLib
import ApphudSDK
import FacebookCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        
        application.registerForRemoteNotifications()
        window?.rootViewController = AppCoordiator()
        window?.makeKeyAndVisible()
    
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        startAllServices()
        launchMetrics()
        
        configureNavBar()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppsFlyerLib.shared().start()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    func launchMetrics() {
        CommerceManager.shared.start(apiKey: AppConstants.apphudKey)
        
        AppsFlyerLib.shared().appsFlyerDevKey = AppConstants.appsFlyerKey
        AppsFlyerLib.shared().appleAppID = AppConstants.appID
        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
    }
    
    func startAllServices() {
        MatchedImageFinder.shared.start()
        ContactReplicaScanner.shared.start()
    }

}

//MARK: - Start Services

extension AppDelegate {
    
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

extension AppDelegate: AppsFlyerLibDelegate {
    public func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        Apphud.addAttribution(data: conversionInfo, from: .appsFlyer, identifer: AppsFlyerLib.shared().getAppsFlyerUID()) { _ in }
    }

    public func onConversionDataFail(_ error: Error) {
        Apphud.addAttribution(data: ["error" : error.localizedDescription], from: .appsFlyer, identifer: AppsFlyerLib.shared().getAppsFlyerUID()) { _ in }
    }
}
