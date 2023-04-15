//
//  GalleryCleanerHeaderView.swift
//

import UIKit

final class GalleryCleanerHeaderView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var tagsStackView = HeaderWithTagsView()
    
    private lazy var allContentTagView = HeaderWithTagsCellView()
    private lazy var similarPhotosTagView = HeaderWithTagsCellView()
    private lazy var similarVideosTagView = HeaderWithTagsCellView()
    private lazy var screenshotsTagView = HeaderWithTagsCellView()
    
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

extension GalleryCleanerHeaderView {
    
    func setAllContentTagViewAction(_ action: @escaping EmptyBlock) {
        allContentTagView.setAction(action)
    }
    
    func setSimilarPhotosTagViewAction(_ action: @escaping EmptyBlock) {
        similarPhotosTagView.setAction(action)
    }
    
    func setSimilarVideosTagViewAction(_ action: @escaping EmptyBlock) {
        similarVideosTagView.setAction(action)
    }
    
    func setScreenshotsTagViewAction(_ action: @escaping EmptyBlock) {
        screenshotsTagView.setAction(action)
    }
    
    func getAllTags() -> [HeaderWithTagsCellView] {
        tagsStackView.getAllTags()
    }
    
}

// MARK: - Private Methods

private extension GalleryCleanerHeaderView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension GalleryCleanerHeaderView {
    
    func configureView() {
        backgroundColor = .clear
    }
    
    func configureSubviews() {
        
        allContentTagView.isSelected = true
        
        allContentTagView.setTitleText(Generated.Text.GalleryCleaner.allContentTag)
        similarPhotosTagView.setTitleText(Generated.Text.GalleryCleaner.similarPhotosTag)
        similarVideosTagView.setTitleText(Generated.Text.GalleryCleaner.similarVideosTag)
        screenshotsTagView.setTitleText(Generated.Text.GalleryCleaner.screenshotsTag)
        
        tagsStackView.addTags([allContentTagView, similarPhotosTagView, similarVideosTagView, screenshotsTagView])
        
    }
    
}


// MARK: - Layout Setup

private extension GalleryCleanerHeaderView {
    
    func addSubviewsBefore() {
        addSubview(tagsStackView)
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        tagsStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(-ThisSize.is16/2)
            make.bottom.equalToSuperview().offset(-ThisSize.is12)
        }
        
    }
    
}
