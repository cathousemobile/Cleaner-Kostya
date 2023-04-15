//
//  TimeInterval+Extension.swift
//

import Foundation

extension TimeInterval{
    
    func stringFromTimeInterval() -> String {
        
        let time = NSInteger(self)
        
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return String(format: "%0.2d h %0.2d m %0.2d s",hours,minutes,seconds)
        
    }
    
}
