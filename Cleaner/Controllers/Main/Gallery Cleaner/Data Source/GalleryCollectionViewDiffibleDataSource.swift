//
//  GalleryCollectionViewDiffibleDataSource.swift
//

import UIKit
import Photos

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
            
            reusableview.setAction { [weak self] in
                
                if let self = self {
                    
                    if self.selectedItemsDictionary[indexPath.section] != nil {
                        
                        self.selectedItemsDictionary.removeValue(forKey: indexPath.section)
                        
                        for i in 0...self.snapshot().itemIdentifiers(inSection: indexPath.section).count {
                            let newIndexPath = IndexPath(row: i, section: indexPath.section)
                            collectionView.cellForItem(at: newIndexPath)?.isSelected = false
                        }
                        
                        reusableview.isSelect = true
                        
                    } else {
                        
                        for i in 1...self.snapshot().itemIdentifiers(inSection: indexPath.section).count {
                            let newIndexPath = IndexPath(row: i, section: indexPath.section)
                            if let cell = collectionView.cellForItem(at: newIndexPath) {
                                cell.isSelected = true
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
                    
                    if self.dataArrayType == .similarVideos || self.dataArrayType == .similarPhotos {
                        let empties = snapshot.sectionIdentifiers.filter { snapshot.numberOfItems(inSection: $0) <= 1 }
                        snapshot.deleteSections(empties)
                    }
                    
                    self.contentView?.setItemsForCleanCount(self.selectedItemsCount())
                    self.apply(snapshot, animatingDifferences: true)
                    
                }
                
            }
            
        } else {
            snapshot.deleteAllItems()
        }
        
    }
    
}
