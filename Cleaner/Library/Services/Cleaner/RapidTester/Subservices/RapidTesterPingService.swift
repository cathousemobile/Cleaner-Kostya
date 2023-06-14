import Foundation

class RapidTesterPingService: RapidTesterPingProtocol {
    func ping(url: URL, timeout: TimeInterval, closure: @escaping (Result<Int, RapidTesterNetworkError>) -> ()) {
        url.ping(timeout: timeout, closure: closure)
    }
}
