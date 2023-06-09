//
//  GalleryCleanerViewController.swift
//

import UIKit
import Photos
import SPAlert
import Agrume
import AVKit

final class GalleryCleanerViewController: UIViewController {
    
    enum ArrayType {
        case allContent
        case similarPhotos
        case similarVideos
        case screenshots
    }
    
    // MARK: - UI Elements
    
    private let contentView = GalleryCleanerView()
    
    private let selectButton = UIBarButtonItem()
    
    // MARK: - Public Proporties
    
    // MARK: - Private Proporties
    
    private lazy var isDeliting = false
    private var contentShouldBeSelect = false
    private lazy var wasChecked = false
    
    private let dispatchGroup = DispatchGroup()
    
    private var avAsset: AVURLAsset? {
        didSet {
            DispatchQueue.main.async {
                self.playVideo()
            }
        }
    }
    
    private var agrumeImage: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.showImage()
            }
        }
    }
    
    private var dataArrayType: ArrayType = .allContent {
        didSet {
            fetchMedia()
            if oldValue != dataArrayType {
                contentView.collectionView.collectionViewLayout = makeCollectionViewLayout()
            }
        }
    }
    
    private var dataSource: GalleryCollectionViewDiffibleDataSource!
    
    private var currentContentArray: [PHAsset] = [PHAsset]() {
        didSet {
            contentView.hideEmptyDataTitle(!currentContentArray.isEmpty)
            configureRightButton()
        }
    }
    
    private var currentDuplicateContentArray: [Int : [PHAsset]] = [Int : [PHAsset]]() {
        didSet {
            contentView.hideEmptyDataTitle(!currentDuplicateContentArray.isEmpty)
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
        setupHeaderActions()
        if !wasChecked {
            checkAccess()
        }
    }
    
}

// MARK: - Init

extension GalleryCleanerViewController {
    
    func fullAccess() {
        
        wasChecked = true
        
        if MatchedImageFinder.shared.inProcess {
            DispatchQueue.main.async {
                SPAlert.present(message: Generated.Text.Common.inProcess, haptic: .warning)
            }
        } else {
            fetchMedia()
        }
        
    }
    
    func limitedAccess() {
        DispatchQueue.main.async {
            AppCoordiator.shared.routeToSettings(Generated.Text.GalleryCleaner.limitedAccess, currentVC: self, isLimitedAccess: true)
        }
    }
    
    func deniedAccess() {
        DispatchQueue.main.async {
            AppCoordiator.shared.routeToSettings(Generated.Text.GalleryCleaner.permissionRequared, currentVC: self)
        }
    }
    
    func checkAccess() {
        MatchedImageFinder.shared.requestAccess(fullAccessGranted: fullAccess, limitedAccessGranted: limitedAccess, needShowDeniedAlert: deniedAccess)
    }
    
    func initGallery() {
        configureCollectionView()
        initNavigationBarItems()
        subscribeToNotifications()
    }
    
}

// MARK: - CollectionView Config

private extension GalleryCleanerViewController {
    
    func configureCollectionView() {
        contentView.collectionView.collectionViewLayout = makeCollectionViewLayout()
        contentView.collectionView.delegate = self
        contentView.collectionView.register(GalleryDefaultCollectionCell.self, forCellWithReuseIdentifier: "defaultGalleryCell")
        contentView.collectionView.register(GalleryCleanerSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HCollectionReusableView")
    }
    
}

// MARK: - CollectionView Sections Config

private extension GalleryCleanerViewController {
    
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
    
    func makeListLayoutSection(_ itemsCount: Int, sectionIndex: Int = 0) -> NSCollectionLayoutSection {
        
        let littleGroupCount = Int(Double((Double(itemsCount) - 1.0) / 3.0).rounded(.up))
        
        let bigItemLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .fractionalWidth(1))
        
        let bigItem = NSCollectionLayoutItem(layoutSize: bigItemLayoutSize)
        
        let littleItemLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                                          heightDimension: .fractionalWidth(1/3))
        
