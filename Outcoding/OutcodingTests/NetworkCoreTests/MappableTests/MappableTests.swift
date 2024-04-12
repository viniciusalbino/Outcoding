
import Foundation
import  XCTest

@testable import Outcoding

class NetworkCoreMappableTests: XCTestCase {
    let userA = UserMock(name: "User A", age: 20)
    let userB = UserMock(name: "User B", age: 30)
    
    func testEncodeAndDecodeSingleModel() {
        let data = userA.encoded()
        XCTAssertFalse(data.isEmpty)
        let expectedData = try! JSONEncoder().encode(userA)
        XCTAssertEqual(data, expectedData)
        let decoded = try! JSONDecoder().decode(UserMock.self, from: data)
        
        XCTAssertEqual(decoded.name, userA.name)
        XCTAssertEqual(decoded.age, userA.age)
    }
    
    func testEncodeAndDecodeArrayModels() {
        let users = [userA, userB]
        let data = users.encoded()
        XCTAssertFalse(data.isEmpty)
        XCTAssertEqual(String(data: data, encoding: .utf8), "[{\"name\":\"User A\",\"age\":20},{\"name\":\"User B\",\"age\":30}]")
        let decoded = data <--> [UserMock].self
        XCTAssertNotNil(decoded)
        XCTAssertEqual(decoded, users)
    }
}
