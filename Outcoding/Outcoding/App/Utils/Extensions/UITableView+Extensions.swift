
import Foundation
import UIKit

extension UITableView {
    
    func registerCell(identifier: String) {
        register(UINib(nibName: identifier, bundle: Bundle.main), forCellReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterView(identifier: String) {
        register(UINib(nibName: String(describing: identifier), bundle: nil), forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    public func registerCell(identifier: String, bundle: Bundle) {
        register(UINib(nibName: identifier, bundle: bundle), forCellReuseIdentifier: identifier)
    }
}
