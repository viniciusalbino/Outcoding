
import Foundation
import UIKit

final class SearchRequest: NetworkCoreRequestable {
    let network = NetworkCore.defaultNetwork
    let endpoint: NetworkCoreEndpoint
    
    init(dto: SearchDTO) {
        self.endpoint = SearchEndpoint(dto: dto)
    }
    
    func request() async throws -> [SearchResponse] {
        let response = try await network.request(for: endpoint)
        switch response.handler {
        case .success:
            if let data = response.data <--> [SearchResponse].self {
                return data
            } else {
                throw NetworkError.businessError
            }
        case .error(let networkError):
            throw networkError
        }
    }
}

struct SearchEndpoint: NetworkCoreEndpoint {
    
    let dto: SearchDTO
    
    init(dto: SearchDTO) {
        self.dto = dto
    }
    
    var path: String {
        return "/images/search"
    }
    
    var task: NetworkCoreTask {
        return .requestParameters(parameters: dto.asParameters())
    }
    
    var method: NetworkCoreMethod {
        return .get
    }
    
    var headers: [String : String] {
        return ["x-api-key": "live_EJRkHbEDzHQOduh4FZ7c9bMCGXkYBmrKcycRx4ZmJepqFC3gIRHamP8s6cmF6CqZ",
                "Content-Type": "application/json"]
    }
    
    var shouldMock: Bool {
        return false
    }
    
    var mockResponse: NetworkCoreResponse? {
        guard let jsonData = loadLocalJSON(named: "ListResponse.json") else {
            return nil
        }
        return NetworkCoreResponse(statusCode: 200, data: jsonData, headers: [:], handler: .success)
    }
}
