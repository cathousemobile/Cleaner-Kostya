//
//  PaywallView.swift
//

import UIKit
import Lottie
import AttributedString

final class PaywallView: UIView {
    
    typealias Text = Generated.Text.Paywall
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private let paywallType: PaywallViewTypeModel
    
    // MARK: - Subviews
    
    private let stackFeaturesView: PaywallFeaturesStackView
    private let stackOffersView: PaywallOffersStackView?
    
    private lazy var ovalTitleImageView = UIImageView()
    
    private lazy var titleLabel = UILabel()
    private lazy var subtitleLabel = UILabel()
    
    private lazy var animaticView = LottieAnimationView()
    
    private lazy var closeButton = CustomImageButton()
    private lazy var restoreButton = CustomLabelButton()
    private lazy var purchaseButton = CustomButtonView()
    
    private lazy var termsAndPrivacyView = TermsAndPrivacyView()
    
    // MARK: - Lifecycle
    
    init(frame: CGRect = .zero, paywallType: PaywallViewTypeModel) {
        self.paywallType = paywallType
        self.stackFeaturesView = PaywallFeaturesStackView(paywallType: paywallType)
        self.stackOffersView = PaywallOffersStackView(paywallType: paywallType)
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

extension PaywallView {
    
    func getAllOffers() -> [PaywallOfferView]? {
        stackOffersView?.getAllOffers()
    }
    
    func setPurchaseButtonTitle(_ text: String) {
        purchaseButton.setTitle(text: text)
    }
    
    func setPurchaseButtonAction(_ action: @escaping EmptyBlock) {
        purchaseButton.setAction(action)
    }
    
    func setPrivacyAndTermsActions(privacyAction: @escaping EmptyBlock, termsAction: @escaping EmptyBlock) {
        termsAndPrivacyView.setupActions(presentPrivacy: privacyAction, presentTerms: termsAction)
    }
    
    func setRestoreButtonAction(_ action: @escaping EmptyBlock) {
        restoreButton.setAction(action)
    }
    
    func setCloseButtonAction(_ action: @escaping EmptyBlock) {
        closeButton.setAction(action)
    }
    
}

// MARK: - Private Methods

private extension PaywallView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension PaywallView {
    
    func configureView() {
        backgroundColor = Generated.Color.mainBackground
    }
    
    func configureSubviews() {
        
        restoreButton.setTitle(text: Generated.Text.Common.restore)
        
        closeButton.setImage(Generated.Image.closeButton)
        
        titleLabel.do {
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 27, weight: .bold)
        }
        
        switch paywallType {
            
        case .rect:
            configureRectSubviews()
        case .none:
            configureNoneSubviews()
        case .oval:
            configureOvalSubviews()
        }
        
        purchaseButton.setTitle(text: Text.allTrial)
        
    }
    
    func configureRectSubviews() {
        
        animaticView.animation = LottieAnimation.filepath(Files.PaywallAnimations.crownPaywall.url.relativePath)
        animaticView.contentMode = .scaleAspectFit
        animaticView.loopMode = .loop
        animaticView.play()
        
        titleLabel.text = Text.squareAndOvalTitle
        
        subtitleLabel.do {
            $0.text = Text.squareSubtitle
            $0.textColor = Generated.Color.secondaryText
            $0.font = .systemFont(ofSize: 15, weight: .regular)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
    }
    
    func configureNoneSubviews() {
        
        animaticView.animation = LottieAnimation.filepath(Files.PaywallAnimations.broomPaywall.url.relativePath)
        animaticView.contentMode = .scaleAspectFit
        animaticView.loopMode = .loop
        animaticView.play()
        
        let appName: ASAttributedString = .init(string: "Name",
                                                .font(.systemFont(ofSize: 27, weight: .bold)),
                                                .foreground(Generated.Color.buttonBackground)
        )
        
        titleLabel.attributed.text = Text.noneTitle + appName
        
        subtitleLabel.do {
            $0.textColor = Generated.Color.secondaryText
            $0.font = .systemFont(ofSize: 15, weight: .regular)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        let trialAttributed: ASAttributedString = .init(string: Text.noneTrialDescriptionPt2,
                                                .font(.systemFont(ofSize: 15, weight: .medium)),
                                                .foreground(Generated.Color.buttonBackground)
        )
        
        subtitleLabel.attributed.text = Text.noneTrialDescriptionPt1 + trialAttributed + Text.noneTrialDescriptionPt3
        
    }
    
    func configureOvalSubviews() {
        
        titleLabel.text = Text.squareAndOvalTitle
        
        ovalTitleImageView.image = Generated.Image.ovalPaywallTitle
        
    }
    
}


// MARK: - Layout Setup

private extension PaywallView {
    
    func addSubviewsBefore() {
        
        addSubviews([restoreButton, closeButton])
        
        switch paywallType {
            
        case .rect:
            addSubviews([animaticView, titleLabel, subtitleLabel, stackFeaturesView, stackOffersView!, purchaseButton, termsAndPrivacyView])
            
        case .none:
            addSubviews([titleLabel, stackFeaturesView, animaticView, subtitleLabel, purchaseButton, termsAndPrivacyView])
            
        case .oval:
            addSubviews([titleLabel, ovalTitleImageView, stackFeaturesView, stackOffersView!, purchaseButton, termsAndPrivacyView])
            
        }
        
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        restoreButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(ThisSize.is16)
            make.centerY.equalTo(closeButton)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.trailing.equalToSuperview().offset(-ThisSize.is16/2)
        }
        
        switch paywallType {
            
        case .rect:
            configureRectSubviewsConstaraints()
            
        case .none:
            configureNoneSubviewsConstaraints()
            
        case .oval:
            configureOvalSubviewsConstaraints()
            
        }
        
    }
    
    func configureRectSubviewsConstaraints() {
        
        animaticView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.height.equalTo(ThisSize.is72*1.7)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(animaticView.snp.bottom).offset(-ThisSize.is20)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(ThisSize.is12)
            make.centerX.equalToSuperview()
        }
        
        stackFeaturesView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(ThisSize.is28)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is24)
        }
        
