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
        
    }
    
}