        let littleItem = NSCollectionLayoutItem(layoutSize: littleItemLayoutSize)
        
        
        let littleGroupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                           heightDimension: .fractionalWidth(1/3))
        
        let littleGroup = NSCollectionLayoutGroup.horizontal(layoutSize: littleGroupLayoutSize,
                                                             subitem: littleItem, count: 3)
        
        littleGroup.interItemSpacing = NSCollectionLayoutSpacing.fixed(3)
        littleGroup.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0)
        
        let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .estimated(300))
        
        var subitems: [NSCollectionLayoutItem] = Array(repeating: littleGroup, count: littleGroupCount)
        subitems.insert(bigItem, at: 0)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupLayoutSize,
                                                     subitems: subitems)
        
        let section = NSCollectionLayoutSection(group: group)
        
        if itemsCount > 0 && itemsCount != 1 {
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(44))
            
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                            elementKind: UICollectionView.elementKindSectionHeader,
                                                                            alignment: .top)
            
            section.boundarySupplementaryItems = [sectionHeader]
            
        }
        
        return section
        
    }
    
    func getSectionItemsCount(_ sectionIndex: Int) -> Int {
        let snap = dataSource.snapshot()
        let section = snap.sectionIdentifiers[sectionIndex]
        return snap.numberOfItems(inSection: section)
    }
    
}

// MARK: - CollectionView Layout Config

extension GalleryCleanerViewController {
    
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            
            switch self?.dataArrayType {
                
            case .allContent, .screenshots:
                return self?.makeTripletLayoutSection()
                
            case .similarVideos, .similarPhotos:
                guard let itemsCount = self?.getSectionItemsCount(sectionIndex) else { return self?.makeListLayoutSection(0) }
                return self?.makeListLayoutSection(itemsCount, sectionIndex: sectionIndex)
                
            case .none:
                return self?.makeTripletLayoutSection()
                
            }
            
        }
        
    }
    
}

// MARK: - CollectionView Deleagate

extension GalleryCleanerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? GalleryDefaultCollectionCell {
            if let isContained = dataSource.selectedItemsDictionary[indexPath.section]?.contains(cell.phAsset), isContained {
                
                switch dataArrayType {
                case .allContent, .screenshots:
                    cell.mediaIsSelected = true
                case .similarPhotos, .similarVideos:
                    cell.mediaIsSelected = indexPath.row != 0
                }
                
            } else {
                cell.mediaIsSelected = false
            }
        }
        
    }
    
}

// MARK: - CollectionView Datasource

extension GalleryCleanerViewController {
    
    func initDataAndSnap() {
        
        dispatchGroup.notify(queue: .main) {
            self.initDataSource()
            self.initSnapshot()
        }
        
    }
    
    func initDataSource() {
        
        switch dataArrayType {
            
        case .allContent, .screenshots:
            dataSource = GalleryCollectionViewDiffibleDataSource(collectionView: contentView.collectionView,
                                                                 cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "defaultGalleryCell", for: indexPath) as! GalleryDefaultCollectionCell
                
                cell.phAsset = itemIdentifier
                
                DispatchQueue.main.async {
                    MatchedImageFinder.shared.fetchImage(for: itemIdentifier) { cell.setImage($0) }
                }
                
                cell.setTapAction { [weak self] in
                    guard let self = self else { return }
                    
                    if self.contentShouldBeSelect {

                        if let isContained = self.dataSource.selectedItemsDictionary[indexPath.section]?.contains(itemIdentifier), isContained {

                            self.dataSource.selectedItemsDictionary[indexPath.section]?.remove(itemIdentifier)
                            cell.mediaIsSelected = false

                        } else {

                            if self.dataSource.selectedItemsDictionary[indexPath.section] != nil {
                                self.dataSource.selectedItemsDictionary[indexPath.section]?.insert(itemIdentifier)
                            } else {
                                self.dataSource.selectedItemsDictionary[indexPath.section] = [itemIdentifier]
                            }

                            cell.mediaIsSelected = true

                        }
                        
                        self.contentView.setItemsForCleanCount((self.dataSource.selectedItemsCount()))
                        
                    }
                    
                }
                
                cell.setLongPressAction { [weak self] in
                    guard let self = self else { return }
                    
                    MatchedImageFinder.shared.fetchVideoURLAsset(for: itemIdentifier) { avAsset in
                        if let avAsset = avAsset {
                            self.avAsset = avAsset
                        } else {
                            DispatchQueue.main.async {
                                self.agrumeImage = cell.getImage()
                            }
                        }
                    }
                    
                }
                
                return cell
            })
            
