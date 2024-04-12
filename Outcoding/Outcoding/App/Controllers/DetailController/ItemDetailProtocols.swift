
import Foundation

// MARK: - ViewController
protocol ItemDetailPresenterOutputProtocol: AnyObject {
    func reloadData(data: [ItemDetailCellDTO])
}

// MARK: - Presenter
protocol ItemDetailPresenterInputProtocol: AnyObject {
    func headerDTO() -> DetailHeaderViewDTO?
    func loadContent()
}

// MARK: - Interactor
protocol ItemDetailInteractorInputProtocol: AnyObject {
    
}

protocol ItemDetailInteractorOutputProtocol: AnyObject {
    
}

// MARK: - Router
protocol ItemDetailRouterProtocol: AnyObject {
    
}
