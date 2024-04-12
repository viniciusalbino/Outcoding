
import Foundation
import XCTest
@testable import Outcoding

class HomePresenterTests: XCTestCase {
    var sut: HomePresenter!
    var mockViewController: MockViewController!
    var mockInteractor: MockHomeInteractor!
    
    override func setUpWithError() throws {
        mockViewController = MockViewController()
        mockInteractor = MockHomeInteractor()
        sut = HomePresenter(interactor: mockInteractor)
        sut.viewController = mockViewController
        mockInteractor.presenter = sut
        sut.loadContent()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockViewController = nil
        mockInteractor = nil
    }
    
    // Test Initialization
    func testInitialization() {
        XCTAssertNotNil(sut.viewController, "ViewController should be initialized")
        sut.loadContent()
        XCTAssertEqual(sut.numberOfItensInSection(section: 0), 20, "Number of items should be initialized to 20")
    }
    
    // Method Tests
    func testLoadContent_CallsInteractorGetList() {
        XCTAssertTrue(mockInteractor.getListCalled, "Interactor should be called when content is loaded")
    }
    
    func testNumberOfSections_ReturnsOne() {
        XCTAssertEqual(sut.numberOfSections(), 1, "There should only be one section")
    }
    
    func testNumberOfItemsInSection_ReturnsItemCount() {
        sut.loadContent()
        XCTAssertEqual(sut.numberOfItensInSection(section: 0), 20, "Should return the number of items in content")
    }
    
    func testItemForRowAt_ReturnsCorrectItem() {
        sut.loadContent()
        let returnedItem = sut.itemForRowAt(row: 0)
        XCTAssertEqual(returnedItem?.imageURL, "https://cdn2.thecatapi.com/images/1cq.jpg", "Should return the correct item for the row")
    }
}

// Mock classes for dependencies
class MockViewController: HomePresenterOutputProtocol {
    
    var updateCalled = false
    
    func updateContent() {
        updateCalled = true
    }
    
    func didGetData() {
        
    }
    
    func errorGettingData(error: Outcoding.NetworkError) {
        
    }
}

class MockHomeInteractor: HomeInteractorInputProtocol {
    var getListCalled = false
    var shouldReturnError = false
    weak var presenter: HomeInteractorOutputProtocol?
    
    func getList(dto: SearchDTO) {
        getListCalled = true
        
        if shouldReturnError {
            presenter?.errorGettingObjects(error: NetworkError.unknownError)
        } else {
            let mockData = loadMock()
            presenter?.didGetObjects(objects: mockData)
        }
    }
    
    private func loadMock() -> [SearchResponse] {
        let jsonFile = Bundle(for: MockHomeInteractor.self).path(forResource: "mockData", ofType: "json") ?? ""
        let data = try? Data(contentsOf: URL(fileURLWithPath: jsonFile), options: .mappedIfSafe)
        if let data = data <--> [SearchResponse].self {
            return data
        } else {
            return []
        }
    }
}
