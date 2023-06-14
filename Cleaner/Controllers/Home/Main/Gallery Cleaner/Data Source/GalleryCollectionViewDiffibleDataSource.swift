//
//  GalleryCollectionViewDiffibleDataSource.swift
//

import UIKit
import Photos
import SPAlert

final class GalleryCollectionViewDiffibleDataSource: UICollectionViewDiffableDataSource<Int, PHAsset> {
    
    // MARK: - Public Properties
    
    
    var dataArrayType: GalleryCleanerViewController.ArrayType? = nil
    
    var contentView: GalleryCleanerView? = nil
    
    var selectedItemsDictionary = [Int : Set<PHAsset>]()
    
    // MARK: - Override
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                               withReuseIdentifier: "HCollectionReusableView",
                                                                               for: indexPath) as! GalleryCleanerSectionHeaderView
            
            reusableview.setItemsCount(snapshot().itemIdentifiers(inSection: indexPath.section).count)
            
            reusableview.isSelect = selectedItemsDictionary.keys.contains(indexPath.section) ? false : true
            
            reusableview.section = indexPath.section
            
            reusableview.setAction { [weak self] in
                
                if let self = self {
                    
                    if self.selectedItemsDictionary[indexPath.section] != nil {
                        
                        self.selectedItemsDictionary.removeValue(forKey: indexPath.section)
                        
                        for i in 0...self.snapshot().itemIdentifiers(inSection: indexPath.section).count {
                            let newIndexPath = IndexPath(row: i, section: indexPath.section)
                            
                            if let cell = collectionView.cellForItem(at: newIndexPath) as? GalleryDefaultCollectionCell {
                                cell.mediaIsSelected = false
                            }
                            
                        }
                        
                        reusableview.isSelect = true
                        
                    } else {
                        
                        for i in 1...self.snapshot().itemIdentifiers(inSection: indexPath.section).count {
                            let newIndexPath = IndexPath(row: i, section: indexPath.section)
                            
                            if let cell = collectionView.cellForItem(at: newIndexPath) as? GalleryDefaultCollectionCell {
                                cell.mediaIsSelected = true
                            }
                            
                        }
                        
                        self.selectedItemsDictionary[indexPath.section] = Set(self.snapshot().itemIdentifiers(inSection: indexPath.section))
                        self.selectedItemsDictionary[indexPath.section]?.remove(self.snapshot().itemIdentifiers(inSection: indexPath.section)[0])
                        
                        reusableview.isSelect = false
                        
                    }
                    
                    if let contentView = self.contentView {
                        contentView.setItemsForCleanCount(self.selectedItemsCount())
                    }
                    
                }
            }
            
            return reusableview
            
        default:  fatalError("Unexpected element kind")
            
        }
        
    }
    
}

// MARK: - Public Methods

extension GalleryCollectionViewDiffibleDataSource {
    
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
        
        let snapshot = snapshot()
        
        if snapshot.itemIdentifiers.isEmpty {
            SPAlert.present(message: Generated.Text.Common.nothingToDelete, haptic: .none)
            return
        }
        
        if !keys.isEmpty {
            
            var deletedItems = [PHAsset]()
            
            keys.forEach { section in
                if let value = selectedItemsDictionary[section] {
                    deletedItems += snapshot.itemIdentifiers(inSection: section).filter {value.contains($0)}
                }
            }
            
            if !deletedItems.isEmpty {
                
                MatchedImageFinder.shared.deleteAssets(deletedItems) { [weak self] error in
                    
                    guard let self = self else { return }
                    guard error == nil else { return }
                    
                    self.selectedItemsDictionary.removeAll()
                    
                    self.contentView?.setItemsForCleanCount(self.selectedItemsCount())
                    self.contentView?.showBlur()
                    
                }
                
            }
            
        } else {
            
            MatchedImageFinder.shared.deleteAssets(snapshot.itemIdentifiers) { [weak self] error in
                
                guard let self = self else { return }
                guard error == nil else { return }
                
                self.contentView?.setItemsForCleanCount(self.selectedItemsCount())
                self.contentView?.showBlur()
                
            }

        }
        
    }
    
}
