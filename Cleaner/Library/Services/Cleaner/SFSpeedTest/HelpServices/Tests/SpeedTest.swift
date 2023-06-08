import Foundation

public enum SpeedTestError: Error {
    case networkError
    case hostNotFound
}

public final class SpeedTest {
    private let hostService: HostsProviderService
    private let pingService: HostPingService
    private let downloadService = CustomHostDownloadService()
    private let uploadService = CustomHostUploadService()

    public required init(hosts: HostsProviderService, ping: HostPingService) {
        self.hostService = hosts
        self.pingService = ping
    }

    public convenience init() {
        self.init(hosts: SpeedTestService(), ping: DefaultHostPingService())
    }

    public func findHosts(timeout: TimeInterval, closure: @escaping (Result<[SpeedTestHost], SpeedTestError>) -> ()) {
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

    public func findBestHost(from max: Int, timeout: TimeInterval, closure: @escaping (Result<(SpeedTestHost, Int), SpeedTestError>) -> ()) {
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

    public func ping(host: SpeedTestHost, timeout: TimeInterval, closure: @escaping (Result<Int, SpeedTestError>) -> ()) {
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

    public func runDownloadTest(for host: URL, size: Int, timeout: TimeInterval, current: @escaping (Speed) -> (), final: @escaping (Result<Speed, NetworkError>) -> ()) {
        downloadService.test(host,
                             fileSize: size,
                             timeout: timeout,
                             current: { (_, avgSpeed) in
                                current(avgSpeed)
                            }, final: { result in
                                final(result)
                            })
    }

    public func runUploadTest(for host: URL, size: Int, timeout: TimeInterval, current: @escaping (Speed) -> (), final: @escaping (Result<Speed, NetworkError>) -> ()) {
        uploadService.test(host,
                           fileSize: size,
                           timeout: timeout,
                           current: { (_, avgSpeed) in
                            current(avgSpeed)
                        }, final: { result in
                            final(result)
                        })
    }

    private func pingAllHosts(hosts: [SpeedTestHost], timeout: TimeInterval, closure: @escaping ([(host: SpeedTestHost, ping: Int)]) -> ()) {
        let group = DispatchGroup()
        var pings = [(SpeedTestHost, Int)]()
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

    private func findBestPings(from pings: [(host: SpeedTestHost, ping: Int)]) -> Result<(SpeedTestHost, Int), SpeedTestError> {
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
