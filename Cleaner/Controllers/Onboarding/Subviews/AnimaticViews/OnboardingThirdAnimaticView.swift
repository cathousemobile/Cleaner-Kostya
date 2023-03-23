//
//  OnboardingThirdAnimaticView.swift
//

import UIKit
import Lottie

final class OnboardingThirdAnimaticView: BaseView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
      
    // MARK: - Subviews
    
    private lazy var imageView = UIImageView()
    private lazy var animaticView = LottieAnimationView(filePath: Files.OnboardingAnimations.folderOnb3.url.relativePath)
    
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

extension OnboardingThirdAnimaticView {
    
}

// MARK: - Private Methods

private extension OnboardingThirdAnimaticView {
    
    func setupActions() {
        
    }
    
    func configureView() {
        
    }
    
    func configureSubviews() {
        
        imageView.do {
            $0.image = Generated.Image.onboardingThird
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
            make.leading.trailing.equalToSuperview()
            make.centerY.equalTo(imageView)
        }
        
    }
    
}

