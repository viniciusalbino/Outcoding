
import Foundation
import UIKit

struct SearchDTO {
    var page: Int
    var order: String = "RAND"
    var limit: Int = 10
    
    func asParameters() -> [String: String] {
        return [
            "page": String(page),
            "order": order,
            "limit": String(limit)
        ]
    }
}
