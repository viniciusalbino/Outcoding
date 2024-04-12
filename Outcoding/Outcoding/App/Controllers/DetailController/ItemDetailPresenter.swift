
import Foundation

final class ItemDetailPresenter {
    // MARK: -  Viper Properties
    weak var viewController: ItemDetailPresenterOutputProtocol?
    private let interactor: ItemDetailInteractorInputProtocol
    
    // MARK: - Properties
    private var content: SearchResponse?
    private var objectDetail: [ItemDetailCellDTO] = []
    
    // MARK: - init
    init(interactor: ItemDetailInteractorInputProtocol) {
        self.interactor = interactor
    }
    
    public func setContent(data: SearchResponse) {
        self.content = data
    }
}

// MARK: - Presenter Input Protocol
extension ItemDetailPresenter: ItemDetailPresenterInputProtocol {
    
    func headerDTO() -> DetailHeaderViewDTO? {
        guard let content = content else {
            return nil
        }
        return DetailHeaderViewDTO(imageURL: content.url, name: content.id, subtitle: String(content.height), price: String(content.height))
    }
    
    func loadContent() {
        content?.breeds.forEach{ breed in
            objectDetail.append(ItemDetailCellDTO(title: "Breed", content: breed.description ?? ""))
        }
        didLoadContent()
    }
}

// MARK: - Presenter Output Protocol
extension ItemDetailPresenter: ItemDetailInteractorOutputProtocol {
    func didLoadContent() {
        viewController?.reloadData(data: objectDetail)
    }
}

struct ItemDetailCellDTO: Hashable {
    var title: String
    var content: String
    
    func formattedText() -> String {
        return "\(title): \(content)"
    }
}
