//
//  SFContactFinderType.swift


import Foundation


enum SFContactFinderType {
    
    /// Все контакты в записной книжке
    case allContacts
    
    /// Дубликаты по имени
    case duplicatesByName
    
    /// Дубликаты по номеру
    case duplicatesByPhone
    
    /// Полные дубликаты (совпадает и имя и номер)
    case fullDuplicates
    
    /// Контакты без номера телефона
    case withoutPhone
    
    /// Контакты без имени
    case withoutName
}
