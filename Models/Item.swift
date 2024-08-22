
import Foundation
import SwiftData

@available(iOS 17, *)
@Model
final class Item: Hashable {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.timestamp == rhs.timestamp
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(timestamp)
    }
}
