//
//  MainCalcuatingDescriptionView.swift
//

import Foundation
import UIKit

final class MainCalcuatingDescriptionView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var titleLabel = UILabel()
    private lazy var dotView = UIImageView()
    
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

extension MainCalcuatingDescriptionView {
    
    func setDotImage(_ image: UIImage) {
        dotView.image = image
    }
    
    func setTitleText(_ text: String) {
        titleLabel.text = text
    }
    
}

// MARK: - Private Methods

private extension MainCalcuatingDescriptionView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension MainCalcuatingDescriptionView {
    
    func configureView() {
        
    }
    
    func configureSubviews() {
        
        titleLabel.do {
            $0.textColor = Generated.Color.secondaryText
            $0.font = .systemFont(ofSize: 12, weight: .regular)
        }
        
    }
    
}


// MARK: - Layout Setup

private extension MainCalcuatingDescriptionView {
    
    func addSubviewsBefore() {
        addSubviews([dotView, titleLabel])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        dotView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(ThisSize.is12/3)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(dotView.snp.trailing).offset(ThisSize.is12/3)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(dotView)
        }
        
    }
    
}



