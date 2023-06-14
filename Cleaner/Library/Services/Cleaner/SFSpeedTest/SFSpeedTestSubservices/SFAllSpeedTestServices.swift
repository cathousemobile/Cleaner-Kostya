import Foundation

public enum SFSpeedTestError: Error {
    case networkError
    case hostNotFound
}

public final class SFAllSpeedTestServices {
    private let hostService: SFSpeedHostProtocol
    private let pingService: SFPingServiceProtocol
    private let downloadService = SFSpeedTestDownloadService()
    private let uploadService = SFSpeedTestUploadService()

    public required init(hosts: SFSpeedHostProtocol, ping: SFPingServiceProtocol) {
        self.hostService = hosts
        self.pingService = ping
    }

    public convenience init() {
        self.init(hosts: SFSpeedTestHost(), ping: SFSpeedTestPingService())
    }

    public func findHosts(timeout: TimeInterval, closure: @escaping (Result<[SFSpeedTestHostModel], SFSpeedTestError>) -> ()) {
        hostService.getHosts(timeout: timeout) { result in
            switch result {
            case .success(let hosts):
                DispatchQueue.main.async {
                    closure(.success(hosts))
                }
            case .failure(_):
                DispatchQueue.main.async {
                    closure(.failure(.networkError))
                }
            }
        }
    }

    public func findBestHost(from max: Int, timeout: TimeInterval, closure: @escaping (Result<(SFSpeedTestHostModel, Int), SFSpeedTestError>) -> ()) {
        hostService.getHosts(max: max, timeout: timeout) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(_):
                DispatchQueue.main.async {
                    closure(.failure(.networkError))
                }
            case .success(let hosts):
                strongSelf.pingAllHosts(hosts: hosts.map { $0 }, timeout: timeout) { hosts in
                    DispatchQueue.main.async {
                        closure(strongSelf.findBestPings(from: hosts))
                    }
                }
            }
        }
    }

    public func ping(host: SFSpeedTestHostModel, timeout: TimeInterval, closure: @escaping (Result<Int, SFSpeedTestError>) -> ()) {
        pingService.ping(url: host.url, timeout: timeout) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let ping):
                    closure(.success(ping))
                case .failure(_):
                    closure(.failure(.networkError))
                }
            }
        }
    }

    public func runDownloadTest(for host: URL, size: Int, timeout: TimeInterval, current: @escaping (SFSpeedModel) -> (), final: @escaping (Result<SFSpeedModel, SFSpeedTestNetworkError>) -> ()) {
        downloadService.test(host,
                             fileSize: size,
                             timeout: timeout,
                             current: { (_, avgSpeed) in
                                current(avgSpeed)
                            }, final: { result in
                                final(result)
                            })
    }

    public func runUploadTest(for host: URL, size: Int, timeout: TimeInterval, current: @escaping (SFSpeedModel) -> (), final: @escaping (Result<SFSpeedModel, SFSpeedTestNetworkError>) -> ()) {
        uploadService.test(host,
                           fileSize: size,
                           timeout: timeout,
                           current: { (_, avgSpeed) in
                            current(avgSpeed)
                        }, final: { result in
                            final(result)
                        })
    }

    private func pingAllHosts(hosts: [SFSpeedTestHostModel], timeout: TimeInterval, closure: @escaping ([(host: SFSpeedTestHostModel, ping: Int)]) -> ()) {
        let group = DispatchGroup()
        var pings = [(SFSpeedTestHostModel, Int)]()
        hosts.forEach { host in
            group.enter()
            pingService.ping(url: (URL(string: "http://\(host.host)" )!), timeout: timeout, closure: { result in
                switch result {
                case .failure(let error):
                    debugPrint(error)
                    break
                case .success(let ping):
                    pings.append((host, ping))
                }
                group.leave()
            })
        }
        group.notify(queue: DispatchQueue.global(qos: .default)) {
            closure(pings)
        }
    }

    private func findBestPings(from pings: [(host: SFSpeedTestHostModel, ping: Int)]) -> Result<(SFSpeedTestHostModel, Int), SFSpeedTestError> {
        let best = pings.min(by: { (left, right) in
            left.ping < right.ping
        })
        if let best = best {
            return .success(best)
        } else {
            return .failure(.hostNotFound)
        }
    }
}