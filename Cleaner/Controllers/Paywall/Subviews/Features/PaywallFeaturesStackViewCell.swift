//
//  PaywallFeaturesStackViewCell.swift
//

import UIKit

final class PaywallFeaturesStackViewCell: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var iconView = UIImageView()
    private lazy var textLabel = UILabel()
    
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

extension PaywallFeaturesStackViewCell {
    
    func setIcon(_ icon: UIImage) {
        iconView.image = icon
    }
    
    func setText(_ text: String) {
        textLabel.text = text
    }
    
    func isCheksIcon(_ isCheks: Bool = false) {
        textLabel.font = isCheks ? .systemFont(ofSize: 15, weight: .medium) : .systemFont(ofSize: 18, weight: .semibold)
    }
    
}

// MARK: - Private Methods

private extension PaywallFeaturesStackViewCell {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension PaywallFeaturesStackViewCell {
    
    func configureView() {
        backgroundColor = .clear
    }
    
    func configureSubviews() {
        
        textLabel.do {
            $0.textColor = Generated.Color.primaryText
            $0.numberOfLines = 0
        }
        
    }
    
}


// MARK: - Layout Setup

private extension PaywallFeaturesStackViewCell {
    
    func addSubviewsBefore() {
        addSubviews([iconView, textLabel])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        textLabel.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(iconView.snp.trailing).offset(ThisSize.is16)
        }
        
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(textLabel)
        }
        
    }
    
}


