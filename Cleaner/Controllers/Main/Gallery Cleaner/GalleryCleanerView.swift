//
//  GalleryCleanerView.swift
//

import UIKit

final class GalleryCleanerView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureAppearance() {
        configureView()
        addActions()
        configureSubviews()
        configureConstraints()
    }
    
}

// MARK: - Public Methods

extension GalleryCleanerView {
    
}

// MARK: - Private Methods

private extension GalleryCleanerView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension GalleryCleanerView {
    
    func configureView() {
        backgroundColor = Generated.Color.mainBackground
    }
    
    func configureSubviews() {
        
    }
    
}


// MARK: - Layout Setup

private extension GalleryCleanerView {
    
    func addSubviewsBefore() {
        
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        
        
    }
    
}

