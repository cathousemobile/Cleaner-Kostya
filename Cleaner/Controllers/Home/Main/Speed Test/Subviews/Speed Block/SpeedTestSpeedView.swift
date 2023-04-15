//
//  SpeedTestSpeedView.swift
//

import UIKit

final class SpeedTestSpeedView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var downloadView = SpeedTestSpeedInfoView()
    private lazy var uploadView = SpeedTestSpeedInfoView()
    
    private lazy var divider = UIView()
    
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

extension SpeedTestSpeedView {
    
    func setDownloadSpeed(_ speed: String) {
        downloadView.setSpeed(speed)
    }
    
    func setUploadSpeed(_ speed: String) {
        uploadView.setSpeed(speed)
    }
    
}

// MARK: - Private Methods

private extension SpeedTestSpeedView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension SpeedTestSpeedView {
    
    func configureView() {
        
    }
    
    func configureSubviews() {
        
        divider.backgroundColor = Generated.Color.secondaryText
        
        downloadView.setTitle(Generated.Text.SpeedTest.download)
        downloadView.setIcon(Generated.Image.speedTestDownloadIcon)
        
        uploadView.setTitle(Generated.Text.SpeedTest.upload)
        uploadView.setIcon(Generated.Image.speedTestUploadIcon)
        
    }
    
}


// MARK: - Layout Setup

private extension SpeedTestSpeedView {
    
    func addSubviewsBefore() {
        addSubviews([downloadView, divider, uploadView])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        downloadView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(divider.snp.leading).offset(-ThisSize.is12)
        }
        
        divider.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(ThisSize.is20)
            make.width.equalTo(1)
        }
        
        uploadView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalTo(divider.snp.trailing).offset(ThisSize.is12)
        }
        
    }
    
}



