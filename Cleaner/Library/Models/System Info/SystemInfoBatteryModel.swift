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
    
}
