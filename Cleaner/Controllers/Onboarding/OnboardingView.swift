//
//  OnboardingView.swift
//

import UIKit
import AttributedString

final class OnboardingView: BaseView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private lazy var stepsCount: Int = 0
    private lazy var currentStep: Int = 0
    
    // MARK: - Subviews
    
    private lazy var animaticView = UIView()
    private lazy var descriptionLabel = UILabel()
    private lazy var continueButton = CustomButtonView()
    
    // MARK: - Lifecycle
    
    override func configureAppearance() {
        configureView()
        configureSubviews()
        configureConstraints()
    }
    
}

// MARK: - Public Methods

extension OnboardingView {
    
    func setupSlideData(_ data: OnboardingModel) {
        DispatchQueue.main.async { [weak self] in
            self?.animaticView.addSubview(data.animaticView)
            data.animaticView.snp.makeConstraints { $0.edges.equalToSuperview() }
            self?.descriptionLabel.attributed.text = data.description
        }
    }
    
    func setupDataWithAnimation(_ data: OnboardingModel, animationDirection: CATransitionSubtype) {
        let transition = CATransition()
        transition.type = .push
        transition.subtype = animationDirection
        transition.duration = 0.45
        
        animaticView.layer.add(transition, forKey: "AnimationChange")
        descriptionLabel.layer.add(transition, forKey: "DescriptionChange")

        DispatchQueue.main.async { [weak self] in
            self?.animaticView.subviews.forEach { $0.removeFromSuperview() }
            self?.animaticView.addSubview(data.animaticView)
            data.animaticView.snp.makeConstraints { $0.edges.equalToSuperview() }
            self?.descriptionLabel.attributed.text = data.description
        }
    }
    
    func addNewGestureRecognizer(_ gesture: UIGestureRecognizer) {
        descriptionLabel.addGestureRecognizer(gesture)
        animaticView.addGestureRecognizer(gesture)
    }
    
    func setStepsCounts(_ count: Int) {
        stepsCount = count
    }
    
    func setStep(_ step: Int) {
        currentStep = step
    }
    
    func getSlideStep() -> Int {
        currentStep
    }
    
    func setContinueButtonAction(_ action: @escaping EmptyBlock) {
        continueButton.setAction(action)
    }
    
}

// MARK: - Private Methods

private extension OnboardingView {
    
    func configureView() {
        backgroundColor = Generated.Color.mainBackground
    }
    
    func configureSubviews() {
        
        continueButton.setTitle(text: Generated.Text.Common.continue)
        
        descriptionLabel.do {
            $0.font = UIFont.systemFont(ofSize: 32, weight: .regular)
            $0.numberOfLines = 3
            $0.textAlignment = .center
        }
        
    }
    
    func configureConstraints() {
        
        addSubviews([animaticView, descriptionLabel, continueButton])
        
        animaticView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.trailing.leading.equalToSuperview()
            make.bottom.lessThanOrEqualTo(continueButton.snp.top)
            make.height.equalTo(UIScreen.main.bounds.height * 0.62)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(animaticView.snp.bottom).offset(ThisSize.is24)
            make.trailing.leading.equalToSuperview().inset(ThisSize.is16)
            make.bottom.lessThanOrEqualTo(continueButton.snp.top).offset(-ThisSize.is32)
        }
        
        continueButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-ThisSize.is16/2)
        }
        
    }
    
}

