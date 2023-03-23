//
//  SmartCleaningViewController.swift
//

import UIKit

final class SmartCleaningViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let contentView = SmartCleaningView()
    
    // MARK: - Public Proporties
    
    // MARK: - Private Proporties
    
    var randomArray = [Float]()
    
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
        setupActions()
        initInfos()
        checkCalculating()
        
        for i in 0...99 {
            randomArray.append(Float(i)/100)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIsPremium()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for i in 0...100 {
            
            self.contentView.setProgress(progress: self.randomArray.randomElement()!, photoProgress: self.randomArray.randomElement()!, contactsProgress: self.randomArray.reversed().randomElement()!)
            
            if i == 99 {
                contentView.calculatingIsFinished(true)
            }
            
        }
        
    }
    
}

// MARK: - Handlers

private extension SmartCleaningViewController {
    
    func checkCalculating() {
        contentView.calculatingIsFinished(false)
    }
    
    func checkIsPremium() {
        contentView.changeCleaningButtonState(!LocaleStorage.isPremium)
    }
    
}

// MARK: - Public Methods

extension SmartCleaningViewController {
    
}

// MARK: - Private Methods

private extension SmartCleaningViewController {
    
    func setupActions() {
        
        contentView.setCleaningButtonAction { [weak self] in
            if !LocaleStorage.isPremium {
                self?.routeToPaywall()
            }
        }
        
    }
    
    func initInfos() {
        
        for smartCleaning in SmartCleaningModel.allCases {
            
            let cell = SmartCleaningCell()
            
            cell.do {
                $0.setIcon(smartCleaning.icon)
                $0.setTitleText(smartCleaning.titleText)
                $0.setSubtitleState(.data(data: "20 MB"))
                $0.hideDivider(smartCleaning == SmartCleaningModel.allCases.last ? true : false)
                $0.setAction { isOn in
                    smartCleaning.save(isOn)
                }
                $0.changeRadioState(to: .enable)
            }
            
            smartCleaning.save(false)
            contentView.addToInfoList(cell)
            
        }
        
    }
    
}

// MARK: - Navigation

private extension SmartCleaningViewController {
    
    func routeToPaywall() {
        let paywallVC = PaywallViewController(paywallType: .rect)
        paywallVC.modalPresentationStyle = .fullScreen
        self.present(paywallVC, animated: true)
    }
    
}

// MARK: - Layout Setup

private extension SmartCleaningViewController {
    
}


