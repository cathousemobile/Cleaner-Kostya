//
//  OnboardingViewController.swift
//

import UIKit
import AttributedString
import AppTrackingTransparency

final class OnboardingViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let contentView = OnboardingView()

    // MARK: - Public Proporties
    
    // MARK: - Private Proporties
    
    private let onboardingDataArray: [OnboardingModel] = [OnboardingModel(animaticView: OnboardingFirstAnimaticView(),
                                                                          description: createFirstDescription()),
                                                          OnboardingModel(animaticView: OnboardingSecondAnimaticView(),
                                                                          description: createSecondDescription()),
                                                          OnboardingModel(animaticView: OnboardingThirdAnimaticView(),
                                                                          description: createThirdDescription()),
                                                          OnboardingModel(animaticView: OnboardingFourthAnimaticView(),
                                                                          description: createFourthDescription())]
    
    // MARK: - Life cycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: - Handlers

private extension OnboardingViewController {
    
    @objc func continueTap() {
        if contentView.getSlideStep() + 1 == onboardingDataArray.count {
            switchToMain()
        } else {
            leftSwipe()
        }
    }
    
}

// MARK: - Private Methods

private extension OnboardingViewController {
    
    func setupActions() {
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        contentView.addNewGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        contentView.addNewGestureRecognizer(swipeLeft)
        
        contentView.setContinueButtonAction { [weak self] in
            guard let self = self else { return }
            self.continueTap()
        }
        
    }
    
}

// MARK: - Navigation

private extension OnboardingViewController {
    
    func switchToMain() {
        AppDelegate.shared.appCoordiator.switchToMainScreen()
    }
    
}

// MARK: - Layout Setup

private extension OnboardingViewController {
    
    func setupView() {
        view = contentView
        contentView.setupSlideData(onboardingDataArray[0])
        contentView.setStepsCounts(onboardingDataArray.count)
    }
    
}

// MARK: - Swipe

private extension OnboardingViewController {
    
    @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
        
        switch gesture.direction {
            
        case UISwipeGestureRecognizer.Direction.right: rightSwipe()
            
        case UISwipeGestureRecognizer.Direction.left: leftSwipe()
            
        default:
            break
        }
        
    }
    
    func leftSwipe() {
        if let data = onboardingDataArray[safe: contentView.getSlideStep() + 1] {
            Task {
                if #available(iOS 14, *) {
                    let _ = await ATTrackingManager.requestTrackingAuthorization()
                    contentView.setupDataWithAnimation(data, animationDirection: .fromRight)
                    contentView.setStep(contentView.getSlideStep() + 1)
                } else {
                    contentView.setupDataWithAnimation(data, animationDirection: .fromRight)
                    contentView.setStep(contentView.getSlideStep() + 1)
                }
            }
        }
    }
    
    func rightSwipe() {
        if let data = onboardingDataArray[safe: contentView.getSlideStep() - 1] {
            contentView.setupDataWithAnimation(data, animationDirection: .fromLeft)
            contentView.setStep(contentView.getSlideStep() - 1)
        }
    }
    
}

// MARK: - Create Descriptions

private extension OnboardingViewController {
    
    static func createFirstDescription() -> ASAttributedString {
        
        let nsString = (Generated.Text.Onboarding.firstDescriptionFirstPartSelected +
                        Generated.Text.Onboarding.firstDescriptionSecondPart +
                        Generated.Text.Onboarding.firstDescriptionThirdPartSelected) as NSString

        var attributed = ASAttributedString(string: nsString as String)

        attributed.add(
            attributes: [.foreground(Generated.Color.selectedText)],
            range: nsString.range(of: Generated.Text.Onboarding.firstDescriptionFirstPartSelected)
        )
        attributed.add(
            attributes: [.foreground(Generated.Color.selectedText)],
            range: nsString.range(of: Generated.Text.Onboarding.firstDescriptionThirdPartSelected)
        )

        return attributed
    }
    
    static func createSecondDescription() -> ASAttributedString {
        
        let nsString = (Generated.Text.Onboarding.secondDescriptionFirstPart +
                        Generated.Text.Onboarding.secondDescriptionSecondPartSelected +
                        Generated.Text.Onboarding.secondDescriptionThirdPart) as NSString

        var attributed = ASAttributedString(string: nsString as String)

        attributed.add(
            attributes: [.foreground(Generated.Color.selectedText)],
            range: nsString.range(of: Generated.Text.Onboarding.secondDescriptionSecondPartSelected)
        )
        
        return attributed
    }
    
    static func createThirdDescription() -> ASAttributedString {
        
        let nsString = (Generated.Text.Onboarding.thirdDescriptionFirstPart +
                        Generated.Text.Onboarding.thirdDescriptionSecondPartSelected +
                        Generated.Text.Onboarding.thirdDescriptionThirdPart) as NSString

        var attributed = ASAttributedString(string: nsString as String)

        attributed.add(
            attributes: [.foreground(Generated.Color.selectedText)],
            range: nsString.range(of: Generated.Text.Onboarding.thirdDescriptionSecondPartSelected)
        )

        return attributed
    }
    
    static func createFourthDescription() -> ASAttributedString {
        
        let nsString = (Generated.Text.Onboarding.fourthDescriptionFirstPart +
                        Generated.Text.Onboarding.fourthDescriptionSecondPartSelected +
                        Generated.Text.Onboarding.fourthDescriptionThirdPart) as NSString

        var attributed = ASAttributedString(string: nsString as String)

        attributed.add(
            attributes: [.foreground(Generated.Color.selectedText)],
            range: nsString.range(of: Generated.Text.Onboarding.fourthDescriptionSecondPartSelected)
        )
        
        return attributed
    }
    
}
