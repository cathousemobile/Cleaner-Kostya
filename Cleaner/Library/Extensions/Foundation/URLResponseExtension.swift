import Foundation

extension URLResponse {
    private var httpResponse: HTTPURLResponse? {
        return self as? HTTPURLResponse
    }

    var isOk: Bool {
        if let response = httpResponse, response.statusCode == 200 {
            return true
        }
        return false
    }

    var isJSON: Bool {
        if  let response = httpResponse,
            let type = response.allHeaderFields["Content-Type"] as? String,
            type.lowercased() == "application/json"
        {
            return true
        }
        return false
    }
}
