//
//  MatchedImageFinderFailure.swift
//

import Foundation


enum MatchedImageFinderFailure: Error {
    case serviceInProcess
    case serviceNeverLaunched
    case noAccess
    case unexpected(msg: String)
}
