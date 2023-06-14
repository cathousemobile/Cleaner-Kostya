import Foundation

public enum RapidTesterError: Error {
    case networkError
    case hostNotFound
}

public final class RapidTesterClientAPI {
    private let hostService: RapidTesterEndpointProtocol
    private let pingService: RapidTesterPingProtocol
    private let downloadService = RapidTesterRecivePacket()
    private let uploadService = RapidTesterSendPacket()

    public required init(hosts: RapidTesterEndpointProtocol, ping: RapidTesterPingProtocol) {
        self.hostService = hosts
        self.pingService = ping
    }

    public convenience init() {
        self.init(hosts: RapidTesterServerAvilable(), ping: RapidTesterPingService())
    }

    public func findHosts(timeout: TimeInterval, closure: @escaping (Result<[RapidTesterServerAvilableModel], RapidTesterError>) -> ()) {
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

    public func findBestHost(from max: Int, timeout: TimeInterval, closure: @escaping (Result<(RapidTesterServerAvilableModel, Int), RapidTesterError>) -> ()) {
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

    public func ping(host: RapidTesterServerAvilableModel, timeout: TimeInterval, closure: @escaping (Result<Int, RapidTesterError>) -> ()) {
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

    public func runDownloadTest(for host: URL, size: Int, timeout: TimeInterval, current: @escaping (RapidTesterInfo) -> (), final: @escaping (Result<RapidTesterInfo, RapidTesterNetworkError>) -> ()) {
        downloadService.test(host,
                             fileSize: size,
                             timeout: timeout,
                             current: { (_, avgSpeed) in
                                current(avgSpeed)
                            }, final: { result in
                                final(result)
                            })
    }

    public func runUploadTest(for host: URL, size: Int, timeout: TimeInterval, current: @escaping (RapidTesterInfo) -> (), final: @escaping (Result<RapidTesterInfo, RapidTesterNetworkError>) -> ()) {
        uploadService.test(host,
                           fileSize: size,
                           timeout: timeout,
                           current: { (_, avgSpeed) in
                            current(avgSpeed)
                        }, final: { result in
                            final(result)
                        })
    }

    private func pingAllHosts(hosts: [RapidTesterServerAvilableModel], timeout: TimeInterval, closure: @escaping ([(host: RapidTesterServerAvilableModel, ping: Int)]) -> ()) {
        let group = DispatchGroup()
        var pings = [(RapidTesterServerAvilableModel, Int)]()
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

    private func findBestPings(from pings: [(host: RapidTesterServerAvilableModel, ping: Int)]) -> Result<(RapidTesterServerAvilableModel, Int), RapidTesterError> {
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
