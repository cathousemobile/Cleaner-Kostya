import Foundation
import UIKit

internal class SFSpeedTestCustomService {
    static let shared = SFSpeedTestCustomService()

    private var speedTest = SFAllSpeedTestServices()
    private var hostDownloadService = SFSpeedTestDownloadService()
    private var hostUploadService = SFSpeedTestUploadService()

    private var chosenHost: SFSpeedTestHostModel?
    private var isTesting: Bool = false


    private init() {}

    /// resets all host and services
    func resetData() {
        speedTest = SFAllSpeedTestServices()
        hostDownloadService = SFSpeedTestDownloadService()
        hostUploadService = SFSpeedTestUploadService()
        chosenHost = nil
    }
    
    func stop() {
        self.hostUploadService.stop()
        self.hostDownloadService.stop()
    }
    
    /// finds best hosts nearby and compares them by ping, returns host with it's info
    func findBestHostForTest(bestHost: @escaping (_ host: SFSpeedTestHostModel)-> (),
                             error: @escaping (_ error: String) -> ()){
        if isTesting == false {
            isTesting = true
            getBestHost { (bestHostFound, ping) in
                self.chosenHost = bestHostFound
                bestHost(bestHostFound)
                self.isTesting = false
            } failure: { (hostError) in
                error(hostError)
                self.isTesting = false
            }
        } else {
            error(SpeedTestCustomState.isTesting.localizedDescription)
        }

    }
    /// ping chosen host, returns ping in ms
    func makePingTest(ping: @escaping (_ ping: Int)-> (),
                      error: @escaping (_ error: String) -> ()){
        guard let chosenHost = chosenHost else {
            return
        }
        guard let URLToPing = URL(string: "http://\(chosenHost.host)") else {
            return
        }
        URLToPing.ping(timeout: 10) { (result) in
            switch result {
            case .success(let value):
                ping(value)
            case .failure(let pingError):
                error(pingError.localizedDescription)
            }
        }
    }
    /// download speed test, returns speed in result and get closure for update current and average speeds
    func makeDownloadTestWithHost(currentSpeed: ((SFSpeedModel) -> Void)? = nil,
                                  avgSpeed: ((SFSpeedModel) -> Void)? = nil,
                                  testResult: @escaping (_ speedTestResult: (SFSpeedModel?, SpeedTestCustomState)) -> Void){
        guard let chosenHost = chosenHost else {
            testResult((nil, .isTesting))
            return
        }
        var avgSpeedRecord: SFSpeedModel?
        hostDownloadService.test(chosenHost.url,
                                 fileSize: 100000000,
                                 timeout: 30)
        { (current, avg) in
            currentSpeed?(current)
            avgSpeedRecord = avg
            avgSpeed?(avg)
        } final: { (result) in
            switch result {
            case .success(let value):
                testResult((value, .successful))
            case .failure(_):
                testResult((avgSpeedRecord, .testError))
            }
        }
    }
    /// upload speed test, returns speed in result and get closure for update current and average speeds
    func makeUploadTestWithHost(currentSpeed: ((SFSpeedModel) -> Void)? = nil,
                                avgSpeed: ((SFSpeedModel) -> Void)? = nil,
                                testResult: @escaping (_ speedTestResult: (SFSpeedModel?, SpeedTestCustomState)) -> Void){
        guard let chosenHost = chosenHost else { return }
        hostUploadService.test(chosenHost.url, fileSize: 100000000, timeout: 30)
        { (current, avg) in
            currentSpeed?(current)
            avgSpeed?(avg)
        } final: { (result) in
            switch result {
            case .success(let value):
                testResult((value, .successful))
            case .failure(_):
                testResult((nil, .testError))
            }
        }
    }
    /// finds best host
    private func getBestHost(bestHost: @escaping (_ bestHost: (SFSpeedTestHostModel, Int)) -> (),
                             failure: @escaping (_ errorMessage: String) -> ()){
        speedTest.findBestHost(from: 30, timeout: 3) { (result) in
            switch result {
            case .success(let host):
                bestHost(host)
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
}
/// enum for speed test return states
enum SpeedTestCustomState: Error {
    case isTesting
    case unknownError
    case testError
    case successful

    public var localizedDescription: String? {
        switch self {
        case .isTesting:
            return "Test already running"
        case .unknownError:
            return "Unknown error"
        case .testError:
            return "Test error"
        case .successful:
            return "Successfull"
        }
    }
}
