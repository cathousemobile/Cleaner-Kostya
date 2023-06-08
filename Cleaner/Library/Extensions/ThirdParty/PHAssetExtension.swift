//
//  PHAssetExtension.swift
//  Created at 19.12.2022.
//

import Foundation
import Photos


extension PHAsset {
    var score: Int {
        var score = 0
        
        if self.isFavorite {
            score += 1
        }
        
        return score
    }
}
