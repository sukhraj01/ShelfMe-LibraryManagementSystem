import UIKit

struct Librarian: Identifiable {
    var id: UUID
    var username: String
    var name: String
    var email: String
    var librarianID: String
    var role: String
    var isActive: Bool
    var password: String
    var isPasswordSet: Bool
    var profilePic: UIImage?
    var phoneNumber: String?
    var accountCreationDate: Date
    var isEnabled: Bool
    var gender: String
    var address: String


    

    init(id: UUID = UUID(),
         username: String,
         name: String,
         email: String,
         librarianID: String,
         role: String,
         isActive: Bool,
         password: String,
         isPasswordSet: Bool,
         profilePic: UIImage? = nil,
         phoneNumber: String? = nil,
         accountCreationDate: Date = Date(),
         gender: String,
         address: String,
         isEnabled: Bool = true) {
        self.id = id
        self.username = username
        self.name = name
        self.email = email
        self.librarianID = librarianID
        self.role = role
        self.isActive = isActive
        self.password = password
        self.isPasswordSet = isPasswordSet
        self.profilePic = profilePic
        self.phoneNumber = phoneNumber
        self.accountCreationDate = accountCreationDate
        self.gender = gender
        self.address = address
        self.isEnabled = isEnabled
    }


}
