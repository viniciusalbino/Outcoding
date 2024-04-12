
import Foundation
import UIKit

// MARK: - ViewController
protocol HomePresenterOutputProtocol: AnyObject {
    func didGetData()
    func errorGettingData(error: NetworkError)
}

protocol HomeViewControllerDelegate: AnyObject {
    func didSelectDetail(_ detail: SearchResponse)
}

// MARK: - Presenter
protocol HomePresenterInputProtocol: AnyObject {
    func loadContent()
    func numberOfSections() -> Int
    func numberOfItensInSection(section: Int) -> Int
    func itemForRowAt(row: Int) -> HomeCellDTO?
    func objectDetail(row: Int) -> SearchResponse?
}

// MARK: - Interactor
protocol HomeInteractorInputProtocol: AnyObject {
    func getList(dto: SearchDTO)
}

protocol HomeInteractorOutputProtocol: AnyObject {
    func didGetObjects(objects: [SearchResponse])
    func errorGettingObjects(error: NetworkError)
}
