//
//  SpeedTestSpeedInfoView.swift
//

import UIKit

final class SpeedTestSpeedInfoView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var titleLabel = UILabel()
    private lazy var speedView = SpeedTestCurrentSpeedView()
    
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

extension SpeedTestSpeedInfoView {
    
    func setSpeed(_ speed: String) {
        speedView.setSpeed(speed)
    }
    
    func setTitle(_ text: String) {
        titleLabel.text = text
    }
    
    func setIcon(_ icon: UIImage) {
        speedView.setIcon(icon)
    }
    
}

// MARK: - Private Methods

private extension SpeedTestSpeedInfoView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension SpeedTestSpeedInfoView {
    
    func configureView() {
        
    }
    
    func configureSubviews() {
        
       
        titleLabel.do {
            $0.textColor = Generated.Color.secondaryText
            $0.font = .systemFont(ofSize: 17, weight: .regular)
        }
        
    }
    
}


// MARK: - Layout Setup

private extension SpeedTestSpeedInfoView {
    
    func addSubviewsBefore() {
        addSubviews([titleLabel, speedView])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        speedView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(ThisSize.is16/2)
            make.centerX.equalTo(titleLabel)
            make.bottom.equalToSuperview()
        }
        
    }
    
}



