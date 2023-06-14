//
//  SystemInfoMemoryModel.swift
//

enum SystemInfoMemoryModel {
    
    private typealias Text = Generated.Text.Memory
    
    case storage
    case ram
    
    enum Storage: String, CaseIterable {
        
        case available
        case total
        
        var titleText: String {
            switch self {
            case .available:
                return Text.storageAvailable
            case .total:
                return Text.storageTotal
            }
        }
        
        var infoText: String {
            switch self {
            case .available:
                return BinaryFormatter(bytes: PlatformInfo.Device.freeSpace ?? 0).prettyFormat().formatted
            case .total:
                return BinaryFormatter(bytes: PlatformInfo.Device.totalSpace ?? 0).prettyFormat().formatted
            }
        }
        
    }
    
    enum Ram: String, CaseIterable {
        
        case available
        case total
        
        var titleText: String {
            switch self {
            case .available:
                return Text.ramAvailable
            case .total:
                return Text.ramTotal
            }
        }
        
        var infoText: String {
            switch self {
            case .available:
                return BinaryFormatter(bytes: PlatformInfo.Device.freeRAM ?? 0).prettyFormat().formatted
            case .total:
                return BinaryFormatter(bytes: PlatformInfo.Device.totalRAM).prettyFormat().formatted
            }
        }
        
    }
    
}

