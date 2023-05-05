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
    
    private lazy var scrollView = UIScrollView()
    private lazy var insideScrollView = UIView()
    
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
    
    func purchseButtonIsEnabled(_ isEnabled: Bool) {
        purchaseButton.shouldBeEnabled(isEnabled)
    }
    
    func purchaseInProgress(_ inProgress: Bool) {
        purchaseButton.shouldBeLoading(inProgress)
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
        
        scrollView.showsVerticalScrollIndicator = false
        
        restoreButton.setTitle(text: Generated.Text.Common.restore)
        
        closeButton.setImage(Generated.Image.closeButton)
        closeButton.isUserInteractionEnabled = true
        
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
        insideScrollView.addSubviews([restoreButton, closeButton])
        scrollView.addSubview(insideScrollView)
        addSubviews([scrollView])
        
        switch paywallType {
            
        case .rect:
            insideScrollView.addSubviews([animaticView, titleLabel, subtitleLabel, stackFeaturesView])
            addSubviews([stackOffersView!, purchaseButton, termsAndPrivacyView])
            
        case .none:
            insideScrollView.addSubviews([titleLabel, animaticView, stackFeaturesView])
            addSubviews([subtitleLabel, purchaseButton, termsAndPrivacyView])
            
        case .oval:
            insideScrollView.addSubviews([titleLabel, ovalTitleImageView, stackFeaturesView])
            addSubviews([stackOffersView!, purchaseButton, termsAndPrivacyView])
            
        }
        
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        restoreButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(ThisSize.is16)
            make.centerY.equalTo(closeButton)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
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
            make.top.equalToSuperview()
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
            make.bottom.equalToSuperview()
        }
        
        insideScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(stackOffersView!.snp.top).offset(-ThisSize.is16)
        }
        
        stackOffersView!.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }

        purchaseButton.snp.makeConstraints { make in
            make.top.equalTo(stackOffersView!.snp.bottom).offset(ThisSize.is28)
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
            make.top.equalTo(closeButton.snp.bottom).offset(ThisSize.is36)
            make.centerX.equalToSuperview()
        }
        
        animaticView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(ThisSize.is88*2.7)
        }
        
        stackFeaturesView.snp.makeConstraints { make in
            make.top.equalTo(animaticView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is24)
            make.bottom.equalToSuperview()
        }
        
        insideScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(subtitleLabel.snp.top).offset(-ThisSize.is16)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        
        purchaseButton.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(ThisSize.is16)
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
            make.top.equalTo(closeButton.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        ovalTitleImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(ThisSize.is20)
            make.leading.trailing.equalToSuperview()
        }
        
        stackFeaturesView.snp.makeConstraints { make in
            make.top.equalTo(ovalTitleImageView.snp.bottom).offset(ThisSize.is16)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is56)
            make.bottom.equalToSuperview()
        }
        
        insideScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(stackOffersView!.snp.top).offset(-ThisSize.is16)
        }
        
        stackOffersView!.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(ThisSize.is20)
        }
        
        purchaseButton.snp.makeConstraints { make in
            make.top.equalTo(stackOffersView!.snp.bottom).offset(ThisSize.is16)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        termsAndPrivacyView.snp.makeConstraints { make in
            make.top.equalTo(purchaseButton.snp.bottom).offset(ThisSize.is12)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
    }
    
}

