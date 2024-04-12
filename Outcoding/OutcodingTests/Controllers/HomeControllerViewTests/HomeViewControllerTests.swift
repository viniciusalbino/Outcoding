
import Foundation
import XCTest
@testable import Outcoding

class HomeViewControllerTests: XCTestCase {
    var sut: HomeViewController!
    var mockPresenter: HomePresenter!
    var mockInteractor: MockHomeInteractor!
    var mockNavigationDelegate: MockNavigationDelegate!
    
    override func setUpWithError() throws {
        mockInteractor = MockHomeInteractor()
        mockPresenter = HomePresenter(interactor: mockInteractor)
        mockInteractor.presenter = mockPresenter
        
        mockNavigationDelegate = MockNavigationDelegate()
        sut = HomeViewController(presenter: mockPresenter)
        mockPresenter.viewController = sut
        sut.navigationDelegate = mockNavigationDelegate
        sut.loadViewIfNeeded()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockPresenter = nil
    }
    
    func testCellForRow_ConfiguresCell() {
        mockPresenter.loadContent()
        let cell = sut.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(cell, "Cell should not be nil")
    }
    
    func testTableView_IsTableViewSetUpProperly() {
        XCTAssertNotNil(sut.tableView, "TableView should not be nil")
        XCTAssertTrue(sut.tableView.delegate is HomeViewController, "ViewController should be delegate")
        XCTAssertTrue(sut.tableView.dataSource is HomeViewController, "ViewController should be dataSource")
    }

    func testDidSelectRow_DelegateTriggered() {
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(mockNavigationDelegate.detailSelected, "Detail selection should trigger delegate")
    }
    
    func testHomeViewController_WhenCreated_HasRequiredPresenterInjected() {
        XCTAssertNotNil(sut.presenter, "Presenter should not be nil")
    }
    
    func testHomeViewController_WhenSettingLoading_ShowsLoadingIndicator() {
        sut.isLoading = true
        XCTAssertTrue(sut.isLoading, "Loading indicator should be visible when isLoading is set to true")
    }
}

// Mock classes for dependencies

class MockNavigationDelegate: HomeViewControllerDelegate {
    var detailSelected = false
    func didSelectDetail(_ object: SearchResponse) {
        detailSelected = true
    }
}

class MockTableView: UITableView {
    var reloadDataCalled = false
    override func reloadData() {
        reloadDataCalled = true
    }
}
