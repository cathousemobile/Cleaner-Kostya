//
//  SFGalleryFinderType.swift


import Foundation

enum SFGalleryFinderType {
    
    /// Вся галерея (фото, скриншоты и видео)
    case allGallery
    
    /// Все фото на устройстве (исключая скриншоты)
    case allPhotos
    
    /// Все видео на устройстве
    case allVideos
    
    /// Все скриншоты на устройстве
    case allScreenshots
    
    /// Дубликаты фото
    case photoDuplicates
    
    /// Дубликаты видео
    case videoDuplicates
}
