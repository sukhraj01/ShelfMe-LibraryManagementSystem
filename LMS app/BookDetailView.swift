import SwiftUI


struct BookDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showFullSynopsis = false
    @State private var isFavorite = false
    let book: Book
    
    init(book: Book) {
            self.book = book
//        print("printing detail of bookkkkkk")
//            print(book)
        }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                   
                    
                    AsyncImage(url: URL(string: book.imageUrl ?? "")) { phase in
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

                    // Book Title and Author
                    Text(book.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 20)

                    Text(book.author)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)

                    // Book Details
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Rating")
                                .font(.caption)
                                .foregroundColor(.gray)
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text("4.5")
                            }
                        }

                        Spacer()

                        VStack(alignment: .leading) {
                            Text("Pages")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("757")
                        }

                        Spacer()

                        VStack(alignment: .leading) {
                            Text("Languages")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("Eng")
                        }

                        Spacer()

                        VStack(alignment: .leading) {
                            Text("Published")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("2021")
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)

                    // Issue Book Button
                    Button(action: {
                        // Handle the issue book action
                    }) {
                        Text("Available")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)

                    // Synopsis
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Synopsis")
                            .font(.headline)

                        Text(book.description)
                            .lineLimit(showFullSynopsis ? nil : 3) // Show full text when button is toggled
                            .font(.body)
                    }
                    .padding(.horizontal, 40)

                    // Read More Button
                    Button(action: {
                        withAnimation {
                            showFullSynopsis.toggle() // Toggle the state variable
                        }
                    }) {
                        Text(showFullSynopsis ? "Read Less" : "Read More")
                            .foregroundColor(.blue)
                            .font(.subheadline)
                            .padding(.top, 5)
                    }
                    .padding(.horizontal, 40)

                    // Similar Books Section
                    VStack(alignment: .leading) {
                        Text("Similar Books")
                            .font(.headline)
                            .padding(.top, 20)
                            .padding(.horizontal, 40)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(similarBooks) { book in
                                    SimilarBookView(book: book)
                                }
                            }
                            .padding(.horizontal, 40)
                        }
                    }
                    .padding(.bottom, 20)

                    // Reviews Section
                    VStack(alignment: .leading) {
                        Text("Reviews")
                            .font(.headline)
                            .padding(.top, 20)
                            .padding(.horizontal, 40)
                        
                        ForEach(reviews) { review in
                            ReviewView(review: review)
                                .padding(.horizontal, 40)
                                .padding(.bottom, 10)
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                },
                trailing: Menu {
                    Button(action: {
                        isFavorite.toggle() // Toggle favorite status
                    }) {
                        Label(isFavorite ? "Added to Favorites" : "Add to Favorites", systemImage: "heart")
                    }
                    Button(action: {
                        // Handle share action
                    }) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    Button(action: {
                        // Handle add to library action
                    }) {
                        Label("Add to Library", systemImage: "books.vertical")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.black)
                }
            )
        }
        .navigationBarBackButtonHidden(true)
    }
}

// Rest of your code remains the same...

struct SimilarBookView: View {
    let book: Book1
    
    var body: some View {
        VStack {
            Image(book.coverImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 180)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
            
            Text(book.title)
                .font(.headline)
                .lineLimit(1)
                .padding(.top, 5)
            
            HStack(spacing: 2) {
                ForEach(0..<5) { star in
                    Image(systemName: star < book.rating ? "star.fill" : "star")
                        .resizable()
                        .foregroundColor(star < book.rating ? .yellow : .gray)
                        .frame(width: 15, height: 15)
                }
            }
        }
        .frame(width: 140)
    }
}

struct ReviewView: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(review.reviewer)
                    .font(.headline)
                Spacer()
                Text(review.date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 2)
            
            HStack(spacing: 2) {
                ForEach(0..<5) { star in
                    Image(systemName: star < review.rating ? "star.fill" : "star")
                        .resizable()
                        .foregroundColor(star < review.rating ? .yellow : .gray)
                        .frame(width: 15, height: 15)
                }
            }
            .padding(.bottom, 2)
            
            Text(review.text)
                .font(.body)
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
    }
}

struct Book1: Identifiable {
    let id = UUID()
    let title: String
    let coverImage: String
    let rating: Int
}

struct Review: Identifiable {
    let id = UUID()
    let reviewer: String
    let date: String
    let rating: Int
    let text: String
}

let similarBooks = [
    Book1(title: "A Flicker in the Dark", coverImage: "a_flicker_in_the_dark", rating: 4),
    Book1(title: "Book Two", coverImage: "book_two", rating: 5),
    Book1(title: "Book Three", coverImage: "book_three", rating: 3)
]

let reviews = [
    Review(reviewer: "John Doe", date: "2024-05-20", rating: 5, text: "An amazing read! The plot twists were unexpected and kept me hooked till the end."),
    Review(reviewer: "Jane Smith", date: "2024-05-18", rating: 4, text: "Great book with well-developed characters. The pacing was a bit slow in the middle, but overall a fantastic read."),
    Review(reviewer: "Alice Johnson", date: "2024-05-15", rating: 3, text: "The book was good but not great. Some parts felt a bit cliched and predictable.")
]

