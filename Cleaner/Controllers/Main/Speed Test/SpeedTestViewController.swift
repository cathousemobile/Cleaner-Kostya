//
//  SpeedTestViewController.swift
//

import UIKit
import Network

final class SpeedTestViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let contentView = SpeedTestView()
    
    // MARK: - Public Proporties
    
    // MARK: - Private Proporties
    
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
        title = Generated.Text.SpeedTest.title
        setupActions()
        checkConnectionType()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIsPremium()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SpeedTestChecker.stop()
    }
    
}

// MARK: - Handlers

private extension SpeedTestViewController {
    
    private func startSpeedTest() {
        
        contentView.changeProgressStyle(.download)
        contentView.playAnimation()
        
        SpeedTestChecker.downloadSpeedUpdated = { [weak self] speed in
            guard let self = self else {
                SpeedTestChecker.resetData()
                return
            }
            self.contentView.setDownloadSpeed(String(format: "%.1f", speed.speedInMbps))
            self.contentView.updateCurrentSpeed(String(format: "%.1f", speed.speedInMbps))
        }
        
        SpeedTestChecker.uploadSpeedUpdated = { [weak self] speed in
            guard let self = self else {
                SpeedTestChecker.resetData()
                return
            }
            self.contentView.setUploadSpeed(String(format: "%.1f", speed.speedInMbps))
            self.contentView.updateCurrentSpeed(String(format: "%.1f", speed.speedInMbps))
        }
        
        contentView.speedTestButtonShouldBeEnabled(false)
        
        SpeedTestChecker.startFullTest(pauseBetweenTest: {
            self.contentView.changeProgressStyle(.upload)
            self.contentView.playAnimation()
        }, completion: { [weak self] in
            guard let self = self else { return }
            self.contentView.speedTestButtonShouldBeEnabled(true)
            self.contentView.stopAnimation()
            self.contentView.updateCurrentSpeed("0")
        })
    }
    
    private func checkConnectionType() {
        
        let nwPathMonitor = NWPathMonitor()
        
        nwPathMonitor.pathUpdateHandler = { path in
            if path.usesInterfaceType(.wifi) {
                self.contentView.setConnectionInfo("Wi-Fi")
            } else if path.usesInterfaceType(.cellular) {
                self.contentView.setConnectionInfo("Cellular")
            } else {
                self.contentView.setConnectionInfo("Unknown")
            }
        }
        
        nwPathMonitor.start(queue: .main)
        
    }
    
    func checkIsPremium() {
        contentView.speedTestButtonShouldBeLocked(!LocaleStorage.isPremium)
    }
    
}

// MARK: - Public Methods

extension SpeedTestViewController {
    
}

// MARK: - Private Methods

private extension SpeedTestViewController {
    
    func setupActions() {
        
        contentView.setSpeedTestButonAction { [weak self] in
            
            if !LocaleStorage.isPremium {
                self?.routeToPaywall()
            } else {
                self?.contentView.speedTestButtonShouldBeLocked(false)
                self?.startSpeedTest()
            }
            
        }
        
        
        
    }
    
}

// MARK: - Navigation

private extension SpeedTestViewController {
    
    func routeToPaywall() {
        let paywallVC = PaywallViewController(paywallType: .none)
        paywallVC.modalPresentationStyle = .fullScreen
        self.present(paywallVC, animated: true)
    }
    
}

// MARK: - Layout Setup

private extension SpeedTestViewController {
    
}

