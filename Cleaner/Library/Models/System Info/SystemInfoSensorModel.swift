//
//  SystemInfoSensorModel.swift
//

enum SystemInfoSensorModel {
    
    private typealias Text = Generated.Text.Sensor
    
    case orientation
    case acceleration
    case magnetic
    case barometer
    
    enum Orientation: String, CaseIterable {
        
        case roll
        case pitch
        case yaw
        
        var titleText: String {
            switch self {
            case .roll:
                return Text.roll
            case .pitch:
                return Text.pitch
            case .yaw:
                return Text.yaw
            }
        }
        
    }
    
    enum Coordinate: String, CaseIterable {
        
        case xAxis
        case yAxis
        case zAxis
        
        var titleText: String {
            switch self {
            case .xAxis:
                return Text.xAxis
            case .yAxis:
                return Text.yAxis
            case .zAxis:
                return Text.zAxis
            }
        }
        
    }
    
    enum Barometer: String, CaseIterable {
        
        case pressure
        
        var titleText: String {
            switch self {
            case .pressure:
                return Text.pressure
            }
            
        }
        
    }
    
}
