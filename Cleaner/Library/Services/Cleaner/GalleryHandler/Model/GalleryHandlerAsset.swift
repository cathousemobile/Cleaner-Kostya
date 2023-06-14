//
//  GalleryHandlerMedia.swift
//

import Foundation


struct GalleryHandlerAsset: Hashable, Codable {
    let url: URL
    let type: MediaType
    let thumbnailData: Data?
    
    enum MediaType: Hashable, Codable {
        case photo, video
    }
}
