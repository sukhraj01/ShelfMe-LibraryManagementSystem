// Event Model

import SwiftUI


struct Event: Codable,Identifiable {
    var def = UUID()
    var id: String
    var imageName: String
    var name: String
    var startDate: Date
    var endDate: Date
    var time: String
    var language: String
    var genre: String
    var description: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case imageName
        case name = "title"
        case startDate
        case endDate
        case time
        case language
        case genre
        case description
    }

    // Initializer for decoding from JSON
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        imageName = try container.decode(String.self, forKey: .imageName)
        name = try container.decode(String.self, forKey: .name)
        time = try container.decode(String.self, forKey: .time)
        language = try container.decode(String.self, forKey: .language)
        genre = try container.decode(String.self, forKey: .genre)
        description = try container.decode(String.self, forKey: .description)

        // Handle date decoding
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        // Decode startDate
        let startDateString = try container.decode(String.self, forKey: .startDate)
        if let startDate = dateFormatter.date(from: startDateString) {
            self.startDate = startDate
        } else {
            throw DecodingError.dataCorruptedError(forKey: .startDate, in: container, debugDescription: "Date string does not match expected format.")
        }

        // Decode endDate
        let endDateString = try container.decode(String.self, forKey: .endDate)
        if let endDate = dateFormatter.date(from: endDateString) {
            self.endDate = endDate
        } else {
            throw DecodingError.dataCorruptedError(forKey: .endDate, in: container, debugDescription: "Date string does not match expected format.")
        }
    }

    // Initializer for manual initialization (not used for decoding)
    init(id: String, imageName: String, name: String, startDate: Date, endDate: Date, time: String, language: String, genre: String, description: String) {
        self.id = id
        self.imageName = imageName
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.time = time
        self.language = language
        self.genre = genre
        self.description = description
    }
}


// Sample Data
//let sampleEvents = [
//    Event(
//
//        imageName: "event2", // Name of the image in the asset catalog
//        name: "Storytelling",
//        startDate: Date(timeIntervalSince1970: 1716019200),
//        endDate: Date(timeIntervalSince1970: 1719811200),
//        time: "6:00 PM",
//        language: "English",
//        genre: "Comedy",
//        description: """
//        Join us for our weekly Library Storytime! This engaging event is designed for young children and their caregivers. Gather around in our cozy reading area as our skilled librarian reads a selection of delightful and entertaining books.
//        """
//    ),
//]
