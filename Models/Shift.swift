import Foundation

struct Shift: Identifiable {
    var id = UUID()
    var date: Date
    var startTime: Date
    var finishTime: Date
    var location: String
    var days: String
}
