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
        case build
        
        var titleText: String {
            switch self {
            case .os:
                return Text.os
            case .version:
                return Text.osVersion
            case .build:
                return Text.buildNumber
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
        
    }
    
}

