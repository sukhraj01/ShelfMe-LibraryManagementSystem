import SwiftUI
import Foundation


struct LibraryData: Codable {
    let capacity: Int
    let total: Int
    let present: Int
    let users: [String]
}

struct LibraryDetail: Codable {
    let capacity: Int
    let present: Int
    let total: Int
}



struct HomeUIView: View {
    @State private var errorMessage: String?
    @State private var libraryDetail: LibraryDetail?
    @State private var fetchedData: FetchedDataResponse?
    
    var user : LoggedInUser
    
    
    @State private var hasFetchedData = false
    @EnvironmentObject var dataManager: DataManager
    
    @State var eventsToShow: [Event] = []
    
    @State private var showProfileView = false
    @State private var showVacantSeatsView = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ExperienceLiveEventsView(events: eventsToShow) // Add the static section here
                    SuggestionsView(fetchedData: fetchedData)
                }
                .padding(.top)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .navigationTitle("Home")
            .onAppear {
                fetchLibraryDetails()
                //                print("library dataaaaa heerererrererer")
                //                print(dataManager.libraryData)
                fetchAllEvents()
                if !hasFetchedData {
                    fetchData()
                    //                    fetchAllEvents()
                    hasFetchedData = true
                }
            } .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        showVacantSeatsView.toggle()
                    }) {
                        
                        Text("\((libraryDetail?.capacity ?? 100) - (libraryDetail?.present ?? 0))")
                        //                        Text(libraryDetail?.capacity)
                        
                        Image(systemName: "carseat.left.fill")
                            .foregroundColor(.black)
                    }
                    .sheet(isPresented: $showVacantSeatsView) {
                        
                        VacantSeatModalView(isPresented: $showVacantSeatsView)
                        
                    }
                    
                    Button(action: {
                        showProfileView.toggle()
                    }) {
                        Image(systemName: "person.circle")
                            .foregroundColor(.black)
                    }
                    .sheet(isPresented: $showProfileView) {
                        AccountView(user : user)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func fetchLibraryDetails() {
        guard let url = URL(string: "https://lms-hgdf.onrender.com/api/v1/library/detail") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedLibraryDetail = try JSONDecoder().decode(LibraryDetail.self, from: data)
                    DispatchQueue.main.async {
                        self.libraryDetail = decodedLibraryDetail
                        self.dataManager.libraryData = decodedLibraryDetail
                        // Print library details to console
                        print("Library Detail:")
                        print("Capacity: \(decodedLibraryDetail.capacity)")
                        print("Total: \(decodedLibraryDetail.total)")
                        print("Present: \(decodedLibraryDetail.present)")
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }.resume()
    }
    
    //    func fetchLibraryDetails() {
    //        guard let url = URL(string: "https://lms-hgdf.onrender.com/api/v1/library/detail") else {
    //            print("Invalid URL")
    //            return
    //        }
    //
    //        URLSession.shared.dataTask(with: url) { data, response, error in
    //            if let data = data {
    //                do {
    //                    let decodedLibraryDetail = try JSONDecoder().decode(LibraryDetail.self, from: data)
    //                    DispatchQueue.main.async {
    //                        self.libraryDetail = decodedLibraryDetail
    //                    }
    //                } catch {
    //                    print("Error decoding data: \(error)")
    //                }
    //            } else if let error = error {
    //                print("HTTP Request Failed \(error)")
    //            }
    //        }.resume()
    //    }
    
    
    func fetchData() {
        guard let url = URL(string: "https://lms-hgdf.onrender.com/api/v1/book/all") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = error?.localizedDescription ?? "Unknown error"
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               (200...299).contains(httpResponse.statusCode) {
                do {
                    let fetchedData = try JSONDecoder().decode(FetchedDataResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.fetchedData = fetchedData
                        self.dataManager.fetchedData = fetchedData
                        self.errorMessage = nil
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error decoding response: \(error.localizedDescription)"
                    }
                }
            } else {
                if let errorDataString = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.errorMessage = errorDataString
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Unknown error"
                    }
                }
            }
        }.resume()
    }
    
    // Fetch All the Evenets
    func fetchAllEvents() {
        guard let url = URL(string: "https://lms-hgdf.onrender.com/api/v1/event") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedEvents = try JSONDecoder().decode([Event].self, from: data)
                    DispatchQueue.main.async {
                        eventsToShow = decodedEvents
                        //                            print("Events in Backend : \(self.eventsToShow)")
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }.resume()
    }// fetch function ended
}

// Live Evenets View
struct ExperienceLiveEventsView: View {
    let events: [Event]
    
