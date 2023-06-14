import Foundation

extension URL {
    func ping(timeout: TimeInterval, closure: @escaping (Result<Int, RapidTesterNetworkError>) -> ()) {
        let startTime = Date()
        URLSession(configuration: .default).dataTask(with: URLRequest(url: self, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: timeout)) { (data, response, error) in
            let value = startTime.timeIntervalSinceNow

            if let _ = error {
                closure(.failure(RapidTesterNetworkError.requestFailed)); return
            }
            guard let response = response, response.isOk else {
                closure(.failure(RapidTesterNetworkError.requestFailed)); return
            }

            let pingms = (fmod(-value, 1) * 1000)
            closure(.success(Int(pingms)))
        }.resume()
    }
}

