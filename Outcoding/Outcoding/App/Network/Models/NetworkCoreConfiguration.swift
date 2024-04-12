
import Foundation

struct NetworkCoreConfiguration {
    let logType: NetworkCoreLogType
    let urlSessionConfiguration: URLSessionConfiguration
    let requestTimeout: Double
    let waitsForConnectivity: Bool
    
    init(logType: NetworkCoreLogType = .min,
         urlSessionConfiguration: URLSessionConfiguration = .default,
         requestTimeout: Double = 60,
         waitsForConnectivity: Bool = true) {
        
        self.logType = logType
        self.requestTimeout = requestTimeout
        self.waitsForConnectivity = waitsForConnectivity
        
        self.urlSessionConfiguration = urlSessionConfiguration
        self.urlSessionConfiguration.waitsForConnectivity = waitsForConnectivity
        self.urlSessionConfiguration.timeoutIntervalForRequest = requestTimeout
    }
}
