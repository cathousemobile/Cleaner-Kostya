//
//  SensorViewController.swift
//

import UIKit

final class SensorViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let contentView = SensorView()
    
    // MARK: - Public Proporties
    
    // MARK: - Private Proporties
    
    // MARK: - Life cycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Generated.Text.SystemInfo.sensorTitle
        setupActions()
        initStacks()
    }
    
}

// MARK: - Handlers

private extension SensorViewController {
    
}

// MARK: - Public Methods

extension SensorViewController {
    
}

// MARK: - Private Methods

private extension SensorViewController {
    
    func setupActions() {
        
    }
    
    func initStacks() {
        
        for orientation in SystemInfoSensorModel.Orientation.allCases {
            let cell = SystemInfoDetailCell(id: orientation.rawValue)
            cell.setTitleText(orientation.titleText)
            contentView.addCellToOrientationList(cell)
        }
        
        for coordinate in SystemInfoSensorModel.Coordinate.allCases {
            let cell = SystemInfoDetailCell(id: coordinate.rawValue)
            cell.setTitleText(coordinate.titleText)
            contentView.addCellToAccelerationList(cell)
        }
        
        for coordinate in SystemInfoSensorModel.Coordinate.allCases {
            let cell = SystemInfoDetailCell(id: coordinate.rawValue)
            cell.setTitleText(coordinate.titleText)
            contentView.addCellToMagneticList(cell)
        }
        
        for barometer in SystemInfoSensorModel.Barometer.allCases {
            let cell = SystemInfoDetailCell(id: barometer.rawValue)
            cell.setTitleText(barometer.titleText)
            contentView.addCellToBarometerList(cell)
        }
        
    }
    
}

// MARK: - Navigation

private extension SensorViewController {
    
}

// MARK: - Layout Setup

private extension SensorViewController {
    
}

