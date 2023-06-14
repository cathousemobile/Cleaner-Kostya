//
//  SecretGalleryDiffibleDataSource.swift
//

import UIKit
import Photos

final class SecretGalleryDiffibleDataSource: UICollectionViewDiffableDataSource<Int, GalleryHandlerAsset> {
    
    // MARK: - Public Properties
    
    var contentView: SecretGalleryView? = nil
    
    var selectedItemsSet = Set<GalleryHandlerAsset>()
    
}

// MARK: - Public Methods

extension SecretGalleryDiffibleDataSource {
    
    func selectedItemsCount() -> Int {
        return selectedItemsSet.count
    }
    
    func removeSelectedItems() {
        selectedItemsSet.removeAll()
        contentView?.setItemsForCleanCount(selectedItemsCount())
        contentView?.showBlur()
    }
    
}
