
import Foundation

extension NetworkCore {
    static let defaultConfig = NetworkCoreConfiguration(logType: .min)
    static let defaultNetwork = NetworkCore(configuration: defaultConfig)
}

extension NetworkCoreEndpoint {
    var baseApiURL: String {
        return "https://api.thecatapi.com/v1"
    }
    
    var baseURL: URL {
        return URL(string: baseApiURL)!
    }
}
