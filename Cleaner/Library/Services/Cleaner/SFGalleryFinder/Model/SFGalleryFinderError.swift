//
//  SFGalleryFinderError.swift
//

import Foundation


enum SFGalleryFinderError: Error {
    case serviceInProcess
    case serviceNeverLaunched
    case noAccess
    case unexpected(msg: String)
}
