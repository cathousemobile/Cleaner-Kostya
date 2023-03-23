//
//  GalleryCleanerViewController.swift
//

import UIKit

final class GalleryCleanerViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let contentView = GalleryCleanerView()
    
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
        title = "GalleryCleanerViewController"
        setupActions()
    }
    
}

// MARK: - Handlers

private extension GalleryCleanerViewController {
    
}

// MARK: - Public Methods

extension GalleryCleanerViewController {
    
}

// MARK: - Private Methods

private extension GalleryCleanerViewController {
    
    func setupActions() {
        
    }
    
}

// MARK: - Navigation

private extension GalleryCleanerViewController {
    
}

// MARK: - Layout Setup

private extension GalleryCleanerViewController {
    
}


