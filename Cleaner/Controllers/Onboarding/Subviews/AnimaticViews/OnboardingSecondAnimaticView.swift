//
//  OnboardingSecondAnimaticView.swift
//

import UIKit
import Lottie

final class OnboardingSecondAnimaticView: BaseView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
      
    // MARK: - Subviews
    
    private lazy var imageView = UIImageView()
    private lazy var animaticView = LottieAnimationView(filePath: Files.OnboardingAnimations.passwordOnb2.url.relativePath)
    
    // MARK: - Lifecycle
    
    override func configureAppearance() {
        configureView()
        setupActions()
        configureSubviews()
        configureConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}

// MARK: - Public Methods

extension OnboardingSecondAnimaticView {
    
}

// MARK: - Private Methods

private extension OnboardingSecondAnimaticView {
    
    func setupActions() {
        
    }
    
    func configureView() {
        
    }
    
    func configureSubviews() {
        
        imageView.do {
            $0.image = Generated.Image.onboardingSecond
            $0.contentMode = .scaleAspectFit
        }
        
        animaticView.loopMode = .loop
        animaticView.play()
        
    }
    
    func configureConstraints() {
        
        addSubviews([imageView, animaticView])
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        animaticView.snp.makeConstraints { make in
            make.centerY.equalTo(imageView.snp.bottom).offset(ThisSize.is12)
            make.leading.trailing.equalToSuperview()
        }
        
    }
    
}

