
import Foundation
import UIKit

final class ItemDetailViewController: UITableViewController {
    // MARK: - Viper Properties
    private let presenter: ItemDetailPresenterInputProtocol
    
    // MARK: - Private Properties
    private var dataSource: UITableViewDiffableDataSource<Section, ItemDetailCellDTO>!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, ItemDetailCellDTO>()
    
    // MARK: - Init
    
    init(presenter: ItemDetailPresenterInputProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    enum Section: CaseIterable {
        case header
        case info
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureDataSource()
        loadContent()
    }
    
    func setup() {
        title = "Detail"
        
        tableView.accessibilityIdentifier = "DetailView"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "infoCell")
    }
    
    func loadContent() {
        presenter.loadContent()
    }
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, ItemDetailCellDTO>(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
            cell.textLabel?.text = item.formattedText()
            return cell
        }
        snapshot.appendSections(Section.allCases)
        tableView.dataSource = dataSource
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = DetailHeaderView(frame: .zero)
            if let dto = presenter.headerDTO() {
                headerView.fill(dto: dto)
            }
            return headerView
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return UITableView.automaticDimension
        }
        return 0.01
    }
}

// MARK: - Presenter output protocol
extension ItemDetailViewController: ItemDetailPresenterOutputProtocol {
    func reloadData(data: [ItemDetailCellDTO]) {
        performUIUpdate {
            self.hideLoadingView()
            self.snapshot.appendItems(data, toSection: .info)
            self.dataSource?.apply(self.snapshot, animatingDifferences: true)
        }
    }
}
