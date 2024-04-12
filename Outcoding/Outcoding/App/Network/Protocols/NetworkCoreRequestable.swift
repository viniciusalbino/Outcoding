
import Foundation

protocol NetworkCoreRequestable {
    associatedtype DataType: Codable
    
    var network: NetworkCore { get }
    
    var endpoint: NetworkCoreEndpoint { get }
    
    func request() async throws -> DataType
}
