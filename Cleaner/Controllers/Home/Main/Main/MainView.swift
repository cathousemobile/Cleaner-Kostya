//
//  MainView.swift
//

import Foundation
import UIKit

final class MainView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var titleLabel = UILabel()
    private lazy var systemTitleLabel = UILabel()
    private lazy var optionsTitleLabel = UILabel()
    
    private lazy var systemInfoView = MainSystemInfoView()
    
    private lazy var cleaningButton = CustomButtonView()
    
    private lazy var optionsListView = UIStackView()
    
    private lazy var scrollView = UIScrollView()
    private lazy var insideScrollView = UIView()
    
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
        optionsListView.layer.cornerRadius = 12
        optionsListView.clipsToBounds = true
    }
    
}

// MARK: - Public Methods

extension MainView {
    
    func setCleaningButonAction(_ action: @escaping EmptyBlock) {
        cleaningButton.setAction(action)
    }
    
    func addToOptionsList(_ optionsView: MainOptionsCell) {
        optionsListView.addArrangedSubview(optionsView)
    }
    
    func calculatingIsFinished(_ isFinished: Bool) {
        systemInfoView.calculatingIsFinished(isFinished)
    }
    
    func setProgress(progress: Float, photoProgress: Float, contactsProgress: Float) {
        systemInfoView.setProgress(progress: progress, photoProgress: photoProgress, contactsProgress: contactsProgress)
    }
    
    func setMemorySpaces(_ totalSpace: String, useSpace: String) {
        systemInfoView.setMemorySpaces(totalSpace, useSpace: useSpace)
    }
    
    func setDeviceName(_ deviceName: String) {
        systemInfoView.setDeviceName(deviceName)
    }
    
}

// MARK: - Private Methods

private extension MainView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension MainView {
    
    func configureView() {
        backgroundColor = Generated.Color.mainBackground
    }
    
    func configureSubviews() {
        
        titleLabel.do {
            $0.text = Generated.Text.Main.home
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 34, weight: .bold)
        }
        
        [systemTitleLabel, optionsTitleLabel].forEach { label in
            label.do {
                $0.textColor = Generated.Color.primaryText
                $0.font = .systemFont(ofSize: 22, weight: .bold)
            }
        }
        
        optionsTitleLabel.text = Generated.Text.Main.moreOptions
        systemTitleLabel.text = Generated.Text.Main.systemInfo
        
        cleaningButton.setTitle(text: Generated.Text.Main.smartCleaning)
        
        optionsListView.axis = .vertical
        
    }
    
}


// MARK: - Layout Setup

private extension MainView {
    
    func addSubviewsBefore() {
        insideScrollView.addSubviews([titleLabel, systemTitleLabel, cleaningButton, optionsTitleLabel, systemInfoView, optionsListView])
        scrollView.addSubview(insideScrollView)
        addSubview(scrollView)
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        insideScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(ThisSize.is48)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-ThisSize.is20)
            make.width.equalTo(scrollView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(ThisSize.is16)
            make.trailing.equalToSuperview()
        }
        
        systemTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(ThisSize.is32)
            make.leading.equalToSuperview().offset(ThisSize.is16)
            make.trailing.equalToSuperview()
        }
        
        systemInfoView.snp.makeConstraints { make in
            make.top.equalTo(systemTitleLabel.snp.bottom).offset(ThisSize.is32)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        cleaningButton.snp.makeConstraints { make in
            make.top.equalTo(systemInfoView.snp.bottom).offset(ThisSize.is12)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        optionsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(cleaningButton.snp.bottom).offset(ThisSize.is36)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        optionsListView.snp.makeConstraints { make in
            make.top.equalTo(optionsTitleLabel.snp.bottom).offset(ThisSize.is16)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
            make.bottom.equalToSuperview()
        }
        
    }
    
}


