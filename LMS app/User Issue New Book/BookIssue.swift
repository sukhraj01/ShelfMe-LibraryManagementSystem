import SwiftUI

struct BookIssueView: View {
    @State private var bookId: String = ""
    @State private var isBookFound: Bool = false
    @State private var searchedBook: Book?
    @State private var isSubmitting: Bool = false
    @State private var buttonText: String = "Submit Request"
    @State private var bookDatabaseID: String = ""
    @State private var isScannerPresented: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        TextField("Enter Book ISBN", text: $bookId)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        Button(action: { fetchData(bookId: bookId) }) {
                            Image(systemName: "magnifyingglass")
                                .padding()
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)

                    if let fetchedData = searchedBook {
                        // Display book details
                        AsyncImage(url: URL(string: fetchedData.imageUrl ?? "")) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 200, height: 300)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 200, height: 300)
                                    .padding(.top, 40)
                                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
                                    .overlay(
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .background(
                                                Color.white
                                                    .opacity(0.2)
                                                    .blur(radius: 10)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                            )
                                    )
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 200, height: 300)
                            @unknown default:
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 200, height: 300)
                            }
                        }
                        .zIndex(1)

                        Text(fetchedData.name)
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text("#\(bookId)")
                            .foregroundColor(.gray)

                        VStack(spacing: 0) {
                            DetailRow(label: "Author", value: fetchedData.author)
                            Divider().background(Color.gray)
                            // DetailRow(label: "Publisher", value: details.publisher)
                            Divider().background(Color.gray)
                            DetailRow(label: "Price", value: "100")
                            Divider().background(Color.gray)
                            DetailRow(label: "Language", value: "Hindi")
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)

                        Button(action: {
                            if let savedUserDatabaseID = UserDefaults.standard.string(forKey: "userDatabaseBaseId") {
                                print("User Data Base Id : \(String(describing: savedUserDatabaseID))")

                                submitRequest(bookId: bookDatabaseID, userId: savedUserDatabaseID)
                                print("Book Data base Id: \(bookDatabaseID)")
                            }
                        }) {
                            Text("\(buttonText)")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        .padding(.bottom, 20)
                    } else if isBookFound {
                        // Loading indicator or other UI while searching
                        Text("Loading...")
                            .padding()
                    } else {
                        // No book found message based on search action
                        if !bookId.isEmpty {
                            Text("Book not found")
                                .foregroundColor(.red)
                                .padding()
                        }
                    }
                }
                .navigationBarTitle("Request Book")
                .navigationBarTitleDisplayMode(.large)
                
                .navigationBarItems(trailing:Button(action: {
                    isScannerPresented = true
                }) {
                    Image(systemName: "barcode.viewfinder")
                        .imageScale(.large)
                })
            }
            .sheet(isPresented: $isScannerPresented) {
                BarcodeScannerView(didFindCode: { code in
                    bookId = code
                    isScannerPresented = false
                    fetchData(bookId: bookId)
                })
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Ensures large titles are supported
    }

    func fetchData(bookId: String) {
        guard let url = URL(string: "https://lms-hgdf.onrender.com/api/v1/book/oneid/\(bookId)") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.isBookFound = false // No book found if data is nil
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                do {
                    let fetchedData = try JSONDecoder().decode(Book.self, from: data)
                    DispatchQueue.main.async {
                        self.searchedBook = fetchedData
                        self.bookDatabaseID = fetchedData._id
                        self.isBookFound = true // Book found
                    }
                } catch {
                    print("Decoding error: \(error)")
                    DispatchQueue.main.async {
                        self.isBookFound = false // Error decoding
                    }
                }
            } else {
                if let errorDataString = String(data: data, encoding: .utf8) {
                    print("Server error: \(errorDataString)")
                } else {
                    print("Unknown server error")
                }
                DispatchQueue.main.async {
                    self.isBookFound = false // Server error
                }
            }
        }.resume()
    }

    func submitRequest(bookId: String, userId: String) {
        guard let url = URL(string: "https://lms-hgdf.onrender.com/api/v1/book/createRequest/\(userId)/\(bookId)") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    // Handle error
                }
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received JSON data: \(jsonString)")
            }

            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode

                if (200...299).contains(statusCode) {
                    // Request was successful
                    self.buttonText = "Request Submitted"
                    print("Request sent successfully")
                } else if statusCode == 400 {
                    // Bad Request
                    self.buttonText = "Already"
                    print("Bad Request: \(statusCode)")
                } else {
                    // Other HTTP status codes
                    print("HTTP status code: \(statusCode)")
                }
            }
        }.resume()
    }
}

struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 10)
    }
}

struct BookIssueView_Previews: PreviewProvider {
    static var previews: some View {
        BookIssueView()
    }
}