        case .similarPhotos, .similarVideos:
            dataSource = GalleryCollectionViewDiffibleDataSource(collectionView: contentView.collectionView,
                                                                 cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "defaultGalleryCell", for: indexPath) as! GalleryDefaultCollectionCell

                cell.isUserInteractionEnabled = true
                
                
                
                cell.phAsset = itemIdentifier
                
                DispatchQueue.main.async {
                    MatchedImageFinder.shared.fetchImage(for: itemIdentifier) { cell.setImage($0) }
                }
                
                cell.setTapAction { [weak self] in
                    
                    guard let self = self else { return }
                    
                    if let isContained = self.dataSource.selectedItemsDictionary[indexPath.section]?.contains(itemIdentifier), isContained {

                        self.dataSource.selectedItemsDictionary[indexPath.section]?.remove(itemIdentifier)
                        cell.mediaIsSelected = false
                        
                        if let isEmpty = self.dataSource.selectedItemsDictionary[indexPath.section]?.isEmpty, isEmpty {
                            self.dataSource.selectedItemsDictionary.removeValue(forKey: indexPath.section)
                        }

                    } else {

                        if self.dataSource.selectedItemsDictionary[indexPath.section] != nil {
                            self.dataSource.selectedItemsDictionary[indexPath.section]?.insert(itemIdentifier)
                        } else {
                            self.dataSource.selectedItemsDictionary[indexPath.section] = [itemIdentifier]
                        }

                        cell.mediaIsSelected = true

                    }
                    
                    if let header = collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader).compactMap({$0 as? GalleryCleanerSectionHeaderView}).first(where: {$0.section == indexPath.section}) {
                        if (self.dataSource.selectedItemsDictionary[indexPath.section] == nil || self.dataSource.selectedItemsDictionary[indexPath.section] == []) {
                            header.isSelect = true
                        } else {
                            header.isSelect = false
                        }
                    }

                    self.contentView.setItemsForCleanCount((self.dataSource.selectedItemsCount()))
                    
                }
                
                cell.setLongPressAction { [weak self] in
                    guard let self = self else { return }
                    
                    MatchedImageFinder.shared.fetchVideoURLAsset(for: itemIdentifier) { avAsset in
                        if let avAsset = avAsset {
                            self.avAsset = avAsset
                        } else {
                            DispatchQueue.main.async {
                                self.agrumeImage = cell.getImage()
                            }
                        }
                    }
                    
                }
                
                if self?.currentDuplicateContentArray[indexPath.section]?[0] == itemIdentifier {
                    cell.hideBestPhotoTag(false)
                    cell.setTapAction { }
                    cell.bestContentIsPhoto(self?.dataArrayType != .similarVideos)
                }
                
                return cell
                
            })
            
        }
        
        dataSource.contentView = contentView
        dataSource.dataArrayType = dataArrayType
        
    }
    
    func initSnapshot() {
        
        switch dataArrayType {
            
        case .allContent, .screenshots:
            
            var snapshot = NSDiffableDataSourceSnapshot<Int, PHAsset>()
            
            snapshot.appendSections([0])
            
            snapshot.appendItems(currentContentArray, toSection: 0)
            
            dataSource.apply(snapshot, animatingDifferences: true)
            
        case .similarPhotos, .similarVideos:
            
            var snapshot = NSDiffableDataSourceSnapshot<Int, PHAsset>()
            
            let sections = Array(currentDuplicateContentArray.compactMap( {$0.key} )).sorted(by: { $0 < $1 })
            
            snapshot.appendSections(sections)
            
            sections.forEach { section in
                if let items = currentDuplicateContentArray[section] {
                    snapshot.appendItems(items, toSection: section)
                }
            }
            
            dataSource.apply(snapshot, animatingDifferences: true)
            
        }
        
        showBlur()
        
    }
    
}

// MARK: - Handlers

private extension GalleryCleanerViewController {
    
    // MARK: - UI Handlers
    
