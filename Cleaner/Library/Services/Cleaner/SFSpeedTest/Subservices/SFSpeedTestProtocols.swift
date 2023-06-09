import Foundation

public enum SFSpeedTestNetworkError: Error {
    case requestFailed
    case wrongContentType
    case wrongJSON
}

public protocol SFSpeedHostProtocol {
    func getHosts(timeout: TimeInterval, closure: @escaping (Result<[SFSpeedTestHostModel], SFSpeedTestNetworkError>) -> ())
    func getHosts(max: Int, timeout: TimeInterval, closure: @escaping (Result<[SFSpeedTestHostModel], SFSpeedTestNetworkError>) -> ())
}

public protocol SFPingServiceProtocol {
    func ping(url: URL, timeout: TimeInterval, closure: @escaping (Result<Int, SFSpeedTestNetworkError>) -> ())
}

protocol SFSpeedServiceProtocol {
    func test(_ url: URL, fileSize: Int, timeout: TimeInterval, current: @escaping (SFSpeedModel, SFSpeedModel) -> (), final: @escaping (Result<SFSpeedModel, SFSpeedTestNetworkError>) -> ())
}

extension SFSpeedServiceProtocol {
    func calculate(bytes: Int64, seconds: TimeInterval) -> SFSpeedModel {
        return SFSpeedModel(bytes: bytes, seconds: seconds).pretty
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
