//
//  SystemInfoScreenTestModel.swift
//

import UIKit

enum SystemInfoScreenTestModel: CaseIterable {
    
    case red
    case green
    case blue
    case gray
    case white
    case dark
    
    var color: UIColor {
        switch self {
        case .red:
            return Generated.Color.redTest
        case .green:
            return Generated.Color.greenTest
        case .blue:
            return Generated.Color.blueTest
        case .gray:
            return Generated.Color.grayTest
        case .white:
            return .white
        case .dark:
            return Generated.Color.darkTest
        }
    }
    
}
