//
//  SecretGalleryViewController.swift
//

import UIKit
import Photos
import SPAlert
import Agrume
import AVKit

final class SecretGalleryViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private var imagePickerVC = UIViewController()
    
    private let contentView = SecretGalleryView()
    
    private let selectButton = UIBarButtonItem()
    
    // MARK: - Public Proporties
    
    // MARK: - Private Proporties
    
    private var updateDispatchGroup = DispatchGroup()
    
    private var contentShouldBeSelect = false
    
    private var dataSource: SecretGalleryDiffibleDataSource!
    
    private var currentContentArray: [GalleryHandlerAsset] = [GalleryHandlerAsset]() {
        didSet {
            initDataSource()
            initSnapshot()
            contentView.hideEmptyDataTitle(!currentContentArray.isEmpty)
            updateDispatchGroup.leave()
        }
    }
    
    // MARK: - Life cycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Generated.Text.Main.galleryCleaner
        initGallery()
        setupActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAccess()
        contentView.showBlur()
    }
    
}

// MARK: - Init

extension SecretGalleryViewController {
    
    func fullAccess() {
        
    }
    
    func limitedAccess() {
        DispatchQueue.main.async {
            AppCoordiator.shared.routeToSettings(Generated.Text.GalleryCleaner.limitedAccess, currentVC: self, isLimitedAccess: true)
        }
    }
    
    func deniedAccess() {
        DispatchQueue.main.async {
            AppCoordiator.shared.routeToSettings(Generated.Text.ContactCleaner.permissionRequared, currentVC: self)
        }
    }
    
    func checkAccess() {
        MatchedImageFinder.shared.requestAccess(fullAccessGranted: fullAccess, limitedAccessGranted: limitedAccess, needShowDeniedAlert: deniedAccess)
    }
    
    func initGallery() {
        fetchMedia()
        configureCollectionView()
        initNavigationBarItems()
        subscribeToNotifications()
    }
    
}

// MARK: - CollectionView Config

private extension SecretGalleryViewController {
    
    func configureCollectionView() {
        contentView.collectionView.collectionViewLayout = makeCollectionViewLayout()
        contentView.collectionView.delegate = self
        contentView.collectionView.register(GalleryDefaultCollectionCell.self, forCellWithReuseIdentifier: "defaultGalleryCell")
    }
    
}

// MARK: - CollectionView Sections Config

private extension SecretGalleryViewController {
    
    func makeTripletLayoutSection() -> NSCollectionLayoutSection {
        
        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                                    heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        
        let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .fractionalWidth(1/3))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupLayoutSize,
                                                       subitem: item, count: 3)
        
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(3)
        group.contentInsets = NSDirectionalEdgeInsets(top: 1.5, leading: 0, bottom: 1.5, trailing: 0)
        
        return NSCollectionLayoutSection(group: group)
        
    }
    
}

// MARK: - CollectionView Layout Config

extension SecretGalleryViewController {
    
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            self?.makeTripletLayoutSection()
        }
        
    }
    
}

// MARK: - CollectionView Deleagate

extension SecretGalleryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? GalleryDefaultCollectionCell, dataSource.selectedItemsSet.compactMap({$0.url.absoluteString}) .contains(cell.galleryStorageAssetStringURL) {
            cell.mediaIsSelected = true
        }
        
    }
    
}

// MARK: - CollectionView Datasource

extension SecretGalleryViewController {
    
    func initDataSource() {
        
        dataSource = SecretGalleryDiffibleDataSource(collectionView: contentView.collectionView,
                                                     cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "defaultGalleryCell", for: indexPath) as! GalleryDefaultCollectionCell
            
            cell.galleryStorageAssetStringURL = itemIdentifier.url.absoluteString
            
            if let imageData = itemIdentifier.thumbnailData {
                DispatchQueue.main.async {
                    cell.setImage(UIImage(data: imageData))
                }
            }
            
            cell.setTapAction { [weak self] in
                guard let self = self else { return }
                
                if self.contentShouldBeSelect {
                    
                    if self.dataSource.selectedItemsSet.contains(itemIdentifier) {
                        self.dataSource.selectedItemsSet.remove(itemIdentifier)
                        cell.mediaIsSelected = false
                        
                    } else {
                        self.dataSource.selectedItemsSet.insert(itemIdentifier)
                        cell.mediaIsSelected = true
                        
                    }
                    
                    self.contentView.setItemsForCleanCount((self.dataSource.selectedItemsCount()))
                }
                
            }
            
            cell.setLongPressAction { [weak self] in
                guard let self = self else { return }
                
                guard let image = cell.getImage() else { return }
                let agrume = Agrume(image: image, background: .colored(Generated.Color.mainBackground))
                agrume.show(from: self)
                    
            }
            
            return cell
        })
        
        dataSource.contentView = contentView
        
    }
    
    func initSnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, GalleryHandlerAsset>()
        
        snapshot.appendSections([0])
        
        snapshot.appendItems(currentContentArray, toSection: 0)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
        
    }
    
}

// MARK: - Handlers

private extension SecretGalleryViewController {
    
    // MARK: - Fetch Handlers
    
