//
//  Login.swift
//  LMS app
//
//  Created by aaa on 04/06/24.
//

import Foundation
import SwiftUI
import Combine

struct IssuedBook: Decodable {
    let book: String
    let status: String
    let _id: String
}

struct LoginResponse: Decodable {
    let success: Bool
    let user: LoggedInUser
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case success, user, message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decode(Bool.self, forKey: .success)
        self.message = try container.decode(String.self, forKey: .message)
        self.user = try container.decode(LoggedInUser.self, forKey: .user)
    }
}

struct LoggedInUser: Decodable {
    let name: String
    let email: String
    let accountType: String
    let active: Bool
    let approved: Bool
    let issuedBooks: [IssuedBook]
    let fine: Int
    let _id: String
    let createdAt: Date
    let updatedAt: Date
    let __v: Int
    let token: String

    enum CodingKeys: String, CodingKey {
        case name, email, accountType, active, approved, issuedBooks, fine, _id, createdAt, updatedAt, __v, token
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        accountType = try container.decode(String.self, forKey: .accountType)
        active = try container.decode(Bool.self, forKey: .active)
        approved = try container.decode(Bool.self, forKey: .approved)
        issuedBooks = try container.decode([IssuedBook].self, forKey: .issuedBooks) // Decode as [IssuedBook]
        fine = try container.decode(Int.self, forKey: .fine)
        _id = try container.decode(String.self, forKey: ._id)
        __v = try container.decode(Int.self, forKey: .__v)
        token = try container.decode(String.self, forKey: .token)

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

struct IssuedBook2: Decodable {
    let book: String
    let status: String
    let _id: String
    let bookName: String
    let bookIsbn : Int
}


struct User2: Decodable {
    let name: String
    let email: String
    let password: String
    let accountType: String
    let active: Bool
    let approved: Bool
    let issuedBooks: [IssuedBook2]
    let fine: Int
    let _id: String
    let createdAt: Date
    let updatedAt: Date
    let __v: Int

    enum CodingKeys: String, CodingKey {
        case name, email, accountType, active, approved, issuedBooks, fine, _id, createdAt, updatedAt, __v, password
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        password = try container.decode(String.self, forKey: .password)
        email = try container.decode(String.self, forKey: .email)
        accountType = try container.decode(String.self, forKey: .accountType)
        active = try container.decode(Bool.self, forKey: .active)
        approved = try container.decode(Bool.self, forKey: .approved)
        issuedBooks = try container.decode([IssuedBook2].self, forKey: .issuedBooks)// Decode as [IssuedBook]
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
