//
//  SecretGalleryDiffibleDataSource.swift
//

import UIKit
import Photos

final class SecretGalleryDiffibleDataSource: UICollectionViewDiffableDataSource<Int, PHAsset> {
    
    // MARK: - Public Properties
    
    var contentView: SecretGalleryView? = nil
    
    var selectedItemsDictionary = [Int : Set<PHAsset>]()
    
}

// MARK: - Public Methods

extension SecretGalleryDiffibleDataSource {
    
    func selectedItemsCount() -> Int {
        
        var count: Int = 0
        
        let keys = Array(selectedItemsDictionary.compactMap( {$0.key} ))
        
        if !keys.isEmpty {
            keys.forEach { if let valuesCount = selectedItemsDictionary[$0]?.count { count += valuesCount } }
        }
        
        return count
        
    }
    
    func removeSelectedItems() {
        
        let keys = Array(selectedItemsDictionary.compactMap( {$0.key} ))
        
        var snapshot = snapshot()
        
        if !keys.isEmpty {
            
            var deletedItems = [PHAsset]()
            
            keys.forEach { section in
                if let value = selectedItemsDictionary[section] {
                    deletedItems += snapshot.itemIdentifiers(inSection: section).filter {value.contains($0)}
                }
            }
            
            if !deletedItems.isEmpty {
                
                SFGalleryFinder.shared.deleteAssets(deletedItems) { [weak self] error in
                    
                    guard let self = self else { return }
                    guard error == nil else { return }
                    
                    snapshot.deleteItems(deletedItems)
                    self.selectedItemsDictionary.removeAll()
                    
                    self.contentView?.setItemsForCleanCount(self.selectedItemsCount())
                    self.apply(snapshot, animatingDifferences: true)
                    self.contentView?.showBlur()
                    
                }
                
            }
            
        } else {
            
            SFGalleryFinder.shared.deleteAssets(snapshot.itemIdentifiers) { [weak self] error in
                
                guard let self = self else { return }
                guard error == nil else { return }
                
                snapshot.deleteAllItems()
                self.apply(snapshot, animatingDifferences: true)
                self.contentView?.showBlur()
                
            }

        }
        
    }
    
}
