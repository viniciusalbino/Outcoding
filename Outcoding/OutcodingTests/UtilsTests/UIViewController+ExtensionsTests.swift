//
//  UIViewController+ExtensionsTests.swift
//  OutcodingTests
//
//  Created by Vinicius Albino on 11/04/24.
//

import Foundation
import XCTest

@testable import Outcoding

class UIViewControllerExtensionTests: XCTestCase {
    
    var viewController: UIViewController!
    
    override func setUp() {
        super.setUp()
        viewController = UIViewController()
        _ = viewController.view
    }
    
    func testStartLoading() {
        viewController.showLoadingView()
        XCTAssertNotNil(viewController.view.viewWithTag(100))
        
        let loadingView = viewController.view.viewWithTag(100)
        let activityIndicator = loadingView?.subviews.first { $0 is UIActivityIndicatorView }
        
        XCTAssertNotNil(activityIndicator)
    }
    
    func testStopLoading() {
        viewController.showLoadingView()
        XCTAssertNotNil(viewController.view.viewWithTag(100))
        
        viewController.hideLoadingView()
        XCTAssertNil(viewController.view.viewWithTag(100))
    }
    
    func testPerformUIUpdate() {
        let expectation = self.expectation(description: "Closure Execution")
        
        viewController.performUIUpdate {
            XCTAssertTrue(Thread.isMainThread)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
}
