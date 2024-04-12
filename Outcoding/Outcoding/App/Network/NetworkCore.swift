
import Foundation

class NetworkCore {
    
    private let configuration: NetworkCoreConfiguration
    private var session: URLSession
    
    init(configuration: NetworkCoreConfiguration = NetworkCoreConfiguration()) {
        self.configuration = configuration
        self.session = URLSession(configuration: configuration.urlSessionConfiguration)
    }
    
    func request(for endpoint: NetworkCoreEndpoint) async throws -> NetworkCoreResponse {
        if endpoint.shouldMock, let mockResponse = endpoint.mockResponse {
            NetworkCoreLogger.log(endpoint, mockResponse, configuration.logType)
            return mockResponse
        }
        
        guard let request = endpoint.createRequest() else {
            let errorResponse = NetworkCoreResponse.internalError
            NetworkCoreLogger.log(endpoint, errorResponse, configuration.logType)
            return errorResponse
        }
        do {
            let (data, response) = try await session.data(for: request as URLRequest)
            return try await handleResponse(endpoint, data, response, nil)
        } catch let error as NetworkCoreErrorType {
            throw error
        } catch {
            throw NetworkCoreErrorType.unknown
        }
    }
}

extension NetworkCore {
    
    func handleResponse(_ endpoint: NetworkCoreEndpoint, _ data: Data?, _ response: URLResponse?, _ error: Error?) async throws -> NetworkCoreResponse {
        guard let httpResponse = response as? HTTPURLResponse else {
            if let error = error {
                let errorResponse = NetworkCoreResponse.errorWithCode(error._code)
                NetworkCoreLogger.log(endpoint, errorResponse, configuration.logType)
                return errorResponse
            } else {
                let errorResponse = NetworkCoreResponse.noConnection
                NetworkCoreLogger.log(endpoint, errorResponse, configuration.logType)
                return errorResponse
            }
        }
        
        let response = NetworkCoreResponse(statusCode: httpResponse.statusCode,
                                           data: data ?? Data(),
                                           headers: httpResponse.allHeaderFields,
                                           handler: NetworkCoreHandler(statusCode: httpResponse.statusCode))
        NetworkCoreLogger.log(endpoint, response, configuration.logType)
        return response
    }
}
