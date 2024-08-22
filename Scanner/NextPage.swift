import SwiftUI

struct Book7: Codable, Identifiable {
    let bookName: String
    let bookIsbn: Int
    let book: String
    let status: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case bookName
        case bookIsbn
        case book
        case status
        case id = "_id"
    }
}



struct DetailView: View {
    let scannedCode: String
    @State private var books: [Book7] = []
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
            } else {
                List(filteredBooks) { book in
                    HStack {
                        Image("Book1")
                            .resizable()
                            .frame(width: 50, height: 70)
                            .cornerRadius(5)
                        VStack(alignment: .leading) {
                            Text(book.bookName)
                                .font(.headline)
                            Text("ISBN: \(book.bookIsbn)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            HStack {
                                Button(action: {
                                    // Return book action
                                    submitBook(userId: scannedCode, bookId: book.book) { result in
                                        switch result {
                                        case .success(let message):
                                            // Handle success
                                            print("Success: \(message)")
                                        case .failure(let error):
                                            // Handle failure
                                            print("Error: \(error.localizedDescription)")
                                        }
                                    }
                                    fetchUser(id: scannedCode)
                                    
                                }) {
                                    Text("Return")
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                        .padding(.vertical, 5)
                                        .background(Color.green)
                                        .cornerRadius(5)
                                }
                                Button(action: {
                                    submitBook(userId: scannedCode, bookId: book.book) { result in
                                        switch result {
                                        case .success(let message):
                                            // Handle success
                                            print("Success: \(message)")
                                        case .failure(let error):
                                            // Handle failure
                                            print("Error: \(error.localizedDescription)")
                                        }
                                    }
//                                    fetchUser(id: scannedCode)
                                    fetchUser(id: scannedCode)
                                    
                                    // Report book action
                                }) {
                                    Text("Report")
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                        .padding(.vertical, 5)
                                        .background(Color.red)
                                        .cornerRadius(5)
                                }
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Book List")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchUser(id: scannedCode)
        }
    }
    
    func submitBook(userId: String, bookId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "https://lms-hgdf.onrender.com/api/v1/book/submitRequest/\(userId)/\(bookId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                }
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                completion(.success("Book submitted successfully"))
            } else {
                if let errorData = String(data: data, encoding: .utf8) {
                    completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorData])))
                } else {
                    completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                }
            }
        }.resume()
    }
    
    
    
    func fetchUser(id: String){
        print("inside fetching user detail.....")
        guard let url = URL(string: "https://lms-hgdf.onrender.com/api/v1/auth/user/\(id)") else {
                return
            }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse,
               (200...299).contains(httpResponse.statusCode) {
                do {
    
                    let fetchedData = try JSONDecoder().decode([Book7].self, from: data)
                    DispatchQueue.main.async {
                        print("Data from backend:")
//                        print(fetchedData)
                        self.books = fetchedData
                        print(self.books)
                        self.isLoading = false
                                            

                    }
                } catch {
                    print("Decoding error: \(error)")
                    DispatchQueue.main.async {

                    }
                }
            } else {
                if let errorDataString = String(data: data, encoding: .utf8) {
                    print("Server error: \(errorDataString)")
                    DispatchQueue.main.async {
                    }
                } else {
                    print("Unknown server error")
                    DispatchQueue.main.async {
                    }
                }
            }
        }.resume()
    }
    
    private var filteredBooks: [Book7] {
            return books.filter { $0.status == "approved" }
        }
    
    
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(scannedCode: "sampleCode")
    }
}
