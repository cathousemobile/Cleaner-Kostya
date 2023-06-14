import Foundation

class SFSpeedTestUploadService: NSObject, SFSpeedServiceProtocol {
    private var responseDate: Date?
    private var latestDate: Date?
    private var current: ((SFSpeedModel, SFSpeedModel) -> ())!
    private var final: ((Result<SFSpeedModel, SFSpeedTestNetworkError>) -> ())!
    private var session: URLSession?
    private var task: URLSessionUploadTask?
    private var isStoped = false

    func test(_ url: URL, fileSize: Int, timeout: TimeInterval, current: @escaping (SFSpeedModel, SFSpeedModel) -> (), final: @escaping (Result<SFSpeedModel, SFSpeedTestNetworkError>) -> ()) {
        self.current = current
        self.final = final
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = timeout
        request.allHTTPHeaderFields = ["Content-Type": "application/octet-stream",
                                       "Accept-Encoding": "gzip, deflate",
                                       "Content-Length": "\(fileSize)",
                                       "Connection": "keep-alive"]
        
        session = URLSession(configuration: sessionConfiguration(timeout: timeout), delegate: self, delegateQueue: OperationQueue.main)
        task = session?.uploadTask(with: request, from: Data(count: fileSize))
        task?.resume()
    }
    
    func stop() {
        isStoped = true
    }
    
}

extension SFSpeedTestUploadService: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
        let result = calculate(bytes: dataTask.countOfBytesSent, seconds: Date().timeIntervalSince(self.responseDate!))
        DispatchQueue.main.async {
            self.final(.success(result))
        }
        completionHandler(.cancel)
    }
}

extension SFSpeedTestUploadService: URLSessionTaskDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        guard let startDate = responseDate, let latesDate = latestDate else {
            responseDate = Date();
            latestDate = responseDate
            return
        }
        
        if self.isStoped {
            session.invalidateAndCancel()
            return
        }
        
        let currentTime = Date()
        let timeSpend = currentTime.timeIntervalSince(latesDate)

        let current = calculate(bytes: bytesSent, seconds: timeSpend)
        let average = calculate(bytes: totalBytesSent, seconds: -startDate.timeIntervalSinceNow)

        latestDate = currentTime

        DispatchQueue.main.async {
            self.current(current, average)
        }
    }

    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        DispatchQueue.main.async {
            self.final(.failure(SFSpeedTestNetworkError.requestFailed))
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        DispatchQueue.main.async {
            self.final(.failure(SFSpeedTestNetworkError.requestFailed))
        }
    }
}