//
//  ContactModel.swift
//

import Foundation

struct MyContact: Hashable, CustomStringConvertible {
    
    let uuid = UUID().uuidString
    var description: String { name }
    
    let id: String
    let name: String
    let stringPhoneNumber: [String]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: MyContact, rhs: MyContact) -> Bool {
        lhs.uuid == rhs.uuid && lhs.description == rhs.description && lhs.id == rhs.id && lhs.name == rhs.name && lhs.stringPhoneNumber == rhs.stringPhoneNumber
    }
    
}
