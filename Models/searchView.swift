//
//  searchView.swift
//  LMS app
//
//  Created by Dr.mac on 03/06/24.
//

import Foundation

struct NewRelease: Identifiable {
    let id = UUID()
    var imageName: String? // Change to optional String
    var title: String
    var author: String
    var rating: Double
    var ratingsCount: Int
}


struct SuggestedSearch: Identifiable {
    let id = UUID()
    var imageName: String
    var title: String
    var author: String
    var description: String
}

let popularNewReleases = [
    NewRelease(imageName:"https://m.media-amazon.com/images/I/71kYd+xNMpL._AC_UF1000,1000_QL80_.jpg", title: "Girl in Room", author: "By Chetan Bhagat", rating: 4.5, ratingsCount: 93),
    NewRelease(imageName: "https://m.media-amazon.com/images/I/71kYd+xNMpL._AC_UF1000,1000_QL80_.jpg", title: "The Night Circus", author: "Erin Morgenstern", rating: 4, ratingsCount: 50),
    NewRelease(imageName: "https://m.media-amazon.com/images/I/71kYd+xNMpL._AC_UF1000,1000_QL80_.jpg", title: "The Kite Runner", author: "Khaled Hosseini", rating: 4.5, ratingsCount: 52)
]
