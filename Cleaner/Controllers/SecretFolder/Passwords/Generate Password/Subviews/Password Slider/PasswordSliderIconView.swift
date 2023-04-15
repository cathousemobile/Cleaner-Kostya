//
//  PasswordSliderIconView.swift
//  Cleaner
//

import UIKit

final class PasswordSliderIconView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var titleLabel = UILabel()
    
    private lazy var imageView = UIImageView()
    
    // MARK: - Lifecycle
    
    init(frame: CGRect = .zero, countText: String) {
        super.init(frame: frame)
        self.titleLabel.text = countText
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

extension PasswordSliderIconView {
    
}

// MARK: - Private Methods

private extension PasswordSliderIconView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension PasswordSliderIconView {
    
    func configureView() {
        
    }
    
    func configureSubviews() {
        
        titleLabel.do {
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 12, weight: .regular)
            $0.textAlignment = .center
        }
        
        imageView.image = Generated.Image.passwordCounterBack
        imageView.contentMode = .scaleAspectFit
        
    }
    
}


// MARK: - Layout Setup

private extension PasswordSliderIconView {
    
    func addSubviewsBefore() {
        addSubviews([imageView, titleLabel])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
}
