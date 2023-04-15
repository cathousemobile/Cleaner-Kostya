//
//  GalleryDefaultCollectionCell.swift
//

import UIKit
import Photos

final class GalleryDefaultCollectionCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    
    override var isSelected: Bool {
        didSet {
            updateStyle()
        }
    }
    
    var phAsset = PHAsset()
    
    // MARK: - Private Properties
    
    private var tapped: EmptyBlock?
    private var pressed: EmptyBlock?
    
    // MARK: - Subviews
    
    private lazy var imageView = UIImageView()
    private lazy var radioView = UIImageView()
    private lazy var bestPhotoView = GalleryCleanerBestPhotoView()
    
    private lazy var tapGesture = UITapGestureRecognizer()
    private lazy var longPressGesture = UILongPressGestureRecognizer()
    
    private lazy var blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: traitCollection.userInterfaceStyle == .dark ? .light : .dark))
    
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
        tapped = emptyAction
        pressed = emptyAction
        imageView.image = nil
        radioView.isHidden = true
        blurEffectView.isHidden = true
        bestPhotoView.isHidden = true
        phAsset = PHAsset()
    }
    
}

// MARK: - Public Methods

extension GalleryDefaultCollectionCell {
    
    func removeTapGesture() {
        removeGestureRecognizer(tapGesture)
    }
    
    func setImage(_ image: UIImage?) {
        imageView.image = image
    }
    
    func getImage() -> UIImage? {
        imageView.image
    }
    
    func setTapAction(_ action: @escaping EmptyBlock) {
        tapped = action
    }
    
    func setLongPressAction(_ action: @escaping EmptyBlock) {
        pressed = action
    }
    
    func hideBestPhotoTag(_ isHidden: Bool) {
        bestPhotoView.isHidden = isHidden
    }
    
}

// MARK: - Private Methods

private extension GalleryDefaultCollectionCell {
    
    func updateStyle() {
        radioView.isHidden = !isSelected
        blurEffectView.isHidden = !isSelected
    }
    
    func configureView() {
        backgroundColor = .clear
    }
    
    func addActions() {
        tapGesture.addTarget(self, action: #selector(onTapped))
        addGestureRecognizer(tapGesture)
        longPressGesture.addTarget(self, action: #selector(onPressed))
        longPressGesture.minimumPressDuration = 1
        addGestureRecognizer(longPressGesture)
        isUserInteractionEnabled = true
    }
    
    func configureSubviews() {
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        radioView.image = Generated.Image.galleryRadio
        radioView.isHidden = true
        
        blurEffectView.isHidden = true
        
        blurEffectView.alpha = 0.2
        
        bestPhotoView.isHidden = true
        
    }
    
    func addSubviewsBefore() {
        contentView.addSubviews([imageView, blurEffectView, radioView, bestPhotoView])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        radioView.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(ThisSize.is16/4)
        }
        
        bestPhotoView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(ThisSize.is12)
        }
        
    }
    
}

//MARK: - Action

private extension GalleryDefaultCollectionCell {
    
    @objc func onTapped() {
        tapped?()
    }
    
    @objc func onPressed() {
        pressed?()
    }
    
    func emptyAction() {}
    
}