    func fetchMedia() {
        updateDispatchGroup.enter()
        currentContentArray = GalleryHandler.shared.getAll().removedDuplicates()
    }
    
    // MARK: - NavigationBar Handlers
    
    @objc func selectAction() {
        
        contentShouldBeSelect.toggle()
        
        if contentShouldBeSelect {
            selectButton.title = Generated.Text.Common.cancel
            selectButton.tintColor = Generated.Color.redWarning
            contentView.setAddCleanButtonTitle(Generated.Text.Common.clean)
            contentView.setCleanAction(clearAction)
            
        } else {
            selectButton.title = Generated.Text.Common.select
            selectButton.tintColor = Generated.Color.selectedText
            dataSource.selectedItemsSet = []
            contentView.collectionView.visibleCells.compactMap({$0 as? GalleryDefaultCollectionCell}).forEach {$0.mediaIsSelected = false}
            contentView.setAddCleanButtonTitle(Generated.Text.SecretGallery.addMedia)
            contentView.setCleanAction(addMediaToSecretFolder)
            
        }
        
    }
    
    func clearAction() {
        
        let alertVC = UIAlertController(title: Generated.Text.Common.deleteSelectedContent, message: nil, preferredStyle: .actionSheet)
        let deleteItemsCount = dataSource.selectedItemsCount() == 0 ? dataSource.snapshot().numberOfItems : dataSource.selectedItemsCount()
        let deleteAction = UIAlertAction(title: Generated.Text.Common.deleteWithCount(String(deleteItemsCount)), style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.deleteMediaFromSecretFolder(self.dataSource.selectedItemsCount() == 0 ? self.dataSource.snapshot().itemIdentifiers : Array(self.dataSource.selectedItemsSet))
        }
        
        alertVC.addAction(deleteAction)
        alertVC.addAction(.init(title: Generated.Text.Common.cancel, style: .cancel))
        
        present(alertVC, animated: true)
        
    }
    
    // MARK: - Add Handler
    
    func addMediaToSecretFolder() {
        
       imagePickerVC = GalleryHandler.shared.chooseFromGalleryController(allowMultiplySelection: true) { [weak self] vc, assets in
           guard let self = self else { return }
           GalleryHandler.shared.save(assets)
           self.imagePickerVC.dismiss(animated: true)
        }
        
        present(imagePickerVC, animated: true)
        
    }
    
    // MARK: - Delete Handler
    
    func deleteMediaFromSecretFolder(_ assetsArray: [GalleryHandlerAsset]) {
        if GalleryHandler.shared.delete(assetsArray) {
            dataSource.removeSelectedItems()
            SPAlert.present(title: Generated.Text.Common.deleted, preset: .done)
        } else {
            SPAlert.present(title: "Error", preset: .error)
        }
    }
    
    // MARK: - Check Handler
    
    func checkState() {
        
        if currentContentArray.isEmpty {
            contentShouldBeSelect = false
        }
        
        if contentShouldBeSelect && !currentContentArray.isEmpty {
            selectButton.title = Generated.Text.Common.cancel
            selectButton.tintColor = Generated.Color.redWarning
            contentView.setAddCleanButtonTitle(Generated.Text.Common.clean)
            contentView.setCleanAction(clearAction)
            
        } else {
            selectButton.title = Generated.Text.Common.select
            selectButton.tintColor = Generated.Color.selectedText
            dataSource.selectedItemsSet = []
            contentView.collectionView.visibleCells.compactMap({$0 as? GalleryDefaultCollectionCell}).forEach {$0.mediaIsSelected = false}
            contentView.setAddCleanButtonTitle(Generated.Text.SecretGallery.addMedia)
            contentView.setCleanAction(addMediaToSecretFolder)
            
        }
        
    }
    
}

// MARK: - Public Methods

extension SecretGalleryViewController {
    
}

// MARK: - Private Methods

private extension SecretGalleryViewController {
    
    func setupActions() {
        contentView.setCleanAction(addMediaToSecretFolder)
    }
    
    func subscribeToNotifications() {
        
        NotificationRelay.observe(event: .galleryStorageUpdated) { [weak self] in
            guard let self = self else { return }
            
            self.fetchMedia()
            
            self.updateDispatchGroup.notify(queue: .main) {
                self.contentView.showBlur()
                self.configureRightButton()
                self.checkState()
            }
            
        }
        
    }
    
}

// MARK: - Navigation

private extension SecretGalleryViewController {
    
}

// MARK: - Layout Setup

private extension SecretGalleryViewController {
    
}

// MARK: - NavigationBar Config

extension SecretGalleryViewController {
    
    func initNavigationBarItems() {
        configureRightButton()
    }
    
    func configureRightButton() {
        
        if currentContentArray.isEmpty {
            self.navigationItem.rightBarButtonItem = nil
            return
        }
        
        selectButton.title = Generated.Text.Common.select
        selectButton.style = .plain
        selectButton.target = self
        selectButton.action = #selector(selectAction)
        selectButton.tintColor = Generated.Color.selectedText
        
        self.navigationItem.rightBarButtonItem = selectButton
        
    }
    
}
