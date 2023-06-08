//
//  SFContactFinderError.swift
//  Clean Utility
//

import Foundation


enum SFContactFinderError: Error {
    case serviceInProcess
    case serviceNeverLaunched
    case noAccess
    case cantFindContact
    case unexpected(msg: String)
}
