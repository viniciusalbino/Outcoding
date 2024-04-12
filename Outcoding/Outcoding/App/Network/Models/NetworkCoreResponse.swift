
import Foundation

struct NetworkCoreResponse {
    let statusCode: Int
    let data: Data
    let headers: [AnyHashable: Any]
    let handler: NetworkCoreHandler
    
    init(statusCode: Int, data: Data?, headers: [AnyHashable : Any], handler: NetworkCoreHandler) {
        self.statusCode = statusCode
        self.data = data ?? Data()
        self.headers = headers
        self.handler = handler
    }
}

extension NetworkCoreResponse {
    static var internalError: NetworkCoreResponse {
        let error = NetworkCoreErrorType.internal
        return NetworkCoreResponse(statusCode: error.rawValue, data: Data(), headers: [:], handler: .error(error))
    }
    
    static var noConnection: NetworkCoreResponse {
        let error = NetworkCoreErrorType.noConnection
        return NetworkCoreResponse(statusCode: error.rawValue, data: Data(), headers: [:], handler: .error(error))
    }
    
    static func errorWithCode(_ code: NetworkCoreStatusCode) -> NetworkCoreResponse {
        let handler = NetworkCoreHandler(statusCode: code.rawValue)
        return NetworkCoreResponse(statusCode: code.rawValue, data: Data(), headers: [:], handler: handler)
    }
    
    static func errorWithCode(_ code: Int) -> NetworkCoreResponse {
        let handler = NetworkCoreHandler(statusCode: code)
        return NetworkCoreResponse(statusCode: code, data: Data(), headers: [:], handler: handler)
    }
    
    static var successNoContent: NetworkCoreResponse {
        let code = NetworkCoreErrorType.noContent.rawValue
        let handler = NetworkCoreHandler(statusCode: code)
        return NetworkCoreResponse(statusCode: code, data: Data(), headers: [:], handler: handler)
    }
    
    static var notFound: NetworkCoreResponse {
        let code = NetworkCoreErrorType.notFound.rawValue
        let handler = NetworkCoreHandler(statusCode: code)
        return NetworkCoreResponse(statusCode: code, data: Data(), headers: [:], handler: handler)
    }
}
