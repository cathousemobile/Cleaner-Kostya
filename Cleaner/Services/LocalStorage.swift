//
//  LocalStorage.swift
//

import Foundation

public enum LocaleStorage {
    
    static var isPremium: Bool {
        set {
            UserDefaults.standard.setValue(newValue, forKey: Router.isPremium)
        }

        get {
            UserDefaults.standard.bool(forKey: Router.isPremium)
        }
    }
    
    static var onboardingCompleted: Bool {
        set {
            UserDefaults.standard.setValue(newValue, forKey: Router.onboardingCompleted)
        }

        get {
            UserDefaults.standard.bool(forKey: Router.onboardingCompleted)
        }
    }

    public enum Router {
        public static var isPremium: String { "isUserPremium" }
        public static var onboardingCompleted: String { "onboardingCompleted" }
    }
}
