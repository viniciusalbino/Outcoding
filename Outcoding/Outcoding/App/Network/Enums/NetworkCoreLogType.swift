
import Foundation

enum NetworkCoreLogType: CaseIterable {
    case none
    case min
    case max
}

final class NetworkCoreLogger {
    class func log(_ endpoint: NetworkCoreEndpoint, _ response: NetworkCoreResponse, _ type: NetworkCoreLogType) {
        switch type {
        case .min:
            minLog(endpoint, response)
        case .max:
            maxLog(endpoint, response)
        case .none:
            break
        }
    }
    
    private class func minLog(_ endpoint: NetworkCoreEndpoint, _ response: NetworkCoreResponse) {
        let separator = String(repeating: "=", count: 100)
        let template = {
            """
            \(separator)
            >>> NetworkCore
            >>> Request
            >> - url: \(endpoint.createURL()?.absoluteString ?? "-")
            >> - method: \(endpoint.method.rawValue)
            >>> Response
            >> - statusCode: \(response.statusCode)
            >> - handler: \(response.handler.logIdentifier)
            """
        }()
        print(template)
    }
    
    private class func maxLog(_ endpoint: NetworkCoreEndpoint, _ response: NetworkCoreResponse) {
        let separator = String(repeating: "=", count: 100)
        let data = String(data: response.data, encoding: .utf8) ?? "-"
        let template = {
            """
            \(separator)
            >>> NetworkCore
            >>> Request
            >> - url: \(endpoint.createURL()?.absoluteString ?? "-")
            >> - base: \(endpoint.baseURL.absoluteURL)
            >> - path: \(endpoint.path)
            >> - method: \(endpoint.method.rawValue)
            >> - task: \(endpoint.task.logIdentifier)
            >> - url Parameters: \(endpoint.task.logParameters)
            >> - body: \(endpoint.task.logBody)
            >> - headers: \((endpoint.headers).logElements)
            >>> Response
            >> - statusCode: \(response.statusCode)
            >> - handler: \(response.handler.logIdentifier)
            >> - data: \(data)
            
            """
        }()
        print(template)
    }
}

private extension NetworkCoreTask {
    var logIdentifier: String {
        switch self {
        case .requestPlain:
            return "request plain"
        case .requestParameters:
            return "request parameters"
        case .requestCompositeBodyData:
            return "request composite body data"
        }
    }
    
    var logParameters: String {
        switch self {
        case .requestPlain:
            return "_"
        case .requestParameters(let parameters):
            return parameters.logElements
        case .requestCompositeBodyData(_, let urlParameters):
            return urlParameters.logElements
        }
    }
    
    var logBody: String {
        switch self {
        case .requestPlain, .requestParameters:
            return "_"
        case .requestCompositeBodyData(let data, _):
            return String(data: data, encoding: .utf8) ?? ""
        }
    }
}

private extension NetworkCoreHandler {
    var logIdentifier: String {
        switch self {
        case .success:
            return "Success"
        case .error(let errorType):
            return "error: \(errorType) - \(errorType.localizedDescription)"
        }
    }
}

private extension Dictionary where Key == String, Value == Any {
    var logElements: String {
        return self.compactMap { "\($0.key): \($0.value)" }.joined(separator: "  |  ")
    }
}

private extension Dictionary where Key == String, Value == String {
    var logElements: String {
        return self.compactMap { "\($0.key): \($0.value)" }.joined(separator: "  |  ")
    }
}
