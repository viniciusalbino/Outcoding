
import Foundation
import XCTest

@testable import Outcoding

class UIViewExtensionTests: XCTestCase {
    
    func testPerformUIUpdate() {
        let expectation = self.expectation(description: "Closure Execution")
        
        let view = UIView()
        view.performUIUpdate {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPinToBounds() {
        let superView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let childView = UIView(frame: .zero)
        
        superView.addSubview(childView)
        childView.pinToBounds()
        
        let constraints = superView.constraints
        
        XCTAssertTrue(constraints.contains(where: { $0.firstAnchor == childView.topAnchor }))
        XCTAssertTrue(constraints.contains(where: { $0.firstAnchor == childView.leadingAnchor }))
        XCTAssertTrue(constraints.contains(where: { $0.firstAnchor == childView.trailingAnchor }))
        XCTAssertTrue(constraints.contains(where: { $0.firstAnchor == childView.bottomAnchor }))
    }
    
    func testPinToBoundsWithCustomSpacing() {
        let superView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let childView = UIView(frame: .zero)
        
        let insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        childView.pinToBounds(of: superView, customSpacing: insets)
        
        let constraints = superView.constraints
        
        XCTAssertTrue(constraints.contains(where: { $0.firstAnchor == childView.topAnchor && $0.constant == insets.top }))
        XCTAssertTrue(constraints.contains(where: { $0.firstAnchor == childView.leadingAnchor && $0.constant == insets.left }))
        XCTAssertTrue(constraints.contains(where: { $0.firstAnchor == childView.trailingAnchor && $0.constant == insets.right }))
        XCTAssertTrue(constraints.contains(where: { $0.firstAnchor == childView.bottomAnchor && $0.constant == insets.bottom }))
    }
}
