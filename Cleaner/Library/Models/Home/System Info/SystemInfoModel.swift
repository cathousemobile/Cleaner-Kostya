//
//  SystemInfoModel.swift
//

import Foundation
import UIKit

enum SystemInfoModel: CaseIterable {
    
    private typealias Text = Generated.Text.SystemInfo
    
    case device
    case screenTest
    case memory
    case display
    case network
    case battery
    case os
    case sensor
    
    var titleText: String {

        switch self {
        
        case .device:
            return Text.deviceTitle
        case .screenTest:
            return Text.screenTitle
        case .memory:
            return Text.memoryTitle
        case .display:
            return Text.displayTitle
        case .network:
            return Text.networkTitle
        case .battery:
            return Text.batteryTitle
        case .os:
            return Text.osTitle
        case .sensor:
            return Text.sensorTitle
        }

    }
    
    var subtitleText: String {

        switch self {
        
        case .device:
            return Text.deviceSubtitle
        case .screenTest:
            return Text.screenSubtitle
        case .memory:
            return Text.memorySubtitle
        case .display:
            return Text.displaySubtitle
        case .network:
            return Text.networkSubtitle
        case .battery:
            return Text.batterySubtitle
        case .os:
            return Text.osSubtitle
        case .sensor:
            return Text.sensorSubtitle
        }

    }
    
    var icon: UIImage {

        switch self {
        
        case .device:
            return Generated.Image.systemInfoDeviceIcon
        case .screenTest:
            return Generated.Image.systemInfoScreenIcon
        case .memory:
            return Generated.Image.systemInfoMemoryIcon
        case .display:
            return Generated.Image.systemInfoDisplayIcon
        case .network:
            return Generated.Image.systemInfoNetworkIcon
        case .battery:
            return Generated.Image.systemInfoBatteryIcon
        case .os:
            return Generated.Image.systemInfoOSIcon
        case .sensor:
            return Generated.Image.systemInfoSensorIcon
        }

    }
    
    var viewControllerToRoute: UIViewController {
        
        switch self {
        
        case .device:
            return DeviceViewController()
        case .screenTest:
            return ScreenTestViewController()
        case .memory:
            return MemoryViewController()
        case .display:
            return DisplayViewController()
        case .network:
            return NetworkViewController()
        case .battery:
            return BatteryViewController()
        case .os:
            return OperationSystemViewController()
        case .sensor:
            return SensorViewController()
        }
    }
    
}

