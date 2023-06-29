//
//  PaywallTrialFooterView.swift
//

import UIKit

final class PaywallTrialFooterView: UIView {
    
    // MARK: - UI Elements
    
    private lazy var titleLabel = UILabel()
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Life Cicle
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 12)
    }
    
}

// MARK: - Private Methods

private extension PaywallTrialFooterView {
    
    func configureAppearance() {
        configureView()
        configureSubview()
        addActions()
        addSubviews()
        addConstraints()
    }
    
}

// MARK: - Public Methods

extension PaywallTrialFooterView {
    
}

// MARK: - Actions

private extension PaywallTrialFooterView {
    
    func addActions() {
        
    }
    
}

// MARK: - Layout

private extension PaywallTrialFooterView {
    
    func configureView() {
        backgroundColor = .white
    }
    
    func configureSubview() {
        
    }
    
    func addSubviews() {

    }
    
    func addConstraints() {
        
    }
    
}

