import Foundation

class RapidTesterRecivePacket: NSObject, RapidTesterTestProtocol {
    private var responseDate: Date?
    private var latestDate: Date?
    private var current: ((RapidTesterInfo, RapidTesterInfo) -> ())!
    private var final: ((Result<RapidTesterInfo, RapidTesterNetworkError>) -> ())!
    private var session: URLSession?
    private var task: URLSessionDownloadTask?
    private var isStoped = false

    func test(_ url: URL, fileSize: Int, timeout: TimeInterval, current: @escaping (RapidTesterInfo, RapidTesterInfo) -> (), final: @escaping (Result<RapidTesterInfo, RapidTesterNetworkError>) -> ()) {
        self.current = current
        self.final = final
        let resultURL = RapidTesterEndpointCreator(speedTestURL: url).downloadURL(size: fileSize)
        session = URLSession(configuration: sessionConfiguration(timeout: timeout), delegate: self, delegateQueue: OperationQueue())
        task = session?.downloadTask(with: resultURL)
        task?.resume()
    }
    
    func stop() {
        isStoped = true
    }
}

extension RapidTesterRecivePacket: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let result = calculate(bytes: downloadTask.countOfBytesReceived, seconds: Date().timeIntervalSince(self.responseDate!))
        DispatchQueue.main.async {
            self.final(.success(result))
        }
    }

    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        DispatchQueue.main.async {
            self.final(.failure(RapidTesterNetworkError.requestFailed))
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error == nil {
            let result = self.calculate(bytes: task.countOfBytesReceived, seconds: Date().timeIntervalSince(self.responseDate!))
            DispatchQueue.main.async {
                self.final(.success(result))
            }
        } else {
            DispatchQueue.main.async {
                self.final(.failure(RapidTesterNetworkError.requestFailed))
            }
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
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

        let current = calculate(bytes: bytesWritten, seconds: currentTime.timeIntervalSince(latesDate))
        let average = calculate(bytes: totalBytesWritten, seconds: -startDate.timeIntervalSinceNow)

        latestDate = currentTime

        DispatchQueue.main.async {
            self.current(current, average)
        }
    }
    
    
}
