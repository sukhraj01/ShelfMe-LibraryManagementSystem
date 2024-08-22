import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    @State private var isShowingScanner = false
    @State private var scannedCode: String?
//    @State private var fetchedData: FetchedDataResponse?
//    @State private var errorMessage: String?
//    @State private var hasFetchedData = false
    @EnvironmentObject var dataManager: DataManager
    
    var filteredNewReleases: [NewRelease] {
        if searchText.isEmpty {
            return popularNewReleases
        } else {
            return popularNewReleases.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var filteredSuggestedSearches: [SuggestedSearch] {
        guard let fetchedData = dataManager.fetchedData else {
                    return []
                }
                return fetchedData.books.map { book in
                    let imageUrl = book.imageUrl ?? "placeholderImage"
                    return SuggestedSearch(imageName: imageUrl, title: book.name, author: book.author, description: book.description)
                }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        TextField("Search", text: $searchText)
                            .padding(7)
                            .padding(.horizontal, 25)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal, 10)
                            .overlay(
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 16)

                                    if !searchText.isEmpty {
                                        Button(action: {
                                            self.searchText = ""
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                                .padding(.trailing, 16)
                                        }
                                    }
                                }
                            )

                        Button(action: {
                            isShowingScanner = true
                        }) {
                            Image(systemName: "qrcode.viewfinder")
                                .font(.title)
                                .padding(.trailing, 10)
                        }
                        .sheet(isPresented: $isShowingScanner) {
                            BarcodeScannerView { code in
                                self.scannedCode = code
                                self.searchText = code
                                self.isShowingScanner = false
                                // Perform search with the scanned code
                                searchBook(by: code)
                            }
                        }
                    }
                    .padding([.top, .horizontal])

//                    Text("Popular new releases")
//                        .font(.title)
//                        .padding([.leading, .top])
//
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 10) {
//                            ForEach(filteredNewReleases) { release in
//                                NewReleaseView(imageName: release.imageName, title: release.title, author: release.author, rating: release.rating)
//                            }
//                        }
//                        .padding(.horizontal)
//                    }

                    Text("Suggested searches")
                        .font(.title)
                        .padding([.leading, .top])

                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(filteredSuggestedSearches) { search in
                            if let book = dataManager.fetchedData?.books.first(where: { $0.name == search.title && $0.author == search.author }) {
                                SuggestedSearchView(book: book)
                            }
                        }
                    }

                    .padding(.horizontal)
                }
            }
            .navigationBarTitle(Text("Discover"))
            
        }
        .navigationBarBackButtonHidden(true)
    }
    
    

    private func searchBook(by code: String) {
        // Implement your search logic here using the scanned barcode
        // For example, you might query an API or a local database
        print("Searching for book with code: \(code)")
    }
}



// Views for displaying NewRelease and SuggestedSearch
struct NewReleaseView: View {
    var imageName: String?
    var title: String
    var author: String
    var rating: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if let imageUrlString = imageName, let imageUrl = URL(string: imageUrlString) {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: 150, height: 200)
                            .cornerRadius(10)
                    case .failure(_):
                        // Placeholder image if loading fails
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 150, height: 200)
                            .cornerRadius(10)
                    case .empty:
                        // Placeholder image while loading
                        ProgressView()
                    @unknown default:
                        // Placeholder image for unknown cases
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 150, height: 200)
                            .cornerRadius(10)
                    }
                }
            } else {
                // Placeholder image if imageName is nil
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 150, height: 200)
                    .cornerRadius(10)
            }
            Text(title)
                .font(.headline)
                .lineLimit(2)
                .padding(.top, 5)
            Text(author)
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack(spacing: 2) {
                ForEach(0..<5) { star in
                    Image(systemName: star < Int(rating) ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
                Text(String(format: "%.1f", rating))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 150)
    }
}



struct SuggestedSearchView: View {
    
    var book: Book
//    var imageUrl: String
//    var title: String
//    var author: String
//    var description : String

    @State private var image: UIImage?

    var body: some View {
        
        NavigationLink(destination: BookDetailView(book: book)) {
            HStack(spacing: 10) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 50, height: 70)
                        .cornerRadius(5)
                } else {
                    Image("placeholderImage") // Placeholder image
                        .resizable()
                        .frame(width: 50, height: 70)
                        .cornerRadius(5)
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text(book.name)
                        .font(.headline)
                    Text(book.author)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .onAppear {
                if let imageUrl = book.imageUrl {
                                    loadImage(from: imageUrl)
                                }
            }
        }}

    private func loadImage(from url: String) {
        guard let imageUrl = URL(string: url) else {
            return
        }

        URLSession.shared.dataTask(with: imageUrl) { data, _, error in
            if let data = data, let loadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = loadedImage
                }
            }
        }.resume()
    }
}
