//
//  SFGalleryStorageMedia.swift
//

import Foundation


struct SFGalleryStorageAsset: Hashable, Codable {
    let url: URL
    let type: MediaType
    let thumbnailData: Data?
    
    enum MediaType: Hashable, Codable {
        case photo, video
    }
}
