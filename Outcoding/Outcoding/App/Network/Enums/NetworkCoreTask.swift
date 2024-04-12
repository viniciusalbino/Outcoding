
import Foundation

enum NetworkCoreTask {
    case requestPlain
    case requestParameters(parameters: [String: String])
    case requestCompositeBodyData(data: Data, urlParameters: [String: String])
}
