import Foundation

public enum SFSpeedTest {
    
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        checkUploadSpeed { _ in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
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
            hostUpdated?(host)
            completion(host)
        } error: { error in
            isTesting = false
        }
    }
    
    /// Проверить пинг
    /// - Parameter completion: Колбэк, сообщающий результаты теста
    public static func checkPing(completion: @escaping (Int) -> Void) {
        isTesting = true
        SpeedTestCustomService.shared.makePingTest { ping in
            DispatchQueue.main.async {
                isTesting = false
                pingUpdated?(ping);
                completion(ping)
            }
        } error: { error in
            isTesting = false
        }
    }

    /// Проверить скорость загрузки
    /// - Parameter completion: Колбэк, сообщающий результаты теста
    public static func checkDownloadSpeed(completion: @escaping (Speed?) -> Void) {
        isTesting = true
        SpeedTestCustomService.shared.makeDownloadTestWithHost(currentSpeed: nil) { avgSpeed in
            if avgSpeed.speedInMbps < filterLimitSpeed {
                downloadSpeedUpdated?(avgSpeed)
            }
        } testResult: { resultSpeed, _ in
            isTesting = false
            if let speed = resultSpeed, speed.speedInMbps < filterLimitSpeed {
                downloadSpeedUpdated?(speed)
            }
            completion(resultSpeed)
        }
    }
    
    /// Проверить скорость выгрузки
    /// - Parameter completion: Колбэк, сообщающий результаты теста
    public static func checkUploadSpeed(completion: @escaping (Speed?) -> Void) {
        isTesting = true
        SpeedTestCustomService.shared.makeUploadTestWithHost(currentSpeed: nil) { avgSpeed in
            if avgSpeed.speedInMbps < filterLimitSpeed {
                uploadSpeedUpdated?(avgSpeed)
            }
        } testResult: { resultSpeed, _ in
            isTesting = false
            if let speed = resultSpeed, speed.speedInMbps < filterLimitSpeed {
                uploadSpeedUpdated?(speed)
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
