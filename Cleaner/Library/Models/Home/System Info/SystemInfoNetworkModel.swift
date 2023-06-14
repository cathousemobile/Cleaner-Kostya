//
//  SystemInfoNetworkModel.swift
//

enum SystemInfoNetworkModel: String, CaseIterable {
    
    private typealias Text = Generated.Text.Network
    
    case ipAdress
    case name
    case country
    
    var titleText: String {
        switch self {
        case .ipAdress:
            return Text.currentIp
        case .name:
            return Text.carrierName
        case .country:
            return Text.carrierCountry
            
        }
    }
    
    func infoText(_ networkInfo: PlatformInfo.Network.Info?) -> String {
        
        switch self {
        case .ipAdress:
            return networkInfo?.ip ?? "Unknown"
        case .name:
            return networkInfo?.isp ?? "Unknown"
        case .country:
            return networkInfo?.country ?? "Unknown"
            
        }
    }
    
}
