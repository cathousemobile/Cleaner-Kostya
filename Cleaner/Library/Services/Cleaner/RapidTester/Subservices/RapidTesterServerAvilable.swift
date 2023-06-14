import Foundation

final internal class RapidTesterServerAvilable: RapidTesterEndpointProtocol {
    private let url: URL

    required init(url: URL) {
        self.url = url
    }

    convenience init() {
        self.init(url: URL(string: "https://www.speedtest.net/api/js/servers?engine=js&https_functional=true")!)
    }

    func getHosts(timeout: TimeInterval, closure: @escaping (Result<[RapidTesterServerAvilableModel], RapidTesterNetworkError>) -> ()) {
        URLSession(configuration: .default).dataTask(with: URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: timeout)) { (data, response, error) in
            if let _ = error {
                closure(.failure(RapidTesterNetworkError.requestFailed)); return
            }

            guard let response = response, response.isOk, let data = data else {
                closure(.failure(RapidTesterNetworkError.requestFailed)); return
            }

            guard response.isJSON else {
                closure(.failure(RapidTesterNetworkError.wrongContentType)); return
            }

            guard let result = try? JSONDecoder().decode([RapidTesterServerAvilableModel].self, from: data) else {
                closure(.failure(RapidTesterNetworkError.wrongJSON)); return
            }

            closure(.success(result))
        }.resume()
    }

    func getHosts(max: Int, timeout: TimeInterval, closure: @escaping (Result<[RapidTesterServerAvilableModel], RapidTesterNetworkError>) -> ()) {
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

/*
 "url": "http://test.byfly.by/speedtest/upload.php",
 "lat": "53.9000",
 "lon": "27.5667",
 "distance": 0,
 "name": "Minsk",
 "country": "Belarus",
 "cc": "BY",
 "sponsor": "MGTS",
 "id": "1119",
 "preferred": 0,
 "host": "test.byfly.by:8080"
*/

public struct RapidTesterServerAvilableModel: Codable {
    public let url: URL
    public let name: String
    public let country: String
    public let cc: String
    public let host: String
    public let sponsor: String
    public let distance: Int
}
