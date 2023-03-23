//
//  SpeedTestCurrentSpeedView.swift
//

import UIKit

final class SpeedTestCurrentSpeedView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var speedLabel = UILabel()
    private lazy var mbLabel = UILabel()
    
    private lazy var iconView = UIImageView()
    
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

extension SpeedTestCurrentSpeedView {
    
    func setSpeed(_ speed: String) {
        speedLabel.text = speed
    }
    
    func setIcon(_ icon: UIImage) {
        iconView.image = icon
    }
    
}

// MARK: - Private Methods

private extension SpeedTestCurrentSpeedView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension SpeedTestCurrentSpeedView {
    
    func configureView() {
        
    }
    
    func configureSubviews() {
        
        mbLabel.do {
            $0.text = " Mb"
            $0.textColor = Generated.Color.secondaryText
            $0.font = .systemFont(ofSize: 17, weight: .regular)
        }
        
        speedLabel.do {
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 20, weight: .regular)
        }
        
    }
    
}

// MARK: - Layout Setup

private extension SpeedTestCurrentSpeedView {
    
    func addSubviewsBefore() {
        addSubviews([iconView, speedLabel, mbLabel])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(speedLabel)
        }
        
        speedLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(ThisSize.is12/3)
            make.top.bottom.equalToSuperview()
        }
        
        mbLabel.snp.makeConstraints { make in
            make.leading.equalTo(speedLabel.snp.trailing).offset(ThisSize.is12/3)
            make.centerY.equalTo(speedLabel)
            make.trailing.equalToSuperview()
        }
        
    }
    
}
