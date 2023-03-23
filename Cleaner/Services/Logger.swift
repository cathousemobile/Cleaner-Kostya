//
//  Logger.swift
//

import Foundation

open class Logger {

    public typealias LogItem = Any

    static public func log(_ level: Level, logItem: LogItem...) {
//        guard AppKit.shared.isEnableLogging else { return }
        print("AppKit(\(level.description)):", logItem)
    }

    /**
     Use `httpResponse` for response of API requests.
     Use `error` for critical bugs.
     Use `debug` for develop process.
     */
    public enum Level: String, CaseIterable {

        case httpResponse
        case error
        case debug

        public var description: String {
            switch self {
            case .httpResponse: return "HTTP Response"
            case .error: return "Error"
            case .debug: return "Debug"
            }
        }
    }

}

