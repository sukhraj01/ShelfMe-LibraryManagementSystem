import SwiftUI

struct BookR: Identifiable, Decodable {
    let bookName: String
    let bookIsbn: Int
    let status: String
    let id: String
    let bookId: String
    let user: String
    let userName: String
    let bookImageUrl: String

    enum CodingKeys: String, CodingKey {
        case bookName
        case bookIsbn
        case status
        case id
        case bookId = "bookId" // Update the key name here
        case user
        case userName
        case bookImageUrl
    }
}


class BookRequestViewModel: ObservableObject {
    @Published var bookRequests: [BookR] = []
    
    @Published var searchText = ""
    
    
    func fetchData() {
        guard let url = URL(string: "https://lms-hgdf.onrender.com/api/v1/book/requests") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                let decodedData = try JSONDecoder().decode([BookR].self, from: data)
                DispatchQueue.main.async {
                    self.bookRequests = decodedData
                    print(self.bookRequests)
                    print("wed")
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }

        }.resume()
    }
    
    init() {
        fetchData()
    }
    
    var filteredBookRequests: [BookR] {
        if searchText.isEmpty {
            return bookRequests
        }
        return bookRequests
    
    }
    
    
}
