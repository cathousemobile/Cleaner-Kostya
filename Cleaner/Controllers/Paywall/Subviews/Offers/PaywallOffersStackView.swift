//
//  PaywallOffersStackView.swift
//

import UIKit

final class PaywallOffersStackView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private let paywallType: PaywallViewTypeModel
    
    // MARK: - Subviews
    
    private lazy var stackView = UIStackView()
    
    // MARK: - Lifecycle
    
    init?(frame: CGRect = .zero, paywallType: PaywallViewTypeModel) {
        guard paywallType != .none else { return nil }
        self.paywallType = paywallType
        super.init(frame: frame)
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureAppearance() {
        initOffers()
        configureView()
        addActions()
        configureSubviews()
        configureConstraints()
    }
    
}

// MARK: - Public Methods

extension PaywallOffersStackView {
    
    func diselectAllOffers() {
        if let arrangedSubviewsArray = stackView.arrangedSubviews as? [PaywallOfferView] {
            arrangedSubviewsArray.forEach { $0.isSelected = false }
        }
    }
    
    func getAllOffers() -> [PaywallOfferView]? {
        guard let arrangedSubviewsArray = stackView.arrangedSubviews as? [PaywallOfferView] else { return nil }
        return arrangedSubviewsArray
    }
    
    func initOffers() {
        
        switch paywallType {
            
        case .rect:
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = ThisSize.is12
            
            for _ in 0...2 {
                let offerView = PaywallRectOfferView()
                stackView.addArrangedSubview(offerView)
            }
            
        case .none:
            return
            
        case .oval:
            stackView.axis = .vertical
            stackView.spacing = ThisSize.is12
            
            for _ in 0...2 {
                let offerView = PaywallOvalOfferView()
                stackView.addArrangedSubview(offerView)
                
            }
            
        case .trialSwitch:
            stackView.axis = .vertical
            stackView.spacing = ThisSize.is16
            
            for _ in 0..<paywallType.defaultsOffers.count - 1 {
                let offerView = PaywallTrialOfferView()
                stackView.addArrangedSubview(offerView)
            }
        }
        
    }
    
}

// MARK: - Private Methods

private extension PaywallOffersStackView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension PaywallOffersStackView {
    
    func configureView() {
        backgroundColor = .clear
    }
    
    func configureSubviews() {
        
    }
    
}


// MARK: - Layout Setup

private extension PaywallOffersStackView {
    
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


