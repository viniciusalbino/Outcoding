
import Foundation
import XCTest
@testable import Outcoding

struct Dummy: Mappable {
    init() {
    }
}

class ResultExtensionsTests: XCTestCase {
    
    func testResultWithError() {
        typealias ResultType = Result<Dummy, NetworkCoreErrorType>
        let resultA: ResultType = {
            return .failure(.unknown)
        }()
        let resultB: ResultType = {
            return .failure(.unknown)
        }()
        if case let .failure(errorA) = resultA, case let .failure(errorB) = resultB {
            XCTAssertEqual(errorA, .unknown)
            XCTAssertEqual(errorB, .unknown)
            XCTAssertEqual(errorA, errorB)
        } else {
            assertionFailure("Unexpected result")
        }
    }
}
