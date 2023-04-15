//
//  GalleryCleanerSectionHeaderView.swift
//

import UIKit

final class GalleryCleanerSectionHeaderView: UICollectionReusableView {
    
    // MARK: - Public Properties
    
    public var isSelect = Bool() {
        didSet { switchActionButtonType() }
    }
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var countLabel = UILabel()
    private lazy var actionButton = CustomLabelButton()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect = .zero) {
        super .init(frame: frame)
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureAppearance() {
        configureView()
        configureSubviews()
        configureConstraints()
        addActions()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        countLabel.text = nil
        actionButton.setAction({})
    }
    
}

// MARK: - Public Methods

extension GalleryCleanerSectionHeaderView {
    
    func setItemsCount(_ count: Int) {
        countLabel.text = Generated.Text.GalleryCleaner.photosCount("\(count)")
    }
    
    func setAction(_ action: @escaping EmptyBlock) {
        actionButton.setAction(action)
    }
    
}

// MARK: - Private Methods

private extension GalleryCleanerSectionHeaderView {
    
    func switchActionButtonType() {
        
        actionButton.changeTitleLabel { [weak self] in
            guard let self = self else { return }
            $0.text = self.isSelect ? Generated.Text.Common.selectAll : Generated.Text.Common.deselectAll
            $0.textColor = self.isSelect ? Generated.Color.selectedText : Generated.Color.redWarning
        }
        
    }
    
}

// MARK: - Layout Methods

private extension GalleryCleanerSectionHeaderView {
    
    func configureView() {
        backgroundColor = .clear
    }
    
    func addActions() {
        
    }
    
    func configureSubviews() {
        
        countLabel.do {
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 15, weight: .regular)
        }
        
        actionButton.changeTitleLabel {
            $0.font = .systemFont(ofSize: 15, weight: .regular)
        }
        
    }
    
    func addSubviewsBefore() {
        
        addSubviews([countLabel, actionButton])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        countLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(ThisSize.is16/2)
            make.leading.equalToSuperview().offset(ThisSize.is16)
        }
        
        actionButton.snp.makeConstraints { make in
            make.centerY.equalTo(countLabel)
            make.trailing.equalToSuperview().offset(-ThisSize.is16)
        }
        
    }
    
}

