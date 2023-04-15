//
//  MainViewController.swift
//

import Foundation
import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let contentView = MainView()
    
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
        initOptions()
        subscribeToNotifications()
        setupActions()
        contentView.calculatingIsFinished(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkContactsSize()
        checkGallerySize()
        setDeviceName()
    }
    
}

// MARK: - Handlers

private extension MainViewController {
    
    func checkContactsSize() {
        if !SFContactFinder.shared.inProcess {
            allSizeMethods()
        }
    }
    
    func checkGallerySize() {
        if !SFGalleryFinder.shared.inProcess {
            allSizeMethods()
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
    
}

// MARK: - Public Methods

extension MainViewController {
    
}

// MARK: - Private Methods

private extension MainViewController {
    
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
        
        contentView.setCleaningButonAction { [weak self] in
            guard let self = self else { return }
            let vc = SmartCleaningViewController()
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func initOptions() {
        
        for option in MainOptionsModel.allCases {
            
            let optionView = MainOptionsCell()
            
            optionView.do {
                $0.setTitleIcon(option.icon)
                $0.setTitleText(option.titleText)
                $0.hideDivider(option == MainOptionsModel.allCases.last ? true : false)
                $0.setAction { [weak self] in
                    guard let self = self else { return }
                    self.navigationController?.isNavigationBarHidden = false
                    self.navigationController?.pushViewController(option.viewControllerToRoute, animated: true)
                }
            }
            
            contentView.addToOptionsList(optionView)
            
        }
        
    }
    
}

// MARK: - Navigation

private extension MainViewController {
    
}

// MARK: - Layout Setup

private extension MainViewController {
    
}
