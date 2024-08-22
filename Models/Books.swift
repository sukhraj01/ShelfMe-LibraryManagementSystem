//Testing collaboration by yogesh

import Foundation
import SwiftUI

struct FetchedDataResponse: Decodable {
    let books: [Book]
}

struct Book: Decodable, Hashable {
    let _id: String
        let name: String
        let description: String
        let author: String
        let isbn: Int
        let category: String
        let rackNo: Int
        let duration: Int
        let price: Int
        let imageUrl: String?
    let quantity: Int
        let __v: Int

    // Custom implementation of Hashable protocol
    func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
    }

    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs._id == rhs._id
    }
    
//    enum CodingKeys: String, CodingKey {
//            case _id
//            case name
//            case description
//            case author
//            case isbn
//            case category
//            case rackNo
//            case duration
//            case price
//            case imageUrl
//            case uniqueIds  // Add uniqueIds case
//        }
//
//    init(from decoder: Decoder) throws {
//            let container = try decoder.container(keyedBy: CodingKeys.self)
//            _id = try container.decode(String.self, forKey: ._id)
//            name = try container.decode(String.self, forKey: .name)
//            description = try container.decode(String.self, forKey: .description)
//            author = try container.decode(String.self, forKey: .author)
//            isbn = try container.decode(Int.self, forKey: .isbn)
//            category = try container.decode(String.self, forKey: .category)
//            rackNo = try container.decode(Int.self, forKey: .rackNo)
//            duration = try container.decode(Int.self, forKey: .duration)
//            price = try container.decode(Int.self, forKey: .price)
//            imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
//            uniqueIds = try container.decode([Int].self, forKey: .uniqueIds)  // Decode uniqueIds
//        }
}
