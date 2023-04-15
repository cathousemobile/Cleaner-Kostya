//
//  MainSystemInfoView.swift
//

import Foundation
import UIKit

final class MainSystemInfoView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var deviceNameLabel = UILabel()
    private lazy var memorySizeLabel = UILabel()
    private lazy var calculatingView = MainCalculatingView()
    
    private lazy var progressView = UIProgressView(progressViewStyle: .bar)
    private lazy var photoProgressView = UIProgressView(progressViewStyle: .bar)
    private lazy var contactsProgressView = UIProgressView(progressViewStyle: .bar)
    
    private lazy var photoContactsDivider = UIView()
    private lazy var contactsOtherDivider = UIView()
    
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
        
        layer.cornerRadius = 12
        clipsToBounds = true
        
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true
        
        photoProgressView.layer.cornerRadius = 4
        photoProgressView.clipsToBounds = true
        
        contactsProgressView.layer.cornerRadius = 4
        contactsProgressView.clipsToBounds = true
        
    }
    
}

// MARK: - Public Methods

extension MainSystemInfoView {
    
    func calculatingIsFinished(_ isFinished: Bool) {
        calculatingView.calculatingIsFinished(isFinished)
    }
    
    func setProgress(progress: Float, photoProgress: Float, contactsProgress: Float) {

        if progress - (photoProgress + contactsProgress) >= 0 {
            self.progressView.setProgress(progress, animated: true)
            self.photoProgressView.setProgress(photoProgress, animated: true)
            self.contactsProgressView.setProgress(photoProgress + contactsProgress, animated: true)
            self.setDividers(photoContactsEnd: photoProgress, contactsOtherEnd: photoProgress + contactsProgress)
        }
        
    }
    
    func setDividers(photoContactsEnd: Float, contactsOtherEnd: Float) {
        
        TransitionHelper.with(photoContactsDivider)
        TransitionHelper.with(contactsOtherDivider)
        
        photoContactsDivider.isHidden = progressView.frame.width * CGFloat(photoContactsEnd) <= 2
        contactsOtherDivider.isHidden = progressView.frame.width * CGFloat(contactsOtherEnd - photoContactsEnd) <= 2
        
        photoContactsDivider.snp.remakeConstraints { make in
            make.leading.equalTo(progressView).offset(progressView.frame.width * CGFloat(photoContactsEnd) - 1)
            make.width.equalTo(1)
            make.top.bottom.equalTo(progressView).inset(-1)
        }
        
        contactsOtherDivider.snp.remakeConstraints { make in
            make.leading.equalTo(progressView).offset(progressView.frame.width * CGFloat(contactsOtherEnd) - 1)
            make.width.equalTo(1)
            make.top.bottom.equalTo(progressView).inset(-1)
        }
        
    }
    
    func setMemorySpaces(_ totalSpace: String, useSpace: String) {
        TransitionHelper.with(memorySizeLabel)
        memorySizeLabel.text = Generated.Text.Main.usedMemory(useSpace, totalSpace)
    }
    
    func setDeviceName(_ deviceName: String) {
        TransitionHelper.with(deviceNameLabel)
        deviceNameLabel.text = deviceName
    }
    
}

// MARK: - Private Methods

private extension MainSystemInfoView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension MainSystemInfoView {
    
    func configureView() {
        backgroundColor = Generated.Color.secondaryBackground
    }
    
    func configureSubviews() {
        
        deviceNameLabel.do {
            $0.text = "Loading..."
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 17, weight: .regular)
        }
        
        memorySizeLabel.do {
            $0.text = "Calculating..."
            $0.textColor = Generated.Color.secondaryText
            $0.font = .systemFont(ofSize: 15, weight: .regular)
        }
        
        progressView.progressTintColor = Generated.Color.progressBarTint
        progressView.trackTintColor = Generated.Color.progressBarBackground
        
        photoProgressView.progressTintColor = Generated.Color.photoProgress
        photoProgressView.trackTintColor = .clear
        
        contactsProgressView.progressTintColor = Generated.Color.contactProgress
        contactsProgressView.trackTintColor = .clear
        
        [photoContactsDivider, contactsOtherDivider].forEach { divider in
            divider.backgroundColor = Generated.Color.secondaryBackground
            divider.isHidden = true
        }
        
    }
    
}


// MARK: - Layout Setup

private extension MainSystemInfoView {
    
    func addSubviewsBefore() {
        addSubviews([deviceNameLabel, memorySizeLabel, progressView, calculatingView, contactsProgressView, photoProgressView, photoContactsDivider, contactsOtherDivider])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        deviceNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(ThisSize.is16/2)
            make.leading.equalToSuperview().offset(ThisSize.is12)
        }
        
        memorySizeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(deviceNameLabel)
            make.trailing.equalToSuperview().offset(-ThisSize.is12)
        }
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(deviceNameLabel.snp.bottom).offset(ThisSize.is16/2)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is12)
            make.height.equalTo(ThisSize.is20)
        }
        
        calculatingView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(ThisSize.is16/2)
            make.leading.equalToSuperview().offset(ThisSize.is12)
            make.bottom.equalToSuperview().offset(-ThisSize.is16/2)
        }
        
        photoProgressView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(progressView)
            make.bottom.top.equalTo(progressView)
        }
        
        contactsProgressView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(progressView)
            make.bottom.top.equalTo(progressView)
        }
        
    }
    
}


