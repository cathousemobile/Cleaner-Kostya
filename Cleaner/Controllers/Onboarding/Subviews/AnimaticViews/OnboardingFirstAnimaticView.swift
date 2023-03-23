//
//  OnboardingFirstAnimaticView.swift
//

import UIKit
import Lottie

final class OnboardingFirstAnimaticView: BaseView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
      
    // MARK: - Subviews
    
    private lazy var imageView = UIImageView()
    private lazy var animaticView = LottieAnimationView(filePath: Files.OnboardingAnimations.starsOnb1.url.relativePath)
    
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

extension OnboardingFirstAnimaticView {
    
}

// MARK: - Private Methods

private extension OnboardingFirstAnimaticView {
    
    func setupActions() {
        
    }
    
    func configureView() {
        
    }
    
    func configureSubviews() {
        
        imageView.do {
            $0.image = Generated.Image.onboardingFirst
            $0.contentMode = .scaleAspectFit
        }
        
        animaticView.loopMode = .loop
        animaticView.play()
        
    }
    
    func configureConstraints() {
        
        addSubviews([imageView, animaticView])
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        animaticView.snp.makeConstraints { make in
            make.edges.equalTo(imageView)
        }
        
    }
    
}

