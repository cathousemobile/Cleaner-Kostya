import Foundation

class SFSpeedTestPingService: SFPingServiceProtocol {
    func ping(url: URL, timeout: TimeInterval, closure: @escaping (Result<Int, SFSpeedTestNetworkError>) -> ()) {
        url.ping(timeout: timeout, closure: closure)
    }
}
