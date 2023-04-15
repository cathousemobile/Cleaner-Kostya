//
//  LocalStorage.swift
//

import Foundation

public enum LocaleStorage {
    
    static var onboardingCompleted: Bool {
        set {
            UserDefaults.standard.setValue(newValue, forKey: Router.onboardingCompleted)
        }

        get {
            UserDefaults.standard.bool(forKey: Router.onboardingCompleted)
        }
    }
    
    static var paywallId: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: Router.paywallId)
        }

        get {
            UserDefaults.standard.string(forKey: Router.paywallId)
        }
    }
    
    static var secretIsAuthenticated: Bool {
        set {
            if newValue != secretIsAuthenticated {
                UserDefaults.standard.setValue(newValue, forKey: Router.secretIsAuthenticated)
                SFNotificationSystem.send(event: .custom(name: "secretAuthenticatedDidChange"))
            }
        }

        get {
            UserDefaults.standard.bool(forKey: Router.secretIsAuthenticated)
        }
    }

    public enum Router {
        public static var onboardingCompleted: String { "onboardingCompleted" }
        public static var paywallId: String { "paywallId" }
        public static var secretIsAuthenticated: String { "secretIsAuthenticated" }
    }
}
