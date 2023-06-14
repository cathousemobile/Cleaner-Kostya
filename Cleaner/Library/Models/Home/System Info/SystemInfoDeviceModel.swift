//
//  SystemInfoDeviceModel.swift
//

enum SystemInfoDeviceModel {
    
    private typealias Text = Generated.Text.Device
    
    case basic
    case general
    
    enum Basic: String, CaseIterable {
        
        case device
        case deviceID
        case os
        
        var titleText: String {

            switch self {
            
            case .device:
                return Text.basicDevice
            case .deviceID:
                return Text.basicDeviceId
            case .os:
                return Text.basicOs
            }

        }
        
        var infoText: String {
            switch self {
            case .device:
                return PlatformInfo.Device.deviceName ?? "No info"
            case .deviceID:
                return PlatformInfo.Device.deviceID ?? "No info"
            case .os:
                return PlatformInfo.Device.osVersion ?? "No info"
            }
        }
        
    }
    
    enum General: String, CaseIterable {
        
        case model
        case ios
        case display
        case battery
        
        var titleText: String {

            switch self {
            
            case .model:
                return Text.generalModel
            case .ios:
                return Text.generalOs
            case .display:
                return Text.generalDisplay
            case .battery:
                return Text.generalBattery
            }

        }
        
        var infoText: String {
            switch self {
            case .model:
                return PlatformInfo.Device.deviceName ?? "No info"
            case .ios:
                return PlatformInfo.Device.osVersion ?? "No info"
            case .display:
                return String(format: "%.1f", PlatformInfo.Screen.screenInch) + " inch"
            case .battery:
                return "\(PlatformInfo.Device.chargePercent)%"
            }
        }
        
    }
    
}

