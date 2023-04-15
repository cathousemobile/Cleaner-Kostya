//
//  SensorView.swift
//

import UIKit

final class SensorView: UIView {
    
    private typealias Text = Generated.Text.Sensor
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var orientationListView = SystemInfoDetailStackView()
    private lazy var accelerationListView = SystemInfoDetailStackView()
    private lazy var magneticListView = SystemInfoDetailStackView()
    private lazy var barometerListView = SystemInfoDetailStackView()
    
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
    
}

// MARK: - Public Methods

extension SensorView {
    
    func setInfoInCellById(_ stack: SystemInfoSensorModel, id: String, info: String) {
        
        switch stack {
            
        case .orientation:
            orientationListView.setInfoInCellById(id, info: info)
        case .acceleration:
            accelerationListView.setInfoInCellById(id, info: info)
        case .magnetic:
            magneticListView.setInfoInCellById(id, info: info)
        case .barometer:
            barometerListView.setInfoInCellById(id, info: info)
        }
        
    }
    
    func addCellToOrientationList(_ cell: SystemInfoDetailCell) {
        orientationListView.addCellToStack(cell)
    }
    
    func addCellToAccelerationList(_ cell: SystemInfoDetailCell) {
        accelerationListView.addCellToStack(cell)
    }
    
    func addCellToMagneticList(_ cell: SystemInfoDetailCell) {
        magneticListView.addCellToStack(cell)
    }
    
    func addCellToBarometerList(_ cell: SystemInfoDetailCell) {
        barometerListView.addCellToStack(cell)
    }
    
}

// MARK: - Private Methods

private extension SensorView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension SensorView {
    
    func configureView() {
        backgroundColor = Generated.Color.mainBackground
    }
    
    func configureSubviews() {
        orientationListView.setTitleText(Text.orientationTitle)
        accelerationListView.setTitleText(Text.accelerationTitle)
        magneticListView.setTitleText(Text.magneticTitle)
        barometerListView.setTitleText(Text.barometer)
    }
    
}


// MARK: - Layout Setup

private extension SensorView {
    
    func addSubviewsBefore() {
        insideScrollView.addSubviews([orientationListView, accelerationListView, magneticListView, barometerListView])
        scrollView.addSubview(insideScrollView)
        addSubview(scrollView)
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        insideScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(ThisSize.is48)
            make.leading.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        orientationListView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        accelerationListView.snp.makeConstraints { make in
            make.top.equalTo(orientationListView.snp.bottom).offset(ThisSize.is28)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        magneticListView.snp.makeConstraints { make in
            make.top.equalTo(accelerationListView.snp.bottom).offset(ThisSize.is28)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        barometerListView.snp.makeConstraints { make in
            make.top.equalTo(magneticListView.snp.bottom).offset(ThisSize.is28)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
    }
    
}



