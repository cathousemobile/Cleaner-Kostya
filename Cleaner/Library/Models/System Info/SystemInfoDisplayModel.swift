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
        
    }
    
}
