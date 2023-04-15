//
//  SystemInfoOSModel.swift
//

enum SystemInfoOSModel {
    
    private typealias Text = Generated.Text.Os
    
    case installed
    case current
    
    enum Installed: String, CaseIterable {
        
        case os
        case version
        
        var titleText: String {
            switch self {
            case .os:
                return Text.os
            case .version:
                return Text.osVersion
            }
        }
        
        var infoText: String {
            switch self {
            case .os:
                return "iOS"
            case .version:
                return SFSystemInfo.Device.osVersion ?? "Unknown"
            }
        }
        
    }
    
    enum Current: String, CaseIterable {
        
        case activeTime
        
        var titleText: String {
            switch self {
            case .activeTime:
                return Text.activeTime
            }
        }
        
        var infoText: String {
            switch self {
            case .activeTime:
                return SFSystemInfo.Device.systemUptime.stringFromTimeInterval()
            }
        }
        
    }
    
}

