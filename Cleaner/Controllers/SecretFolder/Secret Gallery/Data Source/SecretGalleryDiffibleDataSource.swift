//
//  SecretGalleryDiffibleDataSource.swift
//

import UIKit
import Photos

final class SecretGalleryDiffibleDataSource: UICollectionViewDiffableDataSource<Int, SFGalleryStorageAsset> {
    
    // MARK: - Public Properties
    
    var contentView: SecretGalleryView? = nil
    
    var selectedItemsSet = Set<SFGalleryStorageAsset>()
    
}

// MARK: - Public Methods

extension SecretGalleryDiffibleDataSource {
    
    func selectedItemsCount() -> Int {
        return selectedItemsSet.count
    }
    
    func removeSelectedItems() {
        
        var snapshot = snapshot()
        snapshot.deleteItems(Array(selectedItemsSet))
        selectedItemsSet.removeAll()
        contentView?.setItemsForCleanCount(self.selectedItemsCount())
        apply(snapshot, animatingDifferences: true)
        contentView?.showBlur()
        
    }
    
}
