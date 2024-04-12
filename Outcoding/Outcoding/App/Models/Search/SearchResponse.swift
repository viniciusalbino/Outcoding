
import Foundation
import UIKit

struct SearchResponse: Mappable {
    let breeds: [Breed]
    let categories: [Category]?
    let id: String
    let url: String
    let width: Int
    let height: Int
}
