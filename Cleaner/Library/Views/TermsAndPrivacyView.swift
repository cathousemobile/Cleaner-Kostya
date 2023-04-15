//
//  TermsAndPrivacyView.swift
//

import UIKit
import AttributedString

final class TermsAndPrivacyView: UIView {
    
    // MARK: - Private Properties
    
    private lazy var terms = ASAttributedString(string: "Terms of Use")
    private lazy var privacy = ASAttributedString(string: "Privacy Policy")
    
    // MARK: - Subviews
    
    private lazy var agreementLabel = UILabel()
    
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
        configureSubviews()
        configureConstraints()
    }
    
}

// MARK: - Public Methods

extension TermsAndPrivacyView {
    
}

// MARK: - Private Methods

private extension TermsAndPrivacyView {
    
    func configureView() {
        
    }
    
    func configureSubviews() {
        
        agreementLabel.font = .systemFont(ofSize: 12, weight: .regular)
        agreementLabel.textColor = Generated.Color.primaryText
        
        initAttributedStrings()
        
    }
    
    func configureConstraints() {
        
        addSubview(agreementLabel)
        
        agreementLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
}

// MARK: - Attributed String

extension TermsAndPrivacyView {
    
    private func initAttributedStrings() {
                
        privacy.set(attributes: [
            .font(.systemFont(ofSize: 12, weight: .medium)),
            .underline(.single, color: Generated.Color.buttonBackground),
            .foreground(Generated.Color.buttonBackground)
        ], range: NSRange(location: 0, length: privacy.length))
        
        terms.set(attributes: [
            .font(.systemFont(ofSize: 12, weight: .medium)),
            .underline(.single, color: Generated.Color.buttonBackground),
            .foreground(Generated.Color.buttonBackground)
        ], range: NSRange(location: 0, length: terms.length))
        
        agreementLabel.attributed.text = privacy + " and " + terms
        
    }
    
    func setupActions(presentPrivacy: @escaping EmptyBlock, presentTerms: @escaping EmptyBlock) {
        
        privacy.add(attributes: [.action([
            .foreground(Generated.Color.buttonBackground.darker(by: 0.3)),
            .underline(.single, color: Generated.Color.buttonBackground),
        ], {
            presentPrivacy()
        })])
        
        terms.add(attributes: [.action([
            .foreground(Generated.Color.buttonBackground.darker(by: 0.3)),
            .underline(.single, color: Generated.Color.buttonBackground),
        ], {
            presentTerms()
        })])
        
    }
    
}
