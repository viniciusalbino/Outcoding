
import Foundation
import XCTest
@testable import Outcoding

class RequestableWithBodyTests: XCTestCase {
    
    func testRequestSuccessFromJSON() async throws {
        let requestable = MockRequestable(username: "name")
        do {
            let user = try await requestable.request()
            XCTAssertEqual(user.name, "Test name")
            XCTAssertEqual(user.age, 30)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testRequestSuccessFromCode() async throws {
        let requestable = MockRequestable(username: "developer")
        do {
            let user = try await requestable.request()
            XCTAssertEqual(user.name, "Developer Name")
            XCTAssertEqual(user.age, 27)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testRequestFailure() async {
        let requestable = MockRequestable(username: "")
        do {
            _ = try await requestable.request()
            XCTFail("Expected request to fail")
        } catch let error as NetworkCoreErrorType {
            XCTAssertEqual(error, .noConnection)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

// MARK: - Requestable and Endpoint

private class MockRequestable: NetworkCoreRequestable {
    
    let username: String
    let network = NetworkCore()
    var endpoint: NetworkCoreEndpoint {
        return MockEndpoint(username: username)
    }
    
    init(username: String) {
        self.username = username
    }
    
    func request() async throws -> UserMock {
        let response = try await network.request(for: endpoint)
        
        if let userMock = response.data <--> UserMock.self {
            return userMock
        } else {
            if case let .error(errorType) = response.handler {
                throw errorType
            } else {
                throw NetworkCoreErrorType.unknown
            }
        }
    }
}

private struct MockEndpoint: NetworkCoreEndpoint {
    
    let username: String
    let baseURL = URL(string: "https://google.com")!
    let path = "/path/to/endpoint"
    let method = NetworkCoreMethod.post
    let headers: [String : String] = [:]
    var task: NetworkCoreTask {
        return .requestParameters(parameters: ["username": username])
    }
}

extension MockEndpoint {
    
    var shouldMock: Bool {
        return true
    }
    
    var mockResponse: NetworkCoreResponse? {
        guard !username.isEmpty else {
            return NetworkCoreResponse.notFound
        }
        if username == "developer" {
            let userMockData = UserMock(name: "Developer Name", age: 27).encoded()
            return NetworkCoreResponse(statusCode: 200, data: userMockData, headers: [:], handler: .success)
        } else {
            let jsonFile = Bundle(for: RequestableWithBodyTests.self).path(forResource: "user-mock", ofType: "json") ?? ""
            let data = try? Data(contentsOf: URL(fileURLWithPath: jsonFile), options: .mappedIfSafe)
            return NetworkCoreResponse(statusCode: 200, data: data ?? Data(), headers: [:], handler: .success)
        }
    }
}
