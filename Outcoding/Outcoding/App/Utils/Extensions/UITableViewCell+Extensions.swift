
import Foundation
import UIKit

extension UITableViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    class func createCell<T: UITableViewCell>(tableView: UITableView, indexPath: IndexPath) -> T {
        return tableView.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
    }
}
