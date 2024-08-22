import SwiftUI

struct BookReturnView: View {
    @State private var bookId: String = ""
    @State private var isBookDefaced: Bool = false
    @State private var isBookFound: Bool = false
    @State private var bookDetails: BookDetails?
    
    struct BookDetails {
        let title: String
        let issuedBy: String
        let memberId: Int
        let issueDate: String
        let dueDate: String
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        TextField("Enter Book ID", text: $bookId)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .onChange(of: bookId) { newValue in
                                searchBook()
                            }
                        
                        Button(action: searchBook) {
                            Image(systemName: "magnifyingglass")
                                .padding()
                        }
                    }
                    .padding(.top, 20)
                    
                    if isBookFound, let details = bookDetails {
                        Image("book_cover") // Replace with actual image asset name
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                            .padding(.bottom, -20) // Set space after image to 10
                        
                        VStack(spacing: 7) {
                            Text(details.title)
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("#\(bookId)")
                                .foregroundColor(.gray)
                        }
                        
                        VStack(spacing: 10) {
                            HStack {
                                Text("Name")
                                Spacer()
                                Text(details.issuedBy)
                                    .foregroundColor(.gray)
                            }
                            HStack {
                                Text("Member id")
                                Spacer()
                                Text(String(details.memberId))
                                    .foregroundColor(.gray)
                            }
                            HStack {
                                Text("Issue date")
                                Spacer()
                                Text(formatDate(details.issueDate))
                                    .foregroundColor(.blue)
                            }
                            HStack {
                                Text("Due date")
                                Spacer()
                                Text(formatDate(details.dueDate))
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        Toggle(isOn: $isBookDefaced) {
                            Text("Is the book defaced?")
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        Button(action: {
                            // Return book action
                        }) {
                            Text("Return")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        .padding(.bottom, 20)
                    } else if !bookId.isEmpty {
                        Text("Book not found")
                            .foregroundColor(.red)
                    }
                }
                .navigationTitle("Return Book")
                .navigationBarTitleDisplayMode(.large)
            }
        }
    }
    
    private func searchBook() {
        // Replace with actual search logic
        if bookId == "73336" {
            bookDetails = BookDetails(
                title: "Court Of Silver",
                issuedBy: "Aayush",
                memberId: 8797,
                issueDate: "23 MAY 2023",
                dueDate: "10 JUN 2023"
            )
            isBookFound = true
        } else {
            isBookFound = false
            bookDetails = nil
        }
    }
    
    private func formatDate(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        guard let date = dateFormatter.date(from: date) else { return date }
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
}
