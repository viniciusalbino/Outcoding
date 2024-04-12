
import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var delegate: HomeViewControllerDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let interactor = HomeInteractor()
        let presenter = HomePresenter(interactor: interactor)
        let viewController = HomeViewController(presenter: presenter)
        
        interactor.output = presenter
        presenter.viewController = viewController
        viewController.navigationDelegate = self
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func navigateToDetail(detail: SearchResponse) {
        let interactor = ItemDetailInteractor()
        let presenter = ItemDetailPresenter(interactor: interactor)
        let viewController = ItemDetailViewController(presenter: presenter)
        
        interactor.output = presenter
        presenter.viewController = viewController
        presenter.setContent(data: detail)
        
        DispatchQueue.main.async {
            self.navigationController.pushViewController(viewController, animated: true)
        }
    }
}

extension MainCoordinator: HomeViewControllerDelegate {
    func didSelectDetail(_ detail: SearchResponse) {
        navigateToDetail(detail: detail)
    }
}

protocol Coordinator {
    func start()
    
}
