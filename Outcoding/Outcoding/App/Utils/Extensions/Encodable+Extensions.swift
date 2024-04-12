
import Foundation

extension Encodable {
    func encoded() -> Data {
        guard let encoded = try? JSONEncoder().encode(self) else {
            return Data()
        }
        return encoded
    }
}
