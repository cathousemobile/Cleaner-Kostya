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
        initOptions()
        checkCalculating()
        setupActions()
        
        for i in 0...99 {
            randomArray.append(Float(i)/100)
        }
        
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

private extension MainViewController {
    
}

// MARK: - Public Methods

extension MainViewController {
    
}

// MARK: - Private Methods

private extension MainViewController {
    
    func setupActions() {
        
        contentView.setCleaningButonAction {
            let vc = SmartCleaningViewController()
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
                $0.setAction { [unowned self] in
                    navigationController?.pushViewController(option.viewControllerToRoute, animated: true)
                }
            }
            
            contentView.addToOptionsList(optionView)
            
        }
        
    }
    
    func checkCalculating() {
        contentView.calculatingIsFinished(false)
    }
    
}

// MARK: - Navigation

private extension MainViewController {
    
}

// MARK: - Layout Setup

private extension MainViewController {
    
}

