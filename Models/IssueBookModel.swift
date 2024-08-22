import Foundation



struct userIssueBookRequest: Identifiable {
    let id = UUID()
    let title: String
    let requestId: String
    var status: RequestStatus
    var dueDate: String?
    var time: String?
    var image: String?
}

enum RequestStatus {
    case pending
    case declined
    case accepted
}

