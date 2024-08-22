import SwiftUI

struct NextHomeUIView: View {
    let fetchedData: FetchedDataResponse? // Removed default value
    
    @Environment(\.presentationMode) var presentationMode // Add this to manage presentation mode
    
    init(fetchedData: FetchedDataResponse? = nil) { // Added initializer
        self.fetchedData = fetchedData
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(fetchedData?.books ?? [], id: \.self) { book in
                            NavigationLink(destination: BookDetailView(book: book)) {
                                VStack(alignment: .leading) {
                                    // Load image from URL
                                    AsyncImage(url: URL(string: book.imageUrl ?? "")) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 160, height: 160)
                                                .cornerRadius(10)
                                        case .failure(let error):
                                            Text("Failed to load image: \(error.localizedDescription)")
                                        case .empty:
                                            Text("Loading...")
                                        @unknown default:
                                            Text("Loading...")
                                        }
                                    }
                                    .frame(width: 160, height: 160)
                                    .cornerRadius(10)
                                    
                                    Text(book.name)
                                        .font(.headline)
                                    Text(book.author)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding(.bottom, 10)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarTitle("Title", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue) // Customize the color if needed
                    }
                }
            }
            .onAppear {
                if let fetchedData = fetchedData {
                    print("Fetched Data:")
                    print(fetchedData)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct Podcast: Identifiable {
    let id = UUID()
    let imageName: String
    let category: String
    let updateFrequency: String
}

let podcasts = [
    Podcast(imageName: "theprint", category: "Politics", updateFrequency: "daily"),
    Podcast(imageName: "empire", category: "History", updateFrequency: "twice weekly"),
    Podcast(imageName: "acenturyofstories", category: "History", updateFrequency: "weekly"),
    Podcast(imageName: "financialnews", category: "Business", updateFrequency: "daily"),
    Podcast(imageName: "podcast5", category: "Category", updateFrequency: "Frequency"),
    Podcast(imageName: "podcast6", category: "Category", updateFrequency: "Frequency")
]

struct NextHomeUI_Previews: PreviewProvider {
    static var previews: some View {
        NextHomeUIView()
    }
}
