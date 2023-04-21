//
//  GalleryCleanerBestPhotoView.swift
//

import UIKit

final class GalleryCleanerBestPhotoView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var titleLabel = UILabel()
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(radius: 12)
    }
    
}

// MARK: - Public Methods

extension GalleryCleanerBestPhotoView {
    
    func isPhoto(_ isPhoto: Bool) {
        titleLabel.text = isPhoto ? Generated.Text.GalleryCleaner.bestPhoto : Generated.Text.GalleryCleaner.bestVideo
    }
    
}

// MARK: - Private Methods

private extension GalleryCleanerBestPhotoView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension GalleryCleanerBestPhotoView {
    
    func configureView() {
        backgroundColor = Generated.Color.mainBackground
    }
    
    func configureSubviews() {
        titleLabel.do {
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 12, weight: .semibold)
        }
    }
    
}


// MARK: - Layout Setup

private extension GalleryCleanerBestPhotoView {
    
    func addSubviewsBefore() {
        addSubview(titleLabel)
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(ThisSize.is12)
        }
        
    }
    
}
