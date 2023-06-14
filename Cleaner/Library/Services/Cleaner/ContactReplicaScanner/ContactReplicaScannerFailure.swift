//
//  ContactReplicaScannerFailure.swift
//  Clean Utility
//

import Foundation


enum ContactReplicaScannerFailure: Error {
    case serviceInProcess
    case serviceNeverLaunched
    case noAccess
    case cantFindContact
    case unexpected(msg: String)
}
