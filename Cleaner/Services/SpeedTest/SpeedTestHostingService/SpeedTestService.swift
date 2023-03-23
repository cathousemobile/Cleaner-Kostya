import Foundation

final internal class SpeedTestService: HostsProviderService {
    private let url: URL

    required init(url: URL) {
        self.url = url
    }

    convenience init() {
        self.init(url: URL(string: "https://www.speedtest.net/api/js/servers?engine=js&https_functional=true")!)
    }

    func getHosts(timeout: TimeInterval, closure: @escaping (Result<[SpeedTestHost], NetworkError>) -> ()) {
        URLSession(configuration: .default).dataTask(with: URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: timeout)) { (data, response, error) in
            if let _ = error {
                closure(.failure(NetworkError.requestFailed)); return
            }

            guard let response = response, response.isOk, let data = data else {
                closure(.failure(NetworkError.requestFailed)); return
            }

            guard response.isJSON else {
                closure(.failure(NetworkError.wrongContentType)); return
            }

            guard let result = try? JSONDecoder().decode([SpeedTestHost].self, from: data) else {
                closure(.failure(NetworkError.wrongJSON)); return
            }

            closure(.success(result))
        }.resume()
    }

    func getHosts(max: Int, timeout: TimeInterval, closure: @escaping (Result<[SpeedTestHost], NetworkError>) -> ()) {
        getHosts(timeout: timeout) { result in
            switch result {
            case .success(let hosts):
                closure(.success(Array(hosts.prefix(max))))
                break
            case .failure(let error):
                closure(.failure(error))
            }
        }
    }
}
