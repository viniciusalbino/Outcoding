
import Foundation

enum NetworkCoreHandler {
    case success
    
    case error(NetworkCoreErrorType)
    
    init(statusCode: Int) {
        switch NetworkCoreStatusCode(rawValue: statusCode) {
        case .noContent, .unknown:
            self = .error(.unknown)
        case .noConnection:
            self = .error(.noConnection)
        case .statusOK:
            self = .success
        case .badRequest:
            self = .error(.businessError)
        case .notFound:
            self = .error(.notFound)
        case .internalServerError:
            self = .error(.unknown)
        default:
            self = .error(.unknown)
        }
    }
}

enum NetworkCoreErrorType: Int, Swift.Error {
    case notFound
    case businessError
    case forbidden
    case serviceDown
    case cancelled
    case noConnection
    case unknown
    case noContent
    case `internal`
}

enum NetworkCoreStatusCode: Int {
    case noConnection = 0
    case unknown = -998
    case statusOK = 200
    case noContent = 204
    case badRequest = 400
    case notFound = 404
    case internalServerError = 500
    case created = 201
}

enum NetworkError: Error {
    case noConnection
    case notFound
    case unauthorized
    case forbidden
    case internalServerError
    case unknownError
    case businessError
    case customError(errorCode: String, message: String)
    
    init(errorCode: String, message: String) {
        self = .customError(errorCode: errorCode, message: message)
    }
    
    init(httpStatusCode: Int) {
        switch httpStatusCode {
        case 404:
            self = .notFound
        case 401:
            self = .unauthorized
        case 403:
            self = .forbidden
        case 500:
            self = .internalServerError
        default:
            self = .unknownError
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .noConnection:
            return "No Internet connection."
        case .notFound:
            return "The requested resource was not found."
        case .unauthorized:
            return "Authentication is required and has failed or has not yet been provided."
        case .forbidden:
            return "The request was a legal request, but the server is refusing to respond to it."
        case .internalServerError:
            return "An internal server error has occurred."
        case .businessError:
            return "Business error (due to parsing object)"
        case .unknownError:
            return "An unknown error has occurred."
        case .customError(_, let message):
            return message
        }
    }
}
