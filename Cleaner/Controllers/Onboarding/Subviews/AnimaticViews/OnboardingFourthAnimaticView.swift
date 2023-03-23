//
//  OnboardingFourthAnimaticView.swift
//

import UIKit
import Lottie

final class OnboardingFourthAnimaticView: BaseView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
      
    // MARK: - Subviews
    
    private lazy var animaticView = LottieAnimationView(filePath: Files.SpeedTestAnimations.speedTestBlueLight.url.relativePath)
    private lazy var circularProgressView = CircularProgressView()
    private lazy var imageView = UIImageView()
    
    // MARK: - Lifecycle
    
    override func configureAppearance() {
        configureView()
        setupActions()
        configureSubviews()
        configureConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureProgress()
    }
    
}

// MARK: - Public Methods

extension OnboardingFourthAnimaticView {
    
}

// MARK: - Private Methods

private extension OnboardingFourthAnimaticView {
    
    func setupActions() {
        
    }
    
    func configureView() {
        
    }
    
    func configureSubviews() {
        
        imageView.do {
            $0.image = Generated.Image.speedTestOnboarding
            $0.contentMode = .scaleAspectFit
        }
        
        animaticView.loopMode = .loop
        animaticView.play()
        
        circularProgressView.updateProgress(to: 0.9)
        
    }
    
    func configureConstraints() {
        
        addSubviews([animaticView, imageView, circularProgressView])
        
        animaticView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
}

// MARK: - ProgressView

private extension OnboardingFourthAnimaticView {
    
    func configureProgress() {
        
        circularProgressView.createCircularPath(fillColor: .white.withAlphaComponent(0.2), progressColor: Generated.Color.selectedText, fillWidth: 10, progressWidth: 10)
        
        circularProgressView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(imageView.frame.height)
            make.width.equalTo(imageView.frame.width)
        }
        
    }
    
}
