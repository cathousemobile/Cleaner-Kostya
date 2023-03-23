//
//  DeviceSize.swift
//  Cleaner
//

import Foundation
import UIKit

public enum DeviceSize {

    public static var isSmall: Bool {
        UIScreen.main.bounds.height < 668
    }

    public static var isMedium: Bool {
        UIScreen.main.bounds.height < 845
    }
    
    public static var isBig: Bool {
        UIScreen.main.bounds.height < 1000
    }

}

//let height = UIScreen.main.bounds.size.height
//            print("Device height: \(height)")
//            switch height {
//            case 480.0:
//                print("iPhone 3 | iPhone 4 | iPhone 4S")
//            case 568.0:
//                print("iPhone 5 | iPhone 5S | iPhone 5C | iPhone SE")
//            case 667.0:
//                print("iPhone 6 | iPhone 7 | iPhone 8 | iPhone SE(2nd gen)")
//            case 736.0:
//                print("iPhone 6+ | iPhone 7+ | iPhone 8+")
//            case 780.0:
//                print("iPhone 12 Mini")
//            case 812.0:
//                print("iPhone X | iPhone XS | iPhone 11 Pro")
//            case 844.0:
//                print("iPhone 12 | iPhone 12 Pro")
//            case 896.0:
//                print("iPhone XR | iPhone XS Max | iPhone 11 | iPhone 11 Pro Max")
//            case 926.0:
//                print("iPhone 12 Pro Max")
//            case 1024.0:
//                print("iPad 1st gen | iPad 2 | iPad 3rd gen | iPad mini | iPad 4th gen | iPad Air | iPad mini 2 | iPad mini 3 | iPad Air 2 | iPad mini 4 | iPad 5th gen | iPad 6th gen | iPad  mini 5")
//            case 1112.0:
//                print("iPad Pro 2nd gen 10.5'' | iPad Air 3")
//            case 1194.0:
//                print("iPad Pro 3rd gen 11.0'' | iPad Pro 4th gen 11.0''")
//            case 1366.0:
//                print("iPad Pro 1st gen 12.9'' | iPad 2nd gen 12.9'' | iPad 3rd gen 12.9'' | iPad Pro 4th gen 12.9''")
//            default:
//                print("not listed in function")
//            }
