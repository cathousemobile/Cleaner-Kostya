//
//  ProfileStorageType.swift
//

import Foundation


struct ProfileStorageType: Hashable, Codable {
    var link: String?
    var title: String?
    var login: String
    var passwordInfo: AuthenticatorType
}
