
import Foundation
import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: -  Viper Properties
    var presenter: HomePresenterInputProtocol
    weak var navigationDelegate: HomeViewControllerDelegate?
    
    // MARK: - Private Properties
    var isLoading: Bool = false
    var tableView: UITableView!
    
    // MARK: - Init
    init(presenter: HomePresenterInputProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadContent()
    }
    
    private func setup() {
        view.backgroundColor = .systemBackground
        title = "Home"
        
        tableView = UITableView(frame: .zero)
        tableView.registerCell(identifier: HomeTableViewCell.reuseIdentifier)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.accessibilityIdentifier = "HomeTableView"
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.pinToBounds(of: view)
    }
    
    func loadContent() {
        presenter.loadContent()
        performUIUpdate {
            self.isLoading = true
            self.showLoadingView()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItensInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomeTableViewCell = UITableViewCell.createCell(tableView: tableView, indexPath: indexPath)
        if let dto = presenter.itemForRowAt(row: indexPath.row) {
            cell.fill(dto: dto)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let object = presenter.objectDetail(row: indexPath.row) {
            navigationDelegate?.didSelectDetail(object)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        let loadingThreshold: CGFloat = 60
        
        if offsetY > contentHeight - height + loadingThreshold {
            if !isLoading {
                loadContent()
            }
        }
    }
}

// MARK: - Presenter output protocol

extension HomeViewController: HomePresenterOutputProtocol {
    func didGetData() {
        performUIUpdate {
            self.tableView.reloadData()
            self.hideLoadingView()
            self.isLoading = false
        }
    }
    
    func errorGettingData(error: NetworkError) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        performUIUpdate {
            self.present(alertController, animated: true)
        }
    }
}