    func showBlur() {
        contentView.showBlur(dataArrayType == .similarPhotos || dataArrayType == .similarVideos)
    }
    
    // MARK: - Media Handlers
    
    func showImage() {
        if let agrumeImage = self.agrumeImage {
            let agrume = Agrume(image: agrumeImage, background: .colored(Generated.Color.mainBackground))
            agrume.show(from: self)
        }
    }
    
    func playVideo() {
        if let ass = self.avAsset {
            let playerItem = AVPlayerItem(asset: ass)
            let player = AVPlayer(playerItem: playerItem)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                player.play()
            }
        }
    }
    
    // MARK: - Fetch Handlers
    
    func fetchMedia() {
        
        if MatchedImageFinder.shared.inProcess { return }
        
        dispatchGroup.enter()
        
        switch dataArrayType {
            
        case .allContent:
            fetchGridContent(MatchedImageFinder.shared.getAll)
            
        case .screenshots:
            fetchGridContent(MatchedImageFinder.shared.getScreenshots)
            
        case .similarPhotos:
            fetchDuplicateContent(MatchedImageFinder.shared.getPhotoDuplicates)
            
        case .similarVideos:
            fetchDuplicateContent(MatchedImageFinder.shared.getVideoDuplicates)
            
        }
        
        dispatchGroup.leave()
        
    }
    
    func fetchGridContent(_ fetchFunc: () throws -> [PHAsset]) {
        
        do {

            let assetsArray = try fetchFunc()

            self.currentContentArray = assetsArray
            
            initDataAndSnap()
            
        } catch {
            currentContentArray = []
            initDataAndSnap()
        }
        
    }
    
    func fetchDuplicateContent(_ fetchFunc: () throws -> [[PHAsset]]) {
        
        do {

            let assetsArray = try fetchFunc()
            
            var assetsDictionary = [Int : [PHAsset]]()
            
            if assetsArray.isEmpty {
                currentDuplicateContentArray = [:]
                initDataAndSnap()
                return
            }

            for i in 0..<assetsArray.count {
                assetsDictionary[i] = assetsArray[i]
            }
            
            currentDuplicateContentArray = assetsDictionary
            initDataAndSnap()

        } catch {
            currentDuplicateContentArray = [:]
            initDataAndSnap()
        }
        
    }
    
    // MARK: - Header Handlers
    
    func setupHeaderActions() {
        
        guard let headerView = contentView.collectionView.currentCustomHeaderView as? GalleryCleanerHeaderView else { return }
        
        headerView.setAllContentTagViewAction { [weak self] in
            guard let self = self else { return }
            self.headerTagAction(for: .allContent, with: Generated.Text.GalleryCleaner.allContentTag)
        }
        
        headerView.setSimilarPhotosTagViewAction { [weak self] in
            guard let self = self else { return }
            self.headerTagAction(for: .similarPhotos, with: Generated.Text.GalleryCleaner.similarPhotosTag)
        }
        
        headerView.setSimilarVideosTagViewAction { [weak self] in
            guard let self = self else { return }
            self.headerTagAction(for: .similarVideos, with: Generated.Text.GalleryCleaner.similarVideosTag)
        }
        
        headerView.setScreenshotsTagViewAction { [weak self] in
            guard let self = self else { return }
            self.headerTagAction(for: .screenshots, with: Generated.Text.GalleryCleaner.screenshotsTag)
        }
        
    }
    
    func headerTagAction(for dataArrayType: ArrayType, with identifier: String) {
        
        if MatchedImageFinder.shared.inProcess {
            SPAlert.present(message: Generated.Text.Common.inProcess, haptic: .warning)
            return
        }
        
        guard let headerView = contentView.collectionView.currentCustomHeaderView as? GalleryCleanerHeaderView else { return }
        
        if let dataSource = self.dataSource {
            dataSource.selectedItemsDictionary.removeAll()
            contentView.setItemsForCleanCount(0)
        }
        
        self.dataArrayType = dataArrayType
        
        headerView.getAllTags().forEach { $0.isSelected = $0.cellId == identifier }
        
        contentShouldBeSelect = false
        
        configureRightButton()
        
        contentView.setItemsForCleanCount(dataSource.selectedItemsCount())
        
        
    }
    
    // MARK: - NavigationBar Handlers
    
    @objc func selectAction() {
        
        if MatchedImageFinder.shared.inProcess {
            SPAlert.present(message: Generated.Text.Common.inProcess, haptic: .warning)
            return
        }
        
        contentShouldBeSelect.toggle()
        
        if contentShouldBeSelect {
            selectButton.title = Generated.Text.Common.cancel
            selectButton.tintColor = Generated.Color.redWarning
        } else {
            selectButton.title = Generated.Text.Common.select
            selectButton.tintColor = Generated.Color.selectedText
            dataSource.selectedItemsDictionary = [:]
            contentView.collectionView.visibleCells.compactMap({$0 as? GalleryDefaultCollectionCell}).forEach {$0.mediaIsSelected = false}
            contentView.setItemsForCleanCount(dataSource.selectedItemsCount())
        }
        
    }
    
    @objc func clearAllAction() {
        
        if MatchedImageFinder.shared.inProcess {
            SPAlert.present(message: Generated.Text.Common.inProcess, haptic: .warning)
            return
        }
        
        let alertVC = UIAlertController(title: Generated.Text.Common.deleteSelectedContent, message: nil, preferredStyle: .actionSheet)
        let deleteItemsCount = dataSource.selectedItemsCount() == 0 ? dataSource.snapshot().numberOfItems : dataSource.selectedItemsCount()
        let deleteAction = UIAlertAction(title: Generated.Text.Common.deleteWithCount(String(deleteItemsCount)), style: .destructive) { [weak self] _ in
            
            guard let self = self else { return }
            
            if !CommerceManager.shared.isUserPremium, self.dataArrayType == .screenshots || self.dataArrayType == .similarPhotos || self.dataArrayType == .similarVideos {
                self.routeToPaywall()
                return
            }
            
            self.dataSource.removeSelectedItems()
            
            self.isDeliting = true
            
        }
        
        alertVC.addAction(deleteAction)
        alertVC.addAction(.init(title: Generated.Text.Common.cancel, style: .cancel))
        
        present(alertVC, animated: true)
        
    }
    
}

