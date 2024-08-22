import Foundation

struct AllRequests: Decodable {
    let userIssueBookRequest: [UserIssueBookRequest]
}


struct UserIssueBookRequest: Decodable {
    let _id: String
    let book: Book
    let id: Int
    let user: User
    let status: String
    let createdAt: String
    let updatedAt: String
    let __v: Int
}



struct Issue: Decodable {
    let book: String
    let uniqueId: Int
    let _id : String

    enum CodingKeys: String, CodingKey {
        case book, uniqueId, _id
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.book = try container.decode(String.self, forKey: .book)
        self.uniqueId = try container.decode(Int.self, forKey: .uniqueId)
        self._id = try container.decode(String.self, forKey: ._id)
    }
}






struct User: Decodable {
    let name: String?
    let email: String
    let password: String
    let accountType: String
    let active: Bool
    let approved: Bool
    let issuedBooks: [Issue]
    let fine: Int
    let _id: String
    let createdAt: Date
    let updatedAt: Date
    let __v: Int

    enum CodingKeys: String, CodingKey {
        case name, email, password, accountType, active, approved, issuedBooks, fine, _id, createdAt, updatedAt, __v
    }

    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
            email = try container.decode(String.self, forKey: .email)
            password = try container.decode(String.self, forKey: .password)
            accountType = try container.decode(String.self, forKey: .accountType)
            active = try container.decode(Bool.self, forKey: .active)
            approved = try container.decode(Bool.self, forKey: .approved)
            // Decode issuedBooks array
            issuedBooks = try container.decode([Issue].self, forKey: .issuedBooks)
            fine = try container.decode(Int.self, forKey: .fine)
            _id = try container.decode(String.self, forKey: ._id)
            __v = try container.decode(Int.self, forKey: .__v)

            // Handle date decoding
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            if let createdAtString = try container.decodeIfPresent(String.self, forKey: .createdAt),
               let createdAtDate = dateFormatter.date(from: createdAtString) {
                createdAt = createdAtDate
            } else {
                throw DecodingError.dataCorruptedError(forKey: .createdAt, in: container, debugDescription: "Date string not found or invalid")
            }
            
            if let updatedAtString = try container.decodeIfPresent(String.self, forKey: .updatedAt),
               let updatedAtDate = dateFormatter.date(from: updatedAtString) {
                updatedAt = updatedAtDate
            } else {
                throw DecodingError.dataCorruptedError(forKey: .updatedAt, in: container, debugDescription: "Date string not found or invalid")
            }
        }
}



struct UserRegistrationResponse: Decodable {
    let success: Bool
    let user: User
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case success, user, message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decode(Bool.self, forKey: .success)
        self.message = try container.decode(String.self, forKey: .message)
        self.user = try container.decode(User.self, forKey: .user)
    }
}