        stackOffersView!.snp.makeConstraints { make in
            make.top.equalTo(stackFeaturesView.snp.bottom).offset(ThisSize.is48)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        purchaseButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(stackOffersView!.snp.bottom).offset(ThisSize.is28)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        termsAndPrivacyView.snp.makeConstraints { make in
            make.top.equalTo(purchaseButton.snp.bottom).offset(ThisSize.is12)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
    }
    
    func configureNoneSubviewsConstaraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(ThisSize.is64)
            make.centerX.equalToSuperview()
        }
        
        stackFeaturesView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(ThisSize.is36)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is24)
        }
        
        animaticView.snp.makeConstraints { make in
            make.top.equalTo(stackFeaturesView.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(ThisSize.is88*2.7)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(animaticView.snp.bottom).offset(ThisSize.is20)
            make.centerX.equalToSuperview()
        }
        
        purchaseButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(subtitleLabel.snp.bottom).offset(ThisSize.is16)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        termsAndPrivacyView.snp.makeConstraints { make in
            make.top.equalTo(purchaseButton.snp.bottom).offset(ThisSize.is12)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
    }
    
    func configureOvalSubviewsConstaraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(ThisSize.is36)
            make.centerX.equalToSuperview()
        }
        
        ovalTitleImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(ThisSize.is20)
            make.centerX.equalToSuperview()
        }
        
        stackFeaturesView.snp.makeConstraints { make in
            make.top.equalTo(ovalTitleImageView.snp.bottom).offset(ThisSize.is16)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is64)
        }
        
        stackOffersView!.snp.makeConstraints { make in
            make.top.equalTo(stackFeaturesView.snp.bottom).offset(ThisSize.is16)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is20)
        }
        
        purchaseButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(stackOffersView!.snp.bottom).offset(ThisSize.is16)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        termsAndPrivacyView.snp.makeConstraints { make in
            make.top.equalTo(purchaseButton.snp.bottom).offset(ThisSize.is12)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
    }
    
}