// MARK: - Public Methods

extension GalleryCleanerViewController {
    
}

// MARK: - Private Methods

private extension GalleryCleanerViewController {
    
    func setupActions() {
        
        contentView.setCleanAction { [weak self] in
            guard let self = self else { return }
            self.clearAllAction()
        }
        
    }
    
    func subscribeToNotifications() {
        
        NotificationRelay.observe(event: .galleryFinderUpdated) { [weak self] in
            guard let self = self else { return }
            
            if self.isDeliting {
                SPAlert.present(title: Generated.Text.Common.deleted, preset: .done)
                self.isDeliting = false
            }
            
            self.fetchMedia()
            
            if self.currentContentArray.isEmpty {
                self.navigationItem.rightBarButtonItem = nil
            }
            
        }
        
    }
    
}

// MARK: - Navigation

private extension GalleryCleanerViewController {
    
    func routeToPaywall() {
        let paywallVC = AppCoordiator.shared.getPaywall()
        paywallVC.modalPresentationStyle = .fullScreen
        self.present(paywallVC, animated: true)
    }
    
}

// MARK: - Layout Setup

private extension GalleryCleanerViewController {
    
}

// MARK: - NavigationBar Config

extension GalleryCleanerViewController {
    
    func initNavigationBarItems() {
        configureRightButton()
    }
    
    func configureRightButton() {
        
        DispatchQueue.main.async {
            
            switch self.dataArrayType {
                
            case .allContent, .screenshots:
                if self.currentContentArray.isEmpty {
                    self.navigationItem.rightBarButtonItem = nil
                    return
                }
                self.selectButton.title = Generated.Text.Common.select
                self.selectButton.style = .plain
                self.selectButton.target = self
                self.selectButton.action = #selector(self.selectAction)
                self.selectButton.tintColor = Generated.Color.selectedText
                
                self.navigationItem.rightBarButtonItem = self.selectButton
                
            case .similarPhotos, .similarVideos:
                self.navigationItem.rightBarButtonItem = nil
                
            }
            
        }
        
    }
    
}
