//
//  SmartCleaningViewController.swift
//

import UIKit
import SPAlert

final class SmartCleaningViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let contentView = SmartCleaningView()
    
    // MARK: - Public Proporties
    
    // MARK: - Private Proporties
    
    private let calculator = ContentSizeCalculatorHelper()
    
    private lazy var contactsDeletingInProcess = false
    private lazy var galleryDeletingInProcess = false
    
    private lazy var dispatchCounter = 0
    
    private let contactsDispatchGroup = DispatchGroup()
    private let galleryPhotosDispatchGroup = DispatchGroup()
    private let galleryScreenshotsDispatchGroup = DispatchGroup()
    private let galleryVideosDispatchGroup = DispatchGroup()
    
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
        title = Generated.Text.Main.smartCleaning
        subscribeToNotifications()
        setupActions()
        initInfos()
        contentView.calculatingIsFinished(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIsPremium()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkContactsSize()
        checkGallerySize()
        setDeviceName()
    }
    
}

// MARK: - Handlers

private extension SmartCleaningViewController {
    
    func checkContactsSize() {
        if !ContactReplicaScanner.shared.inProcess {
            allSizeMethods()
            contentView.hideSpinViewInContactCell(true)
        } else {
            contentView.hideSpinViewInContactCell(false)
        }
    }
    
    func checkGallerySize() {
        if !MatchedImageFinder.shared.inProcess {
            allSizeMethods()
            contentView.hideSpinViewInAllGalleryCells(true)
        } else {
            contentView.hideSpinViewInAllGalleryCells(false)
        }
    }
    
    func allSizeMethods() {
        setMemorySpaces()
        checkCalculating()
    }
    
    func setMemorySpaces() {
        contentView.setMemorySpaces(calculator.totalSpace, useSpace: calculator.useSpace)
    }
    
    func setDeviceName() {
        contentView.setDeviceName(PlatformInfo.Device.deviceName ?? "Unknown")
    }
    
    func checkCalculating() {
        
        contentView.setProgress(progress: calculator.otherSizeEquals, photoProgress: calculator.mediaSizeEquals, contactsProgress: calculator.contactsSizeEquals)
        
        contentView.calculatingIsFinished(true)
        
    }
    
    func checkIsPremium() {
        contentView.changeCleaningButtonState(!CommerceManager.shared.isUserPremium)
    }
    
}

// MARK: - Public Methods

extension SmartCleaningViewController {
    
}

// MARK: - Private Methods

private extension SmartCleaningViewController {
    
    func subscribeToNotifications() {
        
        NotificationRelay.observe(event: .contactFinderUpdated) { [weak self] in
            guard let self = self else { return }
            
            if self.contactsDeletingInProcess {
                
                self.dispatchCounter -= 1
                
                if self.dispatchCounter == 0 {
                    SPAlert.present(title: Generated.Text.Common.deleted, preset: .done)
                }
                
                self.contactsDeletingInProcess = false
                
                if let groupEnterCount = self.contactsDispatchGroup.debugDescription.components(separatedBy: ",").filter({$0.contains("count")})
                    .first?.components(separatedBy: CharacterSet.decimalDigits.inverted).compactMap({Int($0)}).first, groupEnterCount > 0 {
                    self.contactsDispatchGroup.leave()
                }
                
            } else {
                self.checkContactsSize()
            }
            
        }
        
        NotificationRelay.observe(event: .galleryFinderUpdated) { [weak self] in
            guard let self = self else { return }
            
            if self.galleryDeletingInProcess {
                
                self.dispatchCounter -= 1
                
                if self.dispatchCounter == 0 {
                    SPAlert.present(title: Generated.Text.Common.deleted, preset: .done)
                    self.galleryDeletingInProcess = false
                }
                
                if let photosGroupEnterCount = self.galleryPhotosDispatchGroup.debugDescription.components(separatedBy: ",").filter({$0.contains("count")})
                    .first?.components(separatedBy: CharacterSet.decimalDigits.inverted).compactMap({Int($0)}).first, photosGroupEnterCount > 0 {
                    self.galleryPhotosDispatchGroup.leave()
                }
                
                if let videosGroupEnterCount = self.galleryVideosDispatchGroup.debugDescription.components(separatedBy: ",").filter({$0.contains("count")})
                    .first?.components(separatedBy: CharacterSet.decimalDigits.inverted).compactMap({Int($0)}).first, videosGroupEnterCount > 0 {
                    self.galleryVideosDispatchGroup.leave()
                }
                
                if let shotsGroupEnterCount = self.galleryScreenshotsDispatchGroup.debugDescription.components(separatedBy: ",").filter({$0.contains("count")})
                    .first?.components(separatedBy: CharacterSet.decimalDigits.inverted).compactMap({Int($0)}).first, shotsGroupEnterCount > 0 {
                    self.galleryScreenshotsDispatchGroup.leave()
                }
                
            } else {
                self.checkGallerySize()
            }
            
        }
        
    }
    
