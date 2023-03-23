//
//  SystemInfoNetworkModel.swift
//

enum SystemInfoNetworkModel {
    
    private typealias Text = Generated.Text.Network
    
    case wifi
    case ip
    case cellular
    
    enum Wifi: String, CaseIterable {
        
        case connected
        case ipAdress
        case netmaskAdress
        case broadcastAdress
        case routerAdress
        
        var titleText: String {
            switch self {
            
            case .connected:
                return Text.conectedWifi
            case .ipAdress:
                return Text.wifiIP
            case .netmaskAdress:
                return Text.wifiNetmask
            case .broadcastAdress:
                return Text.wifiBroadcast
            case .routerAdress:
                return Text.wifiRouter
            }
        }
        
    }
    
    enum Ip: String, CaseIterable {
        
        case currentIp
        case externalIp
        case cellIp
        case cellNetmask
        case cellBroadcast
        
        var titleText: String {
            switch self {
            
            case .currentIp:
                return Text.currentIp
            case .externalIp:
                return Text.externalIp
            case .cellIp:
                return Text.cellIp
            case .cellNetmask:
                return Text.cellNetmask
            case .cellBroadcast:
                return Text.cellBroadcast
            }
        }
        
    }
    
    enum Cellular: String, CaseIterable {
        
        case name
        case country
        case mobileCountryCode
        case isoCountryCode
        case mobileNetworkCode
        
        var titleText: String {
            switch self {
            
            case .name:
                return Text.carrierName
            case .country:
                return Text.carrierCountry
            case .mobileCountryCode:
                return Text.carrierMobileCountryCode
            case .isoCountryCode:
                return Text.carrierIsoCountryCode
            case .mobileNetworkCode:
                return Text.carrierMobileNetworkCode
            }
        }
        
    }
    
}