    var body: some View {
        SectionView(title: "Experience Live Events", showDisclosure: false) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(events) { event in
                        NavigationLink(destination: EventView(event: event)) {
                            VStack(alignment: .leading) {
                                AsyncImage(url: URL(string: event.imageName)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 250, height: 200)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 250, height: 200)
                                            .clipped()
                                            .cornerRadius(10)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 250, height: 200)
                                            .clipped()
                                            .cornerRadius(10)
                                            .foregroundColor(.gray)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                
                                Text(event.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .lineLimit(2) // Limit to two lines for compact display
                                    .padding(.top, 8) // Add top padding for separation
                            }
                            .padding(.vertical)
                        }
                        .buttonStyle(PlainButtonStyle()) // Ensure navigation link style is consistent
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct LiveEvent: Identifiable {
    let id: Int
    let imageName: String
    let name: String
}



// Suggestion View
struct SuggestionsView: View {
    let fetchedData: FetchedDataResponse?
    
    @State private var navigateToNextHome = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionView(title: "", showDisclosure: false) {
                HStack{
                    
                    
                    Text("Suggestions")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .multilineTextAlignment(.trailing)
                    
                    Spacer()
                    
                    NavigationLink(destination: NextHomeUIView(fetchedData: fetchedData), isActive: $navigateToNextHome) {
                        Text("View All")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(.horizontal)
                            .multilineTextAlignment(.trailing)
                        
                        
                    }
                }
                
                .buttonStyle(PlainButtonStyle())
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach((fetchedData?.books.shuffled().prefix(7)) ?? [], id: \.self) { book in
                            VStack(alignment: .leading) {
                                NavigationLink(destination: BookDetailView(book: book)) {
                                    PlaylistView(
                                        imageUrl: URL(string: book.imageUrl ?? "https://static.toiimg.com/photo/104701845/104701845.jpg"),
                                        imageWidth: 150,
                                        imageHeight: 150,
                                        book: book
                                    )
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            SectionView(title: "", showDisclosure: false) {
                HStack{
                    Text("For You")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .multilineTextAlignment(.trailing)
                    
                    Spacer()
                    
                    
                    
                    NavigationLink(destination: NextHomeUIView(fetchedData: fetchedData), isActive: $navigateToNextHome) {
                        Text("View All")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(.horizontal)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                
                .buttonStyle(PlainButtonStyle())
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach((fetchedData?.books.shuffled().prefix(7)) ?? [], id: \.self) { book in
                            VStack(alignment: .leading) {
                                NavigationLink(destination: BookDetailView(book: book)) {
                                    PlaylistView(
                                        imageUrl: URL(string: book.imageUrl ?? "https://static.toiimg.com/photo/104701845/104701845.jpg"),
                                        imageWidth: 150,
                                        imageHeight: 150,
                                        book: book
                                    )
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            SectionView(title: "", showDisclosure: false) {
                HStack{
                    Text("May You Like It")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .multilineTextAlignment(.trailing)
                    
                    Spacer()
                    
                    
                    NavigationLink(destination: NextHomeUIView(fetchedData: fetchedData), isActive: $navigateToNextHome) {
                        Text("View All")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(.horizontal)
                            .multilineTextAlignment(.trailing)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach((fetchedData?.books.shuffled().prefix(7)) ?? [], id: \.self) { book in
                            VStack(alignment: .leading) {
                                NavigationLink(destination: BookDetailView(book: book)) {
                                    PlaylistView(
                                        imageUrl: URL(string: book.imageUrl ?? "https://static.toiimg.com/photo/104701845/104701845.jpg"),
                                        imageWidth: 150,
                                        imageHeight: 150,
                                        book: book
                                    )
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            SectionView(title: "", showDisclosure: false) {
                HStack{
                    Text("More to Discover")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .multilineTextAlignment(.trailing)
                    
                    Spacer()
                    
                    
                    NavigationLink(destination: NextHomeUIView(fetchedData: fetchedData), isActive: $navigateToNextHome) {
                        Text("View All")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(.horizontal)
                            .multilineTextAlignment(.trailing)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(fetchedData?.books.prefix(5) ?? [], id: \.self) { book in
                            VStack(alignment: .leading) {
                                NavigationLink(destination: BookDetailView(book: book)) {
                                    PlaylistView(
                                        imageUrl: URL(string: book.imageUrl ?? "https://static.toiimg.com/photo/104701845/104701845.jpg"),
                                        imageWidth: 150,
                                        imageHeight: 150,
                                        book: book
                                    )
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct HalfSheetView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                content
                    .frame(height: geometry.size.height / 2)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 20)
                    .ignoresSafeArea()
            }
        }
    }
}





// Content View
struct SectionView<Content: View>: View {
    let title: String
    let showDisclosure: Bool
    let content: () -> Content
    
    init(title: String, showDisclosure: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.showDisclosure = showDisclosure
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                if showDisclosure {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .padding(.leading, 5) // Adjusts the space between the text and the indicator
                }
                Spacer()
            }
            .padding(.horizontal)
            content()
        }
    }
}



// PlayList View
struct PlaylistView: View {
    let imageUrl: URL?
    var imageWidth: CGFloat = 150
    var imageHeight: CGFloat = 150
    var description: String?
    var bookName: String?
    var bookAuthor: String?
    var book: Book?
    
    var showAdditionalText: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) { // Adjusted spacing
            if let imageUrl = imageUrl {
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
            
            if let book = book {
                Text(book.name) // Show the book's name
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Text(book.author) // Show the book's author
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let bookName = bookName {
                Text(bookName)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            if let bookAuthor = bookAuthor {
                Text(bookAuthor)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            if let description = description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if showAdditionalText {
                Text("Additional Text")
                    .font(.caption)
                    .foregroundColor(.black)
                Text("More Text")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.bottom, -15) // Adjusted bottom padding
        .frame(width: imageWidth)
    }
}
