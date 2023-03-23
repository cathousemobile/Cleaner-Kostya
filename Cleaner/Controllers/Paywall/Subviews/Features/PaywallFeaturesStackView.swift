//
//  PaywallFeaturesStackView.swift
//

import UIKit

final class PaywallFeaturesStackView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private let paywallType: PaywallViewTypeModel
    
    // MARK: - Subviews
    
    private lazy var stackView = UIStackView()
    
    // MARK: - Lifecycle
    
    init(frame: CGRect = .zero, paywallType: PaywallViewTypeModel) {
        self.paywallType = paywallType
        super.init(frame: frame)
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureAppearance() {
        initFeatures()
        configureView()
        addActions()
        configureSubviews()
        configureConstraints()
    }
    
}

// MARK: - Public Methods

extension PaywallFeaturesStackView {
    
    func addFeatureToStack(_ featureView: PaywallFeaturesStackViewCell) {
        stackView.addArrangedSubview(featureView)
    }
    
    func initFeatures() {
        
        for feature in PaywallFeaturesModel.allCases {
            let featureView = PaywallFeaturesStackViewCell()
            featureView.setIcon(feature.icon(paywallType == .oval))
            featureView.setText(feature.titleText)
            featureView.isCheksIcon(paywallType == .oval)
            stackView.addArrangedSubview(featureView)
        }
        
    }
    
}

// MARK: - Private Methods

private extension PaywallFeaturesStackView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension PaywallFeaturesStackView {
    
    func configureView() {
        backgroundColor = .clear
    }
    
    func configureSubviews() {
        stackView.axis = .vertical
        stackView.spacing = ThisSize.is16
    }
    
}


// MARK: - Layout Setup

private extension PaywallFeaturesStackView {
    
    func addSubviewsBefore() {
        addSubview(stackView)
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
    }
    
}


