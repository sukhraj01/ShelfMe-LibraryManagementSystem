//
//  UserData.swift
//  LMS app
//
//  Created by Dr.mac on 03/06/24.
//

import Foundation
import SwiftUI
import Combine

class UserData: ObservableObject {
    @Published var email: String = " "
}


// User Choose Categories

let userCategories = [
    "Litrature", "Tech", "Fiction", "Crime", "Mystery", "Comics",
    "NonFiction", "Thriller", "Horror", "Maths", "Satire", "Autobiography",
    "Paranormal", "Fairy Tale", "Emblem books", "Romance"
]
