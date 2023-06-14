import Foundation

public enum RapidTesterNetworkError: Error {
    case requestFailed
    case wrongContentType
    case wrongJSON
}

public protocol RapidTesterEndpointProtocol {
    func getHosts(timeout: TimeInterval, closure: @escaping (Result<[RapidTesterServerAvilableModel], RapidTesterNetworkError>) -> ())
    func getHosts(max: Int, timeout: TimeInterval, closure: @escaping (Result<[RapidTesterServerAvilableModel], RapidTesterNetworkError>) -> ())
}

public protocol RapidTesterPingProtocol {
    func ping(url: URL, timeout: TimeInterval, closure: @escaping (Result<Int, RapidTesterNetworkError>) -> ())
}

protocol RapidTesterTestProtocol {
    func test(_ url: URL, fileSize: Int, timeout: TimeInterval, current: @escaping (RapidTesterInfo, RapidTesterInfo) -> (), final: @escaping (Result<RapidTesterInfo, RapidTesterNetworkError>) -> ())
}

extension RapidTesterTestProtocol {
    func calculate(bytes: Int64, seconds: TimeInterval) -> RapidTesterInfo {
        return RapidTesterInfo(bytes: bytes, seconds: seconds).pretty
    }

    func sessionConfiguration(timeout: TimeInterval) -> URLSessionConfiguration {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = timeout
        sessionConfig.timeoutIntervalForResource = timeout
        sessionConfig.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        sessionConfig.urlCache = nil
        return sessionConfig
    }
}
