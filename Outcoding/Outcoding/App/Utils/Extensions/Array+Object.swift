
import Foundation

extension Array {
    public func object(index: Int) -> Element? {
        if index >= 0 && index < self.count {
            return self[index]
        }
        return nil
    }
}
