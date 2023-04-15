//
//  SecretFolderTitleView.swift
//

import Lottie
import UIKit

final class SecretFolderTitleView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private let darkAuthAnimationPath = Files.SecretFolderAnimations.authenticationDark.url.relativePath
    private let lightAuthAnimationPath = Files.SecretFolderAnimations.authenticationLight.url.relativePath
    
    private let darkLockAnimationPath = Files.SecretFolderAnimations.lockDark.url.relativePath
    private let lightLockAnimationPath = Files.SecretFolderAnimations.lockLight.url.relativePath
    
    // MARK: - Subviews
    
    private lazy var animaticView = LottieAnimationView()
    
    private lazy var titleLabel = UILabel()
    private lazy var subtitleLabel = UILabel()
    
    private lazy var backgroundImageView = UIImageView()
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(radius: 12)
    }
    
}

// MARK: - Public Methods

extension SecretFolderTitleView {
    
    func checkAuthentication() {
        DispatchQueue.main.async {
            self.configureSubviews()
        }
    }
    
}

// MARK: - Private Methods

private extension SecretFolderTitleView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension SecretFolderTitleView {
    
    func configureView() {
        backgroundColor = Generated.Color.secondaryBackground
    }
    
    func configureSubviews() {
        configureBackgroundImageView()
        configureAnimaticView()
        configureTitle()
        configureDivider()
    }
    
    func configureAnimaticView() {
        
        if LocaleStorage.secretIsAuthenticated {
            animaticView.animation = LottieAnimation.filepath(traitCollection.userInterfaceStyle == .dark ? darkLockAnimationPath : lightLockAnimationPath)
        } else {
            animaticView.animation = LottieAnimation.filepath(traitCollection.userInterfaceStyle == .dark ? darkAuthAnimationPath : lightAuthAnimationPath)
        }
        
        animaticView.contentMode = .scaleAspectFit
        animaticView.loopMode = .loop
        animaticView.play()
        
    }
    
    func configureBackgroundImageView() {
        
        if LocaleStorage.secretIsAuthenticated {
            backgroundImageView.image = Generated.Image.secretProtectedTitleBackgroundImage.withTintColor(Generated.Color.secondaryText.alpha(0.2))
        } else {
            backgroundImageView.image = Generated.Image.secretNonProtectedTitleBackgroundImage.withTintColor(Generated.Color.secondaryText.alpha(0.2))
        }
        
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    func configureTitle() {
        
        [titleLabel, subtitleLabel].forEach {
            $0.do {
                $0.textColor = Generated.Color.secondaryText
                $0.font = .systemFont(ofSize: 15, weight: .regular)
                $0.numberOfLines = 0
                $0.adjustsFontSizeToFitWidth = true
                $0.textAlignment = .center
            }
        }
        
        if LocaleStorage.secretIsAuthenticated {
            titleLabel.text = Generated.Text.SecretFolder.protectedPt1
            subtitleLabel.text = Generated.Text.SecretFolder.protectedPt2
        } else {
            titleLabel.text = Generated.Text.SecretFolder.notProtected
            subtitleLabel.text = ""
        }
        
    }
    
    func configureDivider() {
        divider.backgroundColor = Generated.Color.secondaryText
        divider.isHidden = !LocaleStorage.secretIsAuthenticated
    }
    
}


// MARK: - Layout Setup

private extension SecretFolderTitleView {
    
    func addSubviewsBefore() {
        
        backgroundImageView.addSubview(animaticView)
        addSubviews([backgroundImageView, titleLabel, divider, subtitleLabel])
        
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(ThisSize.is12)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16/2)
        }
        
        animaticView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(ThisSize.is20/2)
            make.centerX.equalToSuperview()
            make.width.equalTo(ThisSize.is64)
            make.height.equalTo(1)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(ThisSize.is20/2)
            make.leading.trailing.bottom.equalToSuperview().inset(ThisSize.is16)
        }
        
    }
    
    
}
