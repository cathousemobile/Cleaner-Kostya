import Foundation

public enum SpeedTestChecker {
    
    // MARK: - Public Properties
    
    /// Обновлен текущий хост
    public static var hostUpdated: ((SpeedTestHost) -> Void)?
    
    /// Обновлен пинг
    public static var pingUpdated: ((Int) -> Void)?
    
    /// Обновлена скорость загрузки
    public static var downloadSpeedUpdated: ((Speed) -> Void)?
    
    /// Обновлена скорость выгрузки
    public static var uploadSpeedUpdated: ((Speed) -> Void)?
    
    // MARK: - Private Properties
    
    public static var isTesting: Bool = false
    private static var filterLimitSpeed: Double = 5000
    
    // MARK: - Public Methods
    
    /// Последовательный запуск всех тестов (хост, пинг, скорость загрузки, скорость выгрузки)
    public static func startFullTest(pauseBetweenTest: (() -> Void)? = nil, completion: @escaping () -> Void) {
        resetData()
        findHost { _ in
            checkPing { _ in
                checkDownloadSpeed { _ in
                    pauseBetweenTest?()
                    Waiter.wait(1) {
                        checkUploadSpeed { _ in
                            Waiter.wait(1) {
                                completion()
                            }
                        }
                    }
                }
            }
        }
    }

    /// Найти ближайший хост для тестирования
    /// - Parameter completion: Колбэк, сообщающий что хост найден
    public static func findHost(completion: @escaping (SpeedTestHost) -> Void) {
        isTesting = true
        SpeedTestCustomService.shared.findBestHostForTest { host in
            isTesting = false
            Logger.log(.debug, logItem: "Host", host)
            hostUpdated?(host)
            completion(host)
        } error: { error in
            isTesting = false
            Logger.log(.error, logItem: #function, error)
        }
    }
    
    /// Проверить пинг
    /// - Parameter completion: Колбэк, сообщающий результаты теста
    public static func checkPing(completion: @escaping (Int) -> Void) {
        isTesting = true
        SpeedTestCustomService.shared.makePingTest { ping in
            DispatchQueue.main.async {
                isTesting = false
                pingUpdated?(ping); Logger.log(.debug, logItem: "Ping", ping)
                completion(ping)
            }
        } error: { error in
            isTesting = false
            Logger.log(.error, logItem: #function, error)
        }
    }

    /// Проверить скорость загрузки
    /// - Parameter completion: Колбэк, сообщающий результаты теста
    public static func checkDownloadSpeed(completion: @escaping (Speed?) -> Void) {
        isTesting = true
        SpeedTestCustomService.shared.makeDownloadTestWithHost(currentSpeed: nil) { avgSpeed in
            Logger.log(.debug, logItem: "Download: avgSpeed", avgSpeed)
            if avgSpeed.speedInMbps < filterLimitSpeed {
                downloadSpeedUpdated?(avgSpeed)
            }
        } testResult: { resultSpeed, _ in
            isTesting = false
            if let speed = resultSpeed, speed.speedInMbps < filterLimitSpeed {
                downloadSpeedUpdated?(speed)
                Logger.log(.debug, logItem: "Download result:", speed)
            }
            completion(resultSpeed)
        }
    }
    
    /// Проверить скорость выгрузки
    /// - Parameter completion: Колбэк, сообщающий результаты теста
    public static func checkUploadSpeed(completion: @escaping (Speed?) -> Void) {
        isTesting = true
        SpeedTestCustomService.shared.makeUploadTestWithHost(currentSpeed: nil) { avgSpeed in
            Logger.log(.debug, logItem: "Upload: avgSpeed", avgSpeed)
            if avgSpeed.speedInMbps < filterLimitSpeed {
                uploadSpeedUpdated?(avgSpeed)
            }
        } testResult: { resultSpeed, _ in
            isTesting = false
            if let speed = resultSpeed, speed.speedInMbps < filterLimitSpeed {
                uploadSpeedUpdated?(speed)
                Logger.log(.debug, logItem: "Upload result:", speed)
            }
            completion(resultSpeed)
        }
    }

    /// Подготовка r повторному тестированию, сброс мусорных данных с предыдущего тестирования
    public static func resetData() {
        SpeedTestCustomService.shared.resetData()
    }
    
    public static func stop() {
        SpeedTestCustomService.shared.stop()
    }
}
