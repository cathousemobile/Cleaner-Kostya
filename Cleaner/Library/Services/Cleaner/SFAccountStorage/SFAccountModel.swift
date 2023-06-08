//
//  SFAccountModel.swift
//

import Foundation


struct SFAccountModel: Hashable, Codable {
    var link: String?
    var title: String?
    var login: String
    var passwordInfo: SFPasswordModel
}
