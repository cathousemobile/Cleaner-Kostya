//
//  SmartCleaningView.swift
//

import UIKit

final class SmartCleaningView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var systemInfoView = MainSystemInfoView()
    
    private lazy var listViewTitleLabel = UILabel()
    
    private lazy var listView = UIStackView()
    
    private lazy var cleaningButton = CustomButtonView()
    
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
        listView.layer.cornerRadius = 12
        listView.clipsToBounds = true
    }
    
}

// MARK: - Public Methods

extension SmartCleaningView {
    
    func hideSpinViewInAllGalleryCells(_ isHiden: Bool) {
        listView.arrangedSubviews.compactMap({$0 as? SmartCleaningCell}).filter( {$0.id != SmartCleaningModel.duplicateContacts.titleText} ).forEach({$0.hideSpiner(isHiden)})
    }
    
    func hideSpinViewInContactCell(_ isHiden: Bool) {
        listView.arrangedSubviews.compactMap({$0 as? SmartCleaningCell}).filter( {$0.id == SmartCleaningModel.duplicateContacts.titleText} ).first?.hideSpiner(isHiden)
    }
    
    func addToInfoList(_ cell: SmartCleaningCell) {
        listView.addArrangedSubview(cell)
    }
    
    func getCellById(_ id: String) -> SmartCleaningCell? {
        listView.arrangedSubviews.compactMap({$0 as? SmartCleaningCell}).filter( {$0.id == id}).first
    }
    
    func calculatingIsFinished(_ isFinished: Bool) {
        systemInfoView.calculatingIsFinished(isFinished)
    }
    
    func setProgress(progress: Float, photoProgress: Float, contactsProgress: Float) {
        systemInfoView.setProgress(progress: progress, photoProgress: photoProgress, contactsProgress: contactsProgress)
    }
    
    func setCleaningButtonAction(_ action: @escaping EmptyBlock) {
        cleaningButton.setAction(action)
    }
    
    func changeCleaningButtonState(_ isLocked: Bool) {
        cleaningButton.shouldBeLocked(isLocked)
    }
    
    func setMemorySpaces(_ totalSpace: String, useSpace: String) {
        systemInfoView.setMemorySpaces(totalSpace, useSpace: useSpace)
    }
    
    func setDeviceName(_ deviceName: String) {
        systemInfoView.setDeviceName(deviceName)
    }
    
}

// MARK: - Private Methods

private extension SmartCleaningView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension SmartCleaningView {
    
    func configureView() {
        backgroundColor = Generated.Color.mainBackground
    }
    
    func configureSubviews() {
        
        listViewTitleLabel.do {
            $0.text = Generated.Text.SmartCleaning.cleanupTitle
            $0.textColor = Generated.Color.secondaryText
            $0.font = .systemFont(ofSize: 12, weight: .regular)
        }
        
        cleaningButton.setTitle(text: Generated.Text.Main.smartCleaning)
        
        listView.axis = .vertical
    }
    
}


// MARK: - Layout Setup

private extension SmartCleaningView {
    
    func addSubviewsBefore() {
        addSubviews([systemInfoView, listViewTitleLabel, listView, cleaningButton])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        systemInfoView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(ThisSize.is48)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        listViewTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(systemInfoView.snp.bottom).offset(ThisSize.is24)
            make.leading.equalToSuperview().offset(ThisSize.is32)
        }
        
        listView.snp.makeConstraints { make in
            make.top.equalTo(listViewTitleLabel.snp.bottom).offset(ThisSize.is16/2)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
            make.bottom.lessThanOrEqualTo(cleaningButton.snp.top)
        }
        
        cleaningButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-ThisSize.is12)
        }
        
    }
    
}


