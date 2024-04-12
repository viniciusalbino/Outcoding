
import Foundation

final class ItemDetailInteractor {
    // MARK: - Viper properties
    weak var output: ItemDetailInteractorOutputProtocol?
    
}

// MARK: - Input Protocol

extension ItemDetailInteractor: ItemDetailInteractorInputProtocol {
    
}
