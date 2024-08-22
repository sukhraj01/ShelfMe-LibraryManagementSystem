import SwiftUI

struct BookAcceptView: View {
    let bookRequest: BookR
    @State private var isAccepted: Bool = false // Track acceptance state
    
    var body: some View {
        
        VStack {
            VStack(alignment: .center, spacing: 10) {
//                if let imageUrlString = bookRequest.bookImageUrl, let imageURL = URL(string: imageUrlString){
//                    AsyncImage(url: imageURL) { phase in
//                        if let image = phase.image {
//                            image
//                                .resizable() // Make the image resizable
//                                .aspectRatio(contentMode: .fit) // Maintain aspect ratio
//                                .cornerRadius(8)
//                        } else if phase.error != nil {
//                            // Handle error
//                            Text("Failed to load image")
//                        } else {
//                            // Placeholder while loading
//                            ProgressView()
//                        }
//                    }
                }
                Text(bookRequest.bookName) // Book Name
                    .font(.title)
                    .fontWeight(.bold)
                Text(bookRequest.status) // Name of Author of Book
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 20)
            
            Form {
                Section {
                    HStack {
                        Text("Book Id")
                        Spacer()
                        Text("18263")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Member name")
                        Spacer()
                        Text(bookRequest.userName)
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Member Id")
                        Spacer()
                        Text("9238")
//                        Text(bookRequest.user)
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Limit ")
                        Spacer()
                        Text("15 Days") // Static date for now
                            .foregroundColor(.gray)
                    }
                }
                
                Section {
                    HStack {
                        Text("ISBN")
                        Spacer()
                        Text("1234567890123")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Category")
                        Spacer()
                        Text("Non-fiction")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Price")
                        Spacer()
                        Text("Rs. \(String(describing: bookRequest.bookId))")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Location")
                        Spacer()
                        Text(" \(bookRequest.user) ")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.top, 10)
            
            HStack(spacing: 20) {
                Button(action: {
                    // Accept action
                    approveRequest(userId: bookRequest.user, bookId: bookRequest.bookId) { result in
                            switch result {
                            case .success(let message):
                                print(message) // Handle success
                                self.isAccepted = true
                            case .failure(let error):
                                print(error.localizedDescription) // Handle error
                            }
                        }
                }) {
                    Text(isAccepted ? "Accepted" : "Accept") // Change text based on state
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(isAccepted ? Color.gray : Color.green) // Change color if already accepted
                                            .cornerRadius(10)
                }
                Button(action: {
                    // Reject action
                    rejectRequest(userId: bookRequest.user, bookId: bookRequest.bookId) { result in
                            switch result {
                            case .success(let message):
                                print(message) // Handle success
                            case .failure(let error):
                                print(error.localizedDescription) // Handle error
                            }
                        }
                }) {
                    Text("Reject")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        //        .navigationTitle(bookRequest.memberName)
    }
    
  

    func approveRequest(userId: String, bookId: String, completionHandler: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "https://lms-hgdf.onrender.com/api/v1/book/approveRequest/\(userId)/\(bookId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: String] = [
            "status": "approved" // or "rejected" as needed
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            completionHandler(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                completionHandler(.failure(error ?? URLError(.unknown)))
                return
            }

            if (200..<300).contains(httpResponse.statusCode) {
                // Successfully approved or rejected request
                completionHandler(.success("Request processed successfully"))
            } else {
                // Error occurred
                let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                completionHandler(.failure(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
            }
        }

        task.resume()
    }
    
    func rejectRequest(userId: String, bookId: String, completionHandler: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "https://lms-hgdf.onrender.com/api/v1/book/approveRequest/\(userId)/\(bookId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: String] = [
            "status": "rejected" // or "rejected" as needed
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            completionHandler(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                completionHandler(.failure(error ?? URLError(.unknown)))
                return
            }

            if (200..<300).contains(httpResponse.statusCode) {
                // Successfully approved or rejected request
                completionHandler(.success("Request processed successfully"))
            } else {
                // Error occurred
                let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                completionHandler(.failure(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
            }
        }

        task.resume()
    }

