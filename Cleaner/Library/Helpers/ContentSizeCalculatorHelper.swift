//
//  SizeCalculator.swift
//

import Foundation

class ContentSizeCalculatorHelper {
    
    var otherSizeEquals: Float {
        
        if let totalSpace = SFSystemInfo.Device.totalSpace, let freeSpace = SFSystemInfo.Device.freeSpace {
            return Float((Float(totalSpace) - Float(freeSpace)) / Float(totalSpace))
        } else {
            return 0
        }
        
    }
    
    var mediaSizeEquals: Float {
        
        if let totalSpace = SFSystemInfo.Device.totalSpace {
            let mediaSize = SFGalleryFinder.shared.getSizeOf(.allScreenshots) + SFGalleryFinder.shared.getSizeOf(.photoDuplicates) + SFGalleryFinder.shared.getSizeOf(.videoDuplicates)
            return Float(Float(mediaSize) / Float(totalSpace))
        } else {
            return 0
        }
        
    }
    
    var contactsSizeEquals: Float {
        
        if let totalSpace = SFSystemInfo.Device.totalSpace {
            let contactsSize = SFContactFinder.shared.getSizeOf(.fullDuplicates)
            return Float(Float(contactsSize) / Float(totalSpace))
        } else {
            return 0
        }
        
    }
    
    var useSpace: String {
        
        if let totalSpace = SFSystemInfo.Device.totalSpace, let freeSpace = SFSystemInfo.Device.freeSpace {
            return SFByteFormatter(bytes: totalSpace - freeSpace).prettyFormat().formatted
        } else {
            return "0"
        }
        
    }
    
    var totalSpace: String {
        if let totalSpace = SFSystemInfo.Device.totalSpace {
            return SFByteFormatter(bytes: totalSpace).prettyFormat().formatted
        } else {
            return "0"
        }
    }
    
}
