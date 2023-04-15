//
//  SmartCleaningViewController.swift
//

import UIKit

final class SmartCleaningViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let contentView = SmartCleaningView()
    
    // MARK: - Public Proporties
    
    // MARK: - Private Proporties
    private let calculator = ContentSizeCalculatorHelper()
    
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
        if !SFContactFinder.shared.inProcess {
            allSizeMethods()
            contentView.hideSpinViewInContactCell(true)
        } else {
            contentView.hideSpinViewInContactCell(false)
        }
    }
    
    func checkGallerySize() {
        if !SFGalleryFinder.shared.inProcess {
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
        contentView.setDeviceName(SFSystemInfo.Device.deviceName ?? "Unknown")
    }
    
    func checkCalculating() {
        
        contentView.setProgress(progress: calculator.otherSizeEquals, photoProgress: calculator.mediaSizeEquals, contactsProgress: calculator.contactsSizeEquals)
        
        contentView.calculatingIsFinished(true)
        
    }
    
    func checkIsPremium() {
        contentView.changeCleaningButtonState(!SFPurchaseManager.shared.isUserPremium)
    }
    
}

// MARK: - Public Methods

extension SmartCleaningViewController {
    
}

// MARK: - Private Methods

private extension SmartCleaningViewController {
    
    func subscribeToNotifications() {
        
        SFNotificationSystem.observe(event: .contactFinderUpdated) { [weak self] in
            guard let self = self else { return }
            self.checkContactsSize()
        }
        
        SFNotificationSystem.observe(event: .galleryFinderUpdated) { [weak self] in
            guard let self = self else { return }
            self.checkGallerySize()
        }
        
    }
    
    func setupActions() {
        
        contentView.setCleaningButtonAction { [weak self] in
            guard let self = self else { return }
            
            if !SFPurchaseManager.shared.isUserPremium {
                self.routeToPaywall()
                return
            }
            
            self.deleteContent()
            
        }
        
    }
    
    func deleteContent() {
        for smartCell in SmartCleaningModel.allCases where smartCell.isOn {
            smartCell.deleteContent()
            print(smartCell)
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
                $0.changeRadioState(to: smartCleaning.accessGainted ? .enable : .disable)
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
        let paywallVC = AppCoordiator.shared.getPaywall()
        paywallVC.modalPresentationStyle = .fullScreen
        self.present(paywallVC, animated: true)
    }
    
}

// MARK: - Layout Setup

private extension SmartCleaningViewController {
    
}
