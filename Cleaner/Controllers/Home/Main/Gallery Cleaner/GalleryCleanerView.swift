//
//  GalleryCleanerView.swift
//

import UIKit

final class GalleryCleanerView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    public lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    private lazy var emptyDataLabel = UILabel()
    
    private lazy var tagsHeaderView = GalleryCleanerHeaderView()
    
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
        collectionView.setHeaderView(headerView: tagsHeaderView)
        let bottomHeight = self.safeAreaInsets.bottom + cleanButton.bounds.height + ThisSize.is48
        collectionView.updateHeaderViewFrame(bottomHeight)
        blurView.setupGradient([UIColor.clear.cgColor, UIColor(hex: "0D0D0D").alpha(0.92).cgColor])
    }
    
}

// MARK: - Public Methods

extension GalleryCleanerView {
    
    func setEmptyDataTitle(_ text: String) {
        DispatchQueue.main.async {
            self.emptyDataLabel.text = text
        }
    }
    
    func hideEmptyDataTitle(_ isHidden: Bool) {
        DispatchQueue.main.async {
            self.cleanButton.isHidden = !isHidden
            self.emptyDataLabel.isHidden = isHidden
        }
        
    }
    
    func setItemsForCleanCount(_ count: Int) {
        DispatchQueue.main.async {
            self.cleanButton.setTitle(text: count == 0 ? Generated.Text.Common.clean : Generated.Text.Common.cleanWithCount(String(count)))
        }
        
    }
    
    func setCleanAction(_ action: @escaping EmptyBlock) {
        cleanButton.setAction(action)
    }
    
    func showBlur(_ isSimilar: Bool = false) {
        
        if !isSimilar {
            
            var cellsHeight = CGFloat()
            
            DispatchQueue.main.async {
                
                for i in 0..<self.collectionView.visibleCells.count {
                    if i % 3 == 0 {
                        cellsHeight += self.collectionView.visibleCells[i].frame.height
                    }
                }
                
                self.blurView.isHidden = !(cellsHeight >= self.frame.height/1.4)
            }
            
        } else {
            DispatchQueue.main.async {
                self.blurView.isHidden = !(self.collectionView.visibleCells.count > 4)
            }
        }
        
    }
    
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
        
        emptyDataLabel.do {
            $0.text = Generated.Text.GalleryCleaner.emptyContentTitle
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.isHidden = true
            $0.textAlignment = .center
        }
        
        cleanButton.setTitle(text: Generated.Text.Common.clean)
        
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

private extension GalleryCleanerView {
    
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

