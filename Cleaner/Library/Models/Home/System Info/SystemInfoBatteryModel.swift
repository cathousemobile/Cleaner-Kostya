//
//  SystemInfoBatteryModel.swift
//

enum SystemInfoBatteryModel: String, CaseIterable {
    
    private typealias Text = Generated.Text.Battery
    
    case status
    case level
    case power
    
    var titleText: String {
        switch self {
        case .status:
            return Text.status
        case .level:
            return Text.level
        case .power:
            return Text.savingMode
        }
    }
    
    var infoText: String {
        switch self {
        case .status:
            return PlatformInfo.Device.isCharging ? Text.charging : Text.unplugged
        case .level:
            return "\(PlatformInfo.Device.chargePercent)%"
        case .power:
            return PlatformInfo.Device.isLowPowerModeEnabled ? Generated.Text.Common.on : Generated.Text.Common.off
        }
    }
    
}
