//
//  SensorViewController.swift
//

import UIKit
import Motions

final class SensorViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let contentView = SensorView()
    private let accelerometer = Accelerometer(frequency: .init(2, .hertz))
    private let gyrometer = Gyrometer(frequency: .init(2, .hertz))
    private let magnetometer = Magnetometer(frequency: .init(2, .hertz))
    
    // MARK: - Public Proporties
    
    // MARK: - Private Proporties
    
    private let altimeter = CMAltimeter()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        runStreams()
        runBarometer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopStreams()
        altimeter.stopRelativeAltitudeUpdates()
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
    
    func runAccelerometer() async {
        do {
            let stream: AsyncStream<Point> = try accelerometer.subscribe()
            for await data in stream {
                contentView.setInfoInCellById(.acceleration, id: Generated.Text.Sensor.xAxis, info: String(format: "%.2f", data.x))
                contentView.setInfoInCellById(.acceleration, id: Generated.Text.Sensor.yAxis, info: String(format: "%.2f", data.y))
                contentView.setInfoInCellById(.acceleration, id: Generated.Text.Sensor.zAxis, info: String(format: "%.2f", data.z))
            }
        } catch let error {
            // Do something with the error.
            print("Here: ", error)
        }
    }
    
    func runGyrometer() async {
        do {
            let stream: AsyncStream<Point> = try gyrometer.subscribe()
            for await data in stream {
                contentView.setInfoInCellById(.orientation, id: Generated.Text.Sensor.roll, info: String(format: "%.2f", data.x))
                contentView.setInfoInCellById(.orientation, id: Generated.Text.Sensor.pitch, info: String(format: "%.2f", data.y))
                contentView.setInfoInCellById(.orientation, id: Generated.Text.Sensor.yaw, info: String(format: "%.2f", data.z))
            }
        } catch let error {
            // Do something with the error.
            print("Here: ", error)
        }
    }
    
    func runMagnometer() async {
        do {
            let stream: AsyncStream<Point> = try magnetometer.subscribe()
            for await data in stream {
                contentView.setInfoInCellById(.magnetic, id: Generated.Text.Sensor.xAxis, info: String(format: "%.2f", data.x))
                contentView.setInfoInCellById(.magnetic, id: Generated.Text.Sensor.yAxis, info: String(format: "%.2f", data.y))
                contentView.setInfoInCellById(.magnetic, id: Generated.Text.Sensor.zAxis, info: String(format: "%.2f", data.z))
                
            }
        } catch let error {
            // Do something with the error.
            print("Here: ", error)
        }
    }
    
    func runBarometer() {
        
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: .main) { [weak self] data, error in
                guard let self = self else { return }
                self.contentView.setInfoInCellById(.barometer, id: Generated.Text.Sensor.pressure, info: String(format: "%.2f hPA", (data?.pressure.floatValue)!*10))
            }
            
        }
        
    }
    
    func runStreams() {
        
        Task {
            await runAccelerometer()
        }
        
        Task {
            await runGyrometer()
        }
        
        Task {
            await runMagnometer()
        }
        
    }
    
    func stopStreams() {
        gyrometer.unsubscribe()
        accelerometer.unsubscribe()
        magnetometer.unsubscribe()
    }
    
    func setupActions() {
        
    }
    
    func initStacks() {
        
        for orientation in SystemInfoSensorModel.Orientation.allCases {
            let cell = SystemInfoDetailCell(id: orientation.titleText)
            cell.setTitleText(orientation.titleText)
            contentView.addCellToOrientationList(cell)
        }
        
        for coordinate in SystemInfoSensorModel.Coordinate.allCases {
            let cell = SystemInfoDetailCell(id: coordinate.titleText)
            cell.setTitleText(coordinate.titleText)
            contentView.addCellToAccelerationList(cell)
        }
        
        for coordinate in SystemInfoSensorModel.Coordinate.allCases {
            let cell = SystemInfoDetailCell(id: coordinate.titleText)
            cell.setTitleText(coordinate.titleText)
            contentView.addCellToMagneticList(cell)
        }
        
        for barometer in SystemInfoSensorModel.Barometer.allCases {
            let cell = SystemInfoDetailCell(id: barometer.titleText)
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

