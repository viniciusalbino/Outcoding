//
//  OutcodingUITests.swift
//  OutcodingUITests
//
//  Created by Vinicius Albino on 08/04/24.
//

import XCTest

final class OutcodingUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testLoadingView() {
        // Expect the loading view to appear
        let loadingView = app.otherElements["LoadingView"]
        let loadingViewExists = loadingView.waitForExistence(timeout: 0.5)
        XCTAssertTrue(loadingViewExists, "Loading view should appear within 5 seconds")
        
        // Use an expectation to wait for the loading view to disappear
        let loadingViewDoesNotExist = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: loadingViewDoesNotExist, object: loadingView)
        
        // Wait up to 10 seconds for the loading view to disappear
        wait(for: [expectation], timeout: 10)
        
        // Assert that the loading view is not visible anymore
        XCTAssertFalse(loadingView.exists, "Loading view should disappear after the data is loaded")
    }
    
    func testTableViewLoading() {
        // Expectation for the table view to have at least one cell loaded
        if app.tables.element.waitForExistence(timeout: 5) {
            let tableView = app.tables["HomeTableView"]
            XCTAssertTrue(tableView.cells.count > 0, "The table view should have at least one cell loaded")
        }
    }

    func testNavigationToDetailView() {
        if app.tables.element.waitForExistence(timeout: 5) {
            let tableView = app.tables["HomeTableView"]
            
            let firstCell = tableView.cells.element(boundBy: 0)
            firstCell.tap()
            // Verify that the detail view is displayed
            
            let detailView = app.tables["DetailView"]
            let exists = detailView.waitForExistence(timeout: 10)
            XCTAssertTrue(exists, "Detail view should be visible after tapping the first cell")
        }
    }
}