    func setupActions() {
        
        contentView.setCleaningButtonAction { [weak self] in
            guard let self = self else { return }
            
            if !CommerceManager.shared.isUserPremium {
                self.routeToPaywall()
                return
            }
            
            self.deleteContent()
            
        }
        
    }
    
    func deleteContent() {
        
        if ContactReplicaScanner.shared.inProcess || MatchedImageFinder.shared.inProcess {
            SPAlert.present(message: Generated.Text.Common.inProcess, haptic: .warning)
            return
        }
        
        if SmartCleaningModel.allCases.filter({ $0.isOn }).isEmpty {
            SPAlert.present(message: Generated.Text.Common.nothingToDelete, haptic: .none)
            return
        }
        
        dispatchCounter = 0
        
        for smartCell in SmartCleaningModel.allCases where smartCell.isOn {
            
            smartCell.deleteContent()
            
            if smartCell.titleText == Generated.Text.SmartCleaning.duplicateContacts {
                
                contactsDispatchGroup.enter()
                
                dispatchCounter += 1
                
                contactsDeletingInProcess = true
                
                if let cell = contentView.getCellById(smartCell.titleText) {
                    cell.hideSpiner(false)
                    contactsDispatchGroup.notify(queue: .main) {
                        cell.setSubtitleState(.data(data: smartCell.size))
                        cell.hideSpiner(true)
                        cell.changeRadioState(to: .disable)
                        smartCell.save(false)
                    }
                }
                
            }
            
            if smartCell.titleText == Generated.Text.SmartCleaning.similarPhotos {
                
                galleryPhotosDispatchGroup.enter()
                
                dispatchCounter += 1
                
                galleryDeletingInProcess = true
                
                if let cell = contentView.getCellById(smartCell.titleText) {
                    cell.hideSpiner(false)
                    galleryPhotosDispatchGroup.notify(queue: .main) {
                        cell.setSubtitleState(.data(data: smartCell.size))
                        cell.hideSpiner(true)
                        cell.changeRadioState(to: .disable)
                        smartCell.save(false)
                    }
                }
                
            }
            
            if smartCell.titleText == Generated.Text.SmartCleaning.similarVideos {
                
                galleryVideosDispatchGroup.enter()
                
                dispatchCounter += 1
                
                galleryDeletingInProcess = true
                
                if let cell = contentView.getCellById(smartCell.titleText) {
                    cell.hideSpiner(false)
                    galleryVideosDispatchGroup.notify(queue: .main) {
                        cell.setSubtitleState(.data(data: smartCell.size))
                        cell.hideSpiner(true)
                        cell.changeRadioState(to: .disable)
                        smartCell.save(false)
                    }
                }
                
            }
            
            if smartCell.titleText == Generated.Text.SmartCleaning.screenshots {
                
                galleryScreenshotsDispatchGroup.enter()
                
                dispatchCounter += 1
                
                galleryDeletingInProcess = true
                
                if let cell = contentView.getCellById(smartCell.titleText) {
                    cell.hideSpiner(false)
                    galleryScreenshotsDispatchGroup.notify(queue: .main) {
                        cell.setSubtitleState(.data(data: smartCell.size))
                        cell.hideSpiner(true)
                        cell.changeRadioState(to: .disable)
                        smartCell.save(false)
                    }
                }
                
            }
            
        }
        
    }
    
    func initInfos() {
        
        for smartCleaning in SmartCleaningModel.allCases {
            
            let cell = SmartCleaningCell()
            
            cell.do {
                $0.id = smartCleaning.titleText
                $0.setIcon(smartCleaning.icon)
                $0.setTitleText(smartCleaning.titleText)
                $0.hideDivider(smartCleaning == SmartCleaningModel.allCases.last ? true : false)
                $0.setAction { isOn in
                    smartCleaning.save(isOn)
                }
                
                if !smartCleaning.accessGainted || smartCleaning.size == "Zero KB" {
                    $0.changeRadioState(to: .disable)
                    smartCleaning.save(false)
                } else {
                    $0.changeRadioState(to: .enable)
                }
                
                $0.setSubtitleState(smartCleaning.accessGainted ? .data(data: smartCleaning.size) : .disabled)
                $0.radioButtonIsSelected(smartCleaning.isOn)
                $0.hideSpiner(false)
            }
            
            contentView.addToInfoList(cell)
            
        }
        
    }
    
}

// MARK: - Navigation

private extension SmartCleaningViewController {
    
    func routeToPaywall() {
        #warning("hardcode paywall")
        let paywallVC = PaywallViewController(paywallType: .trialSwitch)
//        let paywallVC = AppCoordiator.shared.getPaywall()
        paywallVC.modalPresentationStyle = .fullScreen
        self.present(paywallVC, animated: true)
    }
    
}

// MARK: - Layout Setup

private extension SmartCleaningViewController {
    
}
