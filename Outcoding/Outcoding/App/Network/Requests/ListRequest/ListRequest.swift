//
//  ListRequest.swift
//  Outcoding
//
//  Created by Vinicius Albino on 10/04/24.
//

import Foundation
import UIKit

final class Search: NetworkCoreRequestable {
    let network = NetworkCore.defaultNetwork
    let endpoint: NetworkCoreEndpoint
    
    init(dto: ListDTO) {
        self.endpoint = ListEndpoint(dto: dto)
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

struct ListEndpoint: NetworkCoreEndpoint {
    
    let dto: ListDTO
    
    init(dto: ListDTO) {
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
