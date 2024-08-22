import SwiftUI

struct LibrarianBookListView: View {
    @EnvironmentObject var dataManager: DataManager
    
    
    @State private var searchText = ""
    
    @State private var showingAddBook = false
    
    var filteredBooks: [Book] {
        let searchTextTrimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        if searchTextTrimmed.isEmpty {
            print("Ehjbfe")
            print(dataManager.fetchedData?.books)
            return dataManager.fetchedData?.books ?? []
        } else {
            return (dataManager.fetchedData?.books ?? []).filter { book in
                let titleMatch = book.name.lowercased().contains(searchTextTrimmed)
                let authorMatch = book.author.lowercased().contains(searchTextTrimmed)
                let isbnMatch = String(book.isbn).contains(searchTextTrimmed) // Convert ISBN to string before checking
                let categoryMatch = book.category.lowercased().contains(searchTextTrimmed)
                let notesMatch = book.description.lowercased().contains(searchTextTrimmed) // Assuming description is the notes field
                
                return titleMatch || authorMatch || isbnMatch || categoryMatch || notesMatch
            }
        }
    }
    
    
    var body: some View {
        var imageWidth: CGFloat = 50
        var imageHeight: CGFloat = 50
        VStack {
                    SearchBar(text: $searchText)
            List {
                            ForEach(filteredBooks.indices, id: \.self) { index in
                                let book = filteredBooks[index]
                                NavigationLink(
                                    destination: LibrarianBookDetailView(book: book)
                                )


 {
                                    HStack {
                                        // Display book information here
                                        if let imageUrlString = filteredBooks[index].imageUrl,
                                           let imageUrl = URL(string: imageUrlString) {
                                            AsyncImage(url: imageUrl) { phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView()
                                                        .frame(width: imageWidth, height: imageHeight)
                                                case .success(let image):
                                                    image.resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: imageWidth, height: imageHeight)
                                                        .clipped()
                                                        .cornerRadius(10)
                                                case .failure:
                                                    Image(systemName: "photo")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: imageWidth, height: imageHeight)
                                                        .clipped()
                                                        .cornerRadius(10)
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                        } else {
                                            Image(systemName: "photo")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: imageWidth, height: imageHeight)
                                                .clipped()
                                                .cornerRadius(10)
                                        }

                                        VStack(alignment: .leading) {
                                            Text(filteredBooks[index].name) // Use filteredBooks here instead of dataManager.fetchedData
                                                .font(.headline)
                                            Text(filteredBooks[index].author) // Use filteredBooks here instead of dataManager.fetchedData
                                                .font(.subheadline)
                                                .foregroundColor(.gray) // Make author name grey
                                            Text("ISBN No.- \(filteredBooks[index].isbn)") // Use filteredBooks here instead of dataManager.fetchedData
                                                .font(.subheadline)
                                                .foregroundColor(.gray) // Make ISBN number grey
                                        }
                                    }
                                }
                            }
                        }
                }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
            showingAddBook = true
        }) {
            Image(systemName: "plus")
        })
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Title")
                    .font(.headline)
            }
        }
        .sheet(isPresented: $showingAddBook) {
            LibrarianAddBookView()
        }
    }
}

struct LibrarianBookListView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .padding(.bottom, 4)
        }
    }
}
