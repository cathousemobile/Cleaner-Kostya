//
//  PasswordGenerator.swift
//  Created at 06.12.2022.
//

import Foundation


/// CleanerAppsLibrary: Сервис для геренации паролей
public class Authenticator {
    // MARK: Privatr Properties
    
    public static let shared = Authenticator()
    
    // MARK: Private Properties

    private var hash: CharactersHash = [:]

    
    // MARK: Public Merhods

    
    /// Обертка над базовым методом `generatePassword` - генерирует простой пароль, состоящий только из букв и цифр, длиной 8 символов
    /// - Returns: Сгенерированный пароль
    public func generateBasicPassword() -> AuthenticatorType {
        generatePassword(includeNumbers: true, includeLetters: true, includeSymbols: false, length: 8)
    }

    /// Обертка над базовым методом `generatePassword` - генерирует сложный пароль, состоящий из букв, цифр и знаков, длиной 16 символов
    /// - Returns: Сгенерированный пароль
    public func generateComplexPassword() -> AuthenticatorType {
        generatePassword(includeNumbers: true, includeLetters: true, includeSymbols: true, length: 16)
    }

    
    /// Генерирует пароль по заданным правилам
    /// - Parameters:
    ///   - includeNumbers: нужно ли добавлять числа в пароль?
    ///   - includeLetters: нужно ли добавлять буквы в пароль?
    ///   - includeSymbols: нужно ли добавлять знаки в пароль?
    ///   - length: длина пароля
    /// - Returns: Сгенерированный по заданным правилам пароль
    public func generatePassword(includeNumbers: Bool = true, includeLetters: Bool = true, includeSymbols: Bool = true, length: Int = 16) -> AuthenticatorType {

        var passwordScore = 0
        var characters: CharactersArray = []
        if includeLetters {
            characters.append(contentsOf: charactersForGroup(group: .Letters))
            passwordScore += 1
        }
        if includeNumbers {
            characters.append(contentsOf: charactersForGroup(group: .Numbers))
            passwordScore += 1
        }
        if includeSymbols {
            characters.append(contentsOf: charactersForGroup(group: .Symbols))
            passwordScore += 1
        }
        
        if length > 8 {
            passwordScore += 1
        }

        var passwordArray: CharactersArray = []

        while passwordArray.count < length {
            let index = Int(arc4random()) % (characters.count - 1)
            passwordArray.append(characters[index])
        }

        let password = String(passwordArray)
        
        let secureLevel: AuthenticatorType.SecureLevel = {
            switch passwordScore {
            case 1...3:
                return .medium
            case _ where passwordScore > 3:
                return .hight
            default:
                return .low
            }
        }()

        return .init(passwod: password, secureLevel: secureLevel)
    }
    
    // MARK: Private Merhods

    private func charactersForGroup(group: CharactersGroup) -> CharactersArray {
        if let characters = hash[group] {
            return characters
        }
        assertionFailure("Characters should always be defined")
        return []
    }
    
    private init() { self.hash = CharactersGroup.hash }
}

// MARK: - Models

public extension Authenticator {
    typealias CharactersArray = [Character]
    typealias CharactersHash = [CharactersGroup : CharactersArray]
    
    enum CharactersGroup {
        case Letters
        case Numbers
        case Symbols

        public static var groups: [CharactersGroup] {
            get {
                return [.Letters, .Numbers, .Symbols]
            }
        }

        private static func charactersString(group: CharactersGroup) -> String {
            switch group {
            case .Letters:
                return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
            case .Numbers:
                return "0123456789"
            case .Symbols:
                return ";,&%$@#^*~!?"
            }
        }

        private static func characters(group: CharactersGroup) -> CharactersArray {
            var array: CharactersArray = []

            let string = charactersString(group: group)
            assert(string.count > 0)
            var index = string.startIndex

            while index != string.endIndex {
                let character = string[index]
                array.append(character)
                index = string.index(index, offsetBy: 1)
            }
            
            return array
        }

        public static var hash: CharactersHash {
            get {
                var hash: CharactersHash = [:]
                for group in groups {
                    hash[group] = characters(group: group)
                }
                return hash
            }
        }

    }
}
