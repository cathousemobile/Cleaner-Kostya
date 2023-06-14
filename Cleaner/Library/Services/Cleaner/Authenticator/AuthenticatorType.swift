//
//  AuthenticatorType.swift
//

import Foundation


/// Модель пароля
public struct AuthenticatorType: Hashable, Codable {
    
    /// Пароль
    let passwod: String
    
    /// Уровень его безопасности
    let secureLevel: SecureLevel
    
    enum SecureLevel: String, Hashable, Codable {
        case low, medium, hight
    }
}
