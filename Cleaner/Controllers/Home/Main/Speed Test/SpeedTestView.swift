//
//  SpeedTestView.swift
//

import UIKit

final class SpeedTestView: UIView {
    
    typealias GeneratedText = Generated.Text.SpeedTest
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var progressView = SpeedTestProgressView()
    
    private lazy var speedView = SpeedTestSpeedView()
    
    private lazy var speedTestButton = CustomButtonView()
    
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
    
}

// MARK: - Public Methods

extension SpeedTestView {
    
    func setSpeedTestButonAction(_ action: @escaping EmptyBlock) {
        speedTestButton.setAction(action)
    }
    
    func speedTestButtonShouldBeLocked(_ isLocked: Bool) {
        speedTestButton.shouldBeLocked(isLocked)
    }
    
    func speedTestButtonShouldBeEnabled(_ isEnabled: Bool) {
        TransitionHelper.with(speedTestButton)
        speedTestButton.shouldBeEnabled(isEnabled)
        speedTestButton.setTitle(text: isEnabled ? GeneratedText.testNetwork : GeneratedText.testing)
    }
    
    func setDownloadSpeed(_ speed: String) {
        speedView.setDownloadSpeed(speed)
    }
    
    func setUploadSpeed(_ speed: String) {
        speedView.setUploadSpeed(speed)
    }
    
    func updateCurrentSpeed(_ speed: String) {
        progressView.updateCurrentSpeed(speed)
    }
    
    func changeProgressStyle(_ style: SpeedTestProgressView.ProgressStyle) {
        TransitionHelper.with(progressView)
        progressView.changeStyle(style)
    }
    
    func updateProgress(_ progress: CGFloat) {
        progressView.updateProgress(progress)
    }
    
    func playAnimation() {
        progressView.playAnimation()
    }
    
    func stopAnimation() {
        progressView.stopAnimation()
    }
    
    func setConnectionInfo(_ info: String) {
        progressView.setConnectionInfo(info)
    }
    
}

// MARK: - Private Methods

private extension SpeedTestView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension SpeedTestView {
    
    func configureView() {
        backgroundColor = Generated.Color.mainBackground
    }
    
    func configureSubviews() {
        
        speedView.setUploadSpeed("0")
        speedView.setDownloadSpeed("0")
        
        speedTestButton.setTitle(text: GeneratedText.testNetwork)
        
    }
    
}


// MARK: - Layout Setup

private extension SpeedTestView {
    
    func addSubviewsBefore() {
        addSubviews([progressView, speedView, speedTestButton])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        progressView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(speedView.snp.top)
        }
        
        speedView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(ThisSize.is16)
            make.bottom.equalTo(speedTestButton.snp.top).offset(-ThisSize.is72)
        }
        
        speedTestButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-ThisSize.is12)
        }
        
    }
    
}



