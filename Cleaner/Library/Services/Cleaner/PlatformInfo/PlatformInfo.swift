//
//  SystemInfoManager.swift
//  Created at 06.12.2022.
//

import UIKit
import SwiftyJSON


enum PlatformInfo {
    
    /// CleanerAppsLibrary:  Основная информация об экране устройства
    enum Screen {
        
        /// CleanerAppsLibrary:  Количество пикселей на дюйм
        static var ppi: CGFloat {
            let ppi: Double = {
                switch PlatformInfoWindowSize.get() {
                case .success(let ppi):
                    return ppi
                case .unknown(let bestGuessPpi):
                    return bestGuessPpi
                }
            }()
            return CGFloat(ppi)
        }
        
        /// CleanerAppsLibrary:  Количество пикселей по вертикали
        static var vertivalPixel: CGFloat {
            let scale = UIScreen.main.scale
            return UIScreen.main.bounds.size.height * scale
        }
        
        /// CleanerAppsLibrary:  Количество пикселей по горизонтали
        static var horizontalPixel: CGFloat {
            let scale = UIScreen.main.scale
            return UIScreen.main.bounds.size.width * scale
        }
        
        /// CleanerAppsLibrary: Диагональ экрана
        static var screenInch: CGFloat {
            let horizontal = horizontalPixel / ppi
            let vertical = vertivalPixel / ppi
            
            return sqrt(pow(horizontal, 2) + pow(vertical, 2))
        }
    }
    
    /// CleanerAppsLibrary:  Основная информация об устройстве: модель, версия ОС, память, зарядка
    enum Device {
        /// CleanerAppsLibrary: Реальное название устройства (iPhone 14 Pro, iPhone 13 etc)
        static var deviceName: String? {
            PlatformInfoPhoneModel.getDeviceName()
        }
        
        /// CleanerAppsLibrary: Идентификатор устройства в системе Apple (iPhone15,3; iPhone15,2 etc)
        static var deviceID: String? {
            PlatformInfoPhoneModel.getDeviceID()
        }
        
        /// CleanerAppsLibrary: Версия iOS
        static var osVersion: String? {
            UIDevice.current.systemVersion
        }
        
        /// CleanerAppsLibrary: Размер накопителя устройства в байтах
        static var totalSpace: Int64? {
            getFileSize(for: .systemSize)
        }
        
        /// CleanerAppsLibrary: Свободная память устройства
        static var freeSpace: Int64? {
            getFileSize(for: .systemFreeSize)
        }
        
        /// CleanerAppsLibrary: Размер всей оперативной памяти на устройстве
        static var totalRAM: Int64 {
            Int64(ProcessInfo.processInfo.physicalMemory)
        }
        
        /// CleanerAppsLibrary: Размер свободной оперативной памяти на устройстве
        static var freeRAM: Int64? {
            let TASK_VM_INFO_COUNT = mach_msg_type_number_t(MemoryLayout<task_vm_info_data_t>.size / MemoryLayout<integer_t>.size)
            let TASK_VM_INFO_REV1_COUNT = mach_msg_type_number_t(MemoryLayout.offset(of: \task_vm_info_data_t.min_address)! / MemoryLayout<integer_t>.size)
            var info = task_vm_info_data_t()
            var count = TASK_VM_INFO_COUNT
            let kr = withUnsafeMutablePointer(to: &info) { infoPtr in
                infoPtr.withMemoryRebound(to: integer_t.self, capacity: Int(count)) { intPtr in
                    task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), intPtr, &count)
                }
            }
            guard kr == KERN_SUCCESS, count >= TASK_VM_INFO_REV1_COUNT else {
                return nil
            }
            
            let usedBytes = Int64(info.phys_footprint)
            return usedBytes
        }
       
        /// CleanerAppsLibrary: Время с последнего перезапуска устройства в секундах
        static var systemUptime: TimeInterval {
            ProcessInfo.processInfo.systemUptime
        }
        
        /// CleanerAppsLibrary: Процент заряда аккумулятора
        static var chargePercent: Int {
            UIDevice.current.isBatteryMonitoringEnabled = true
            let device = UIDevice.current
            let currentBatteryLevel = device.batteryLevel
            let currentBatteryLevelInPercent = currentBatteryLevel * 100
            return Int(currentBatteryLevelInPercent)
        }
        
        /// CleanerAppsLibrary: Заряжается ли сейчас устройство
        static var isCharging: Bool {
            switch UIDevice.current.batteryState {
            case .unknown:
                return false
            case .unplugged:
                return false
            case .charging:
                return true
            case .full:
                return false
            @unknown default:
                return false
            }
        }
        
        /// CleanerAppsLibrary: Включен ли режим энергосбережения
        static var isLowPowerModeEnabled: Bool {
            ProcessInfo.processInfo.isLowPowerModeEnabled
        }
        
        private static func getFileSize(for key: FileAttributeKey) -> Int64? {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)

            guard
                let lastPath = paths.last,
                let attributeDictionary = try? FileManager.default.attributesOfFileSystem(forPath: lastPath) else { return nil }

            if let size = attributeDictionary[key] as? NSNumber {
                return size.int64Value
            } else {
                return nil
            }
        }
    }
    
    /// CleanerAppsLibrary:  Основная информация по ip адресу
    enum Network {
        struct Info {
            
            /// IP адрес
            let ip: String
            
            /// Провайдер (только англ. яз.)
            let isp: String?
            
            /// Страна, берется по IP (только англ. яз.)
            let country: String?
            
            /// Город, берется по IP (только англ. яз.)
            let city: String?
            
            /// Часовой пояс, берется по городу (только англ. яз.)
            let timezone: String?
        }
        
        /// Запросить информацию о сети
        static func get(completion: @escaping ((Info?) -> Void)) {
            guard let url = URL(string: "http://ip-api.com/json") else { return }
            var urlRequest = addHeaders(to: url)
            urlRequest.httpMethod = "GET"
            request(with: urlRequest) { result in
                switch result {
                case .success (let data):
                    let jsonData = JSON(data)
                    guard let ip = jsonData["query"].string else {
                        completion(nil)
                        return
                    }
                    let isp = jsonData["isp"].string
                    let country = jsonData["country"].string
                    let city = jsonData["city"].string
                    let timezone = jsonData["timezone"].string
                    completion(.init(ip: ip, isp: isp, country: country, city: city, timezone: timezone))
                case .failure(let error):
                    print("Failed get currency symbols", error.localizedDescription)
                    completion(nil)
                }
            }.resume()
        }
        
        // MARK: - Private Methods
        private static func request(with url: URL, result: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
            return URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    result(.failure(error))
                    return
                }
                guard let data = data else {
                    let error = NSError(domain: "Error", code: 0, userInfo: nil)
                    result(.failure(error))
                    return
                }
                result(.success(data))
            }
        }
        
        private static func request(with urlRequest: URLRequest, result: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
            return URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                if let error = error {
                    result(.failure(error))
                    return
                }
                guard let data = data else {
                    let error = NSError(domain: "Error", code: 0, userInfo: nil)
                    result(.failure(error))
                    return
                }
                result(.success(data))
            }
        }
        
        private static func addHeaders(to url: URL) -> URLRequest {
            var urlRequest = URLRequest(url: url)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            return urlRequest
        }
    }
}
