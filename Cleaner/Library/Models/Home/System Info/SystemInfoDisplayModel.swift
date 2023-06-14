//
//  SystemInfoDisplayModel.swift
//

enum SystemInfoDisplayModel {
    
    private typealias Text = Generated.Text.Display
    
    case size
    case information
    
    enum Size: String, CaseIterable {
        
        case screenSize
        case pixelDensity
        
        var titleText: String {
            switch self {
            case .screenSize:
                return Text.screenSize
            case .pixelDensity:
                return Text.pixelDensity
            }
        }
        
        var infoText: String {
            switch self {
            case .screenSize:
                return String(format: "%.1f", PlatformInfo.Screen.screenInch) + " inch"
            case .pixelDensity:
                return String(format: "%.0f", PlatformInfo.Screen.ppi) + " PPI"
            }
        }
        
    }
    
    enum Information: String, CaseIterable {
        
        case vertical
        case horizontal
        
        var titleText: String {
            switch self {
            case .vertical:
                return Text.vertical
            case .horizontal:
                return Text.horizontal
            }
        }
        
        var infoText: String {
            switch self {
            case .vertical:
                return String(format: "%.0f", PlatformInfo.Screen.vertivalPixel) + " Pixels"
            case .horizontal:
                return String(format: "%.0f", PlatformInfo.Screen.horizontalPixel) + " Pixels"
            }
        }
        
    }
    
}
