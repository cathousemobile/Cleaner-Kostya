//
//  SecretGalleryView.swift
//

import UIKit

final class SecretGalleryView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    public lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    private lazy var emptyDataLabel = UILabel()
    
    private lazy var cleanButton = CustomButtonView()
    
    private lazy var blurView = UIView()
    
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
        blurView.setupGradient([UIColor.clear.cgColor, UIColor(hex: "0D0D0D").alpha(0.92).cgColor])
        let bottomHeight = self.safeAreaInsets.bottom + cleanButton.bounds.height + ThisSize.is48
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomHeight, right: 0)
    }
    
}

// MARK: - Public Methods

extension SecretGalleryView {
    
    func setEmptyDataTitle(_ text: String) {
        emptyDataLabel.text = text
    }
    
    func hideEmptyDataTitle(_ isHidden: Bool) {
        emptyDataLabel.isHidden = isHidden
    }
    
    func setItemsForCleanCount(_ count: Int) {
        cleanButton.setTitle(text: count == 0 ? Generated.Text.Common.clean : Generated.Text.Common.cleanWithCount(String(count)))
    }
    
    func setCleanAction(_ action: @escaping EmptyBlock) {
        cleanButton.setAction(action)
    }
    
    func setAddCleanButtonTitle(_ titleText: String) {
        cleanButton.setTitle(text: titleText)
    }
    
    func showBlur() {
        
        var cellsHeight = CGFloat()
        
        for i in 0..<collectionView.visibleCells.count {
            if i % 3 == 0 {
                cellsHeight += collectionView.visibleCells[i].frame.height
            }
        }
        
        blurView.isHidden = !(cellsHeight >= self.frame.height/1.4)
        
    }
    
}

// MARK: - Private Methods

private extension SecretGalleryView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension SecretGalleryView {
    
    func configureView() {
        backgroundColor = Generated.Color.mainBackground
    }
    
    func configureSubviews() {
        
        emptyDataLabel.do {
            $0.text = Generated.Text.GalleryCleaner.emptyContentTitle
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.isHidden = true
            $0.textAlignment = .center
        }
        
        setAddCleanButtonTitle(Generated.Text.SecretGallery.addMedia)
        
        blurView.isHidden = true
        
        collectionView.backgroundColor = .clear
        collectionView.delaysContentTouches = false
        collectionView.allowsMultipleSelection = true
        
        if #available(iOS 14.0, *) {
            collectionView.isEditing = true
            collectionView.allowsMultipleSelectionDuringEditing = true
        }
        
    }
    
}


// MARK: - Layout Setup

private extension SecretGalleryView {
    
    func addSubviewsBefore() {
        addSubviews([collectionView, emptyDataLabel, blurView, cleanButton])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        emptyDataLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.trailing.leading.equalToSuperview()
        }
        
        cleanButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-ThisSize.is16/2)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        blurView.snp.makeConstraints { make in
            make.top.equalTo(cleanButton).offset(-ThisSize.is64)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
    }
    
}

