//
//  SFContact.swift
//  Clean Utility
//

import Foundation
import Contacts
import PhoneNumberKit


/// Конткт из записной книги
struct SFContactModel: Hashable {
    /// Полное имя контакта (имя, фамилия, отвечтво и тд)
    let name: String?
    
    /// Все телефонные номера контакта
    let numbers: [String]
    
    /// Фото контакта (миниатюра)
    let thumbnailImageData: Data?
    
    /// ID контакта в системе 
    let cnContactID: String
    
    init(cnContact: CNContact, phoneKit: PhoneNumberKit) {
        name = CNContactFormatter.string(from: cnContact, style: .fullName)
        
        numbers = cnContact.phoneNumbers.compactMap { phoneNumber in
            (try? phoneKit.parse(phoneNumber.value.stringValue).numberString) ?? phoneNumber.value.stringValue
        }
        
        thumbnailImageData = cnContact.thumbnailImageData
        cnContactID = cnContact.identifier
    }
}
