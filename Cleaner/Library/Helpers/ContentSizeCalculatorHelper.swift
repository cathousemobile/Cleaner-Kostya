//
//  SizeCalculator.swift
//

import Foundation

class ContentSizeCalculatorHelper {
    
    var otherSizeEquals: Float {
        
        if let totalSpace = PlatformInfo.Device.totalSpace, let freeSpace = PlatformInfo.Device.freeSpace {
            return Float((Float(totalSpace) - Float(freeSpace)) / Float(totalSpace))
        } else {
            return 0
        }
        
    }
    
    var mediaSizeEquals: Float {
        
        if let totalSpace = PlatformInfo.Device.totalSpace {
            let mediaSize = MatchedImageFinder.shared.getSizeOf(.allScreenshots) + MatchedImageFinder.shared.getSizeOf(.photoDuplicates) + MatchedImageFinder.shared.getSizeOf(.videoDuplicates)
            return Float(Float(mediaSize) / Float(totalSpace))
        } else {
            return 0
        }
        
    }
    
    var contactsSizeEquals: Float {
        
        if let totalSpace = PlatformInfo.Device.totalSpace {
            let contactsSize = ContactReplicaScanner.shared.getSizeOf(.fullDuplicates)
            return Float(Float(contactsSize) / Float(totalSpace))
        } else {
            return 0
        }
        
    }
    
    var useSpace: String {
        
        if let totalSpace = PlatformInfo.Device.totalSpace, let freeSpace = PlatformInfo.Device.freeSpace {
            return BinaryFormatter(bytes: totalSpace - freeSpace).prettyFormat().formatted
        } else {
            return "0"
        }
        
    }
    
    var totalSpace: String {
        if let totalSpace = PlatformInfo.Device.totalSpace {
            return BinaryFormatter(bytes: totalSpace).prettyFormat().formatted
        } else {
            return "0"
        }
    }
    
}
