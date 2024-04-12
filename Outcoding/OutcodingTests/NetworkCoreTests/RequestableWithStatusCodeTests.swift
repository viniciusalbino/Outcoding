
import Foundation
import XCTest
@testable import Outcoding

class RequestableWithStatusCodeTests: XCTestCase {
    
    func testRequestSuccess() async throws {
        let requestable = MockRequestable(hash: "a2qsw3de45fr6gt7hy8ju9ikju8hy7gt6fr5")
        
        do {
            let dummy = try await requestable.request()
            XCTAssertNotNil(dummy)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testRequestFailure() async {
        let requestable = MockRequestable(hash: "wu8hy7gt")
        
        do {
            _ = try await requestable.request()
            XCTFail("Expected request to fail")
        } catch let error as NetworkCoreErrorType {
            XCTAssertEqual(error, .businessError)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

// MARK: - Requestable and Endpoint

private class MockRequestable: NetworkCoreRequestable {
    let hash: String
    let network = NetworkCore()
    var endpoint: NetworkCoreEndpoint {
        return MockEndpoint(hash: hash)
    }
    
    init(hash: String) {
        self.hash = hash
    }
    
    func request() async throws -> Dummy {
        let result = try await network.request(for: endpoint)
        if result.statusCode == NetworkCoreStatusCode.created.rawValue {
            return Dummy()
        } else {
            throw NetworkCoreErrorType.businessError
        }
    }
}

private struct MockEndpoint: NetworkCoreEndpoint {
    
    let hash: String
    let baseURL = URL(string: "https://google.com")!
    let path = "/path/to/endpoint"
    let method = NetworkCoreMethod.post
    let headers: [String : String] = [:]
    var task: NetworkCoreTask {
        return .requestCompositeBodyData(data: hash.encoded(), urlParameters: [:])
    }
}

extension MockEndpoint {
    
    var shouldMock: Bool {
        return true
    }
    
    var mockResponse: NetworkCoreResponse? {
        if hash.count > 10 {
            return NetworkCoreResponse(statusCode: 201, data: Data(), headers: [:], handler: .success)
        } else {
            return NetworkCoreResponse.errorWithCode(.badRequest)
        }
    }
}
