
import Foundation

final class HomePresenter {
    
    // MARK: -  Viper Properties
    weak var viewController: HomePresenterOutputProtocol?
    private let interactor: HomeInteractorInputProtocol
    private var currentPage: Int = 0
    private var numberOfItens: Int = 20
    
    // MARK: - Properties
    private var content: [SearchResponse] = []
    
    // MARK: - init
    init(interactor: HomeInteractorInputProtocol) {
        self.interactor = interactor
    }
}

// MARK: - Presenter Input Protocol
extension HomePresenter: HomePresenterInputProtocol {
    
    func loadContent() {
        interactor.getList(dto: SearchDTO(page: currentPage, limit: numberOfItens))
        currentPage += 1
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItensInSection(section: Int) -> Int {
        return content.count
    }
    
    func itemForRowAt(row: Int) -> HomeCellDTO? {
        guard let object = content.object(index: row) else {
            return nil
        }
        return HomeCellDTO(imageURL: object.url, name: String(object.width), subtitle: String(object.height))
    }
    
    func objectDetail(row: Int) -> SearchResponse? {
        guard let object = content.object(index: row) else {
            return nil
        }
        return object
    }
}

// MARK: - Interactor Output Protocol
extension HomePresenter: HomeInteractorOutputProtocol {
    func didGetObjects(objects: [SearchResponse]) {
        content.append(contentsOf: objects)
        viewController?.didGetData()
    }
    
    func errorGettingObjects(error: NetworkError) {
        viewController?.errorGettingData(error: error)
    }
}
