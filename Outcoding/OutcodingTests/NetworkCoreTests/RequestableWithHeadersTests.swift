
import Foundation
import XCTest
@testable import Outcoding

class RequestableWithHeadersTests: XCTestCase {
    
    func testRequestSuccess() async throws {
        let requestable = MockRequestable(username: "developer", password: "123456")
        do {
            let authorization = try await requestable.request()
            XCTAssertEqual(authorization, "ki9ju8hy7gt6fr5de4sw34ed5rft6gy7bhnum")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testRequestFailureWithInvalidCredentials() async {
        let requestable = MockRequestable(username: "developer", password: "138hs782")
        do {
            _ = try await requestable.request()
            XCTFail("Expected request to fail")
        } catch let error as NetworkCoreErrorType {
            XCTAssertEqual(error, .businessError)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testRequestFailureWithEmptyCredentials() async {
        let requestable = MockRequestable(username: "", password: "")
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
    let password: String
    let network = NetworkCore()
    var endpoint: NetworkCoreEndpoint {
        return MockEndpoint(username: username, password: password)
    }
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    func request() async throws -> String {
        let response = try await network.request(for: endpoint)
        
        switch response.handler {
        case .success:
            if let authorizationHeader = response.headers["X-Authorization"] as? String {
                let normalizedAuthorization = authorizationHeader.replacingOccurrences(of: "Bearer", with: "").trimmingCharacters(in: .whitespaces)
                return normalizedAuthorization
            } else {
                throw NetworkCoreErrorType.businessError
            }
        case .error(let errorType):
            throw errorType
        }
    }
}

private struct MockEndpoint: NetworkCoreEndpoint {
    
    let username: String
    let password: String
    let baseURL = URL(string: "https://google.com")!
    let path = "/path/to/endpoint"
    let method = NetworkCoreMethod.post
    let headers: [String : String] = [:]
    var task: NetworkCoreTask {
        let credentialsData = "\(username)=\(password)".data(using: .utf8) ?? Data()
        return .requestCompositeBodyData(data: credentialsData, urlParameters: [:])
    }
}

extension MockEndpoint {
    
    var shouldMock: Bool {
        return true
    }
    
    var mockResponse: NetworkCoreResponse? {
        guard !username.isEmpty, !password.isEmpty else {
            return NetworkCoreResponse.notFound
        }
        let passwordContainsOnlyNumbers = password.allSatisfy { $0.isNumber }
        if passwordContainsOnlyNumbers {
            let headers = ["X-Authorization": "Bearer ki9ju8hy7gt6fr5de4sw34ed5rft6gy7bhnum"]
            return NetworkCoreResponse(statusCode: 204, data: Data(), headers: headers, handler: .success)
        } else {
            return NetworkCoreResponse.errorWithCode(.badRequest)
        }
    }
}
