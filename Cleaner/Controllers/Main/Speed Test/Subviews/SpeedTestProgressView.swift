//
//  SpeedTestProgressView.swift
//

import UIKit
import Lottie

final class SpeedTestProgressView: UIView {
    
    typealias Animation = Files.SpeedTestAnimations
    
    // MARK: - Public Properties
    
    enum ProgressStyle {
        case download
        case upload
    }
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var speedLabel = UILabel()
    private lazy var connectionInfoLabel = UILabel()
    
    private lazy var dotCircleImage = UIImageView()
    private lazy var arrowsImage = UIImageView()
    
    private lazy var progressView = CircularProgressView()
    
    private lazy var animaticView = LottieAnimationView()
    
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureProgress()
    }
    
}

// MARK: - Public Methods

extension SpeedTestProgressView {
    
    func changeStyle(_ style: ProgressStyle) {
        
        switch style {

        case .download:
            progressView.setProgressCircleColor(Generated.Color.selectedText)
            animaticView.animation = LottieAnimation.filepath(traitCollection.userInterfaceStyle == .dark ? Animation.speedTestBlueDark.path : Animation.speedTestBlueLight.path)
        case .upload:
            progressView.setProgressCircleColor(Generated.Color.uploadProgressBarColor)
            animaticView.animation = LottieAnimation.filepath(traitCollection.userInterfaceStyle == .dark ? Animation.speedTestOrangeDark.path : Animation.speedTestOrangeLight.path)
        }
        
    }
    
    func playAnimation() {
        animaticView.loopMode = .loop
        animaticView.play()
    }
    
    func stopAnimation() {
        animaticView.stop()
    }
    
    func updateCurrentSpeed(_ speed: String) {
        speedLabel.text = speed
    }
    
    func updateProgress(_ progress: CGFloat) {
        progressView.updateProgress(to: progress)
    }
    
    func setConnectionInfo(_ info: String) {
        TransitionHelper.with(connectionInfoLabel)
        connectionInfoLabel.text = info + " / Mbps"
    }
    
}

// MARK: - Private Methods

private extension SpeedTestProgressView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension SpeedTestProgressView {
    
    func configureView() {
        
    }
    
    func configureSubviews() {
        
        dotCircleImage.image = Generated.Image.speedTestDotsCircleDark.withTintColor(Generated.Color.primaryText)
        arrowsImage.image = Generated.Image.speedTestArrows
       
        speedLabel.do {
            $0.text = "0"
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 44, weight: .regular)
        }
        
        connectionInfoLabel.do {
            $0.textColor = Generated.Color.secondaryText
            $0.font = .systemFont(ofSize: 13, weight: .regular)
        }
        
    }
    
}


// MARK: - Layout Setup

private extension SpeedTestProgressView {
    
    func addSubviewsBefore() {
        addSubviews([animaticView, speedLabel, connectionInfoLabel, arrowsImage, dotCircleImage, progressView])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        speedLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        arrowsImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(speedLabel.snp.top)
        }
        
        connectionInfoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(speedLabel.snp.bottom)
        }
        
        dotCircleImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        animaticView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
}

// MARK: - ProgressView

private extension SpeedTestProgressView {
    
    func configureProgress() {
        
        progressView.createCircularPath(fillWidth: 8, progressWidth: 8)
        
        progressView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(dotCircleImage.frame.height + ThisSize.is20)
            make.width.equalTo(dotCircleImage.frame.width + ThisSize.is20)
        }
        
    }
    
}

