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
        
    }
    
}

