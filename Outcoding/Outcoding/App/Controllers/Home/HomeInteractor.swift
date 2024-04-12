
import Foundation

final class HomeInteractor {
    // MARK: - Viper properties
    weak var output: HomeInteractorOutputProtocol?
}
// MARK: - Input Protocol

extension HomeInteractor: HomeInteractorInputProtocol {
    
    func getList(dto: SearchDTO) {
        let requestable = SearchRequest(dto: dto)
        Task {
            do {
                let objects = try await requestable.request()
                self.output?.didGetObjects(objects: objects)
            } catch let error as NetworkError {
                self.output?.errorGettingObjects(error: error)
            }
        }
    }
}
