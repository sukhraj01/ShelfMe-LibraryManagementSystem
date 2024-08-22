import SwiftUI

struct BookRequestRow: View {
    let bookRequest: BookR
    
    init(bookRequest: BookR) {
        self.bookRequest = bookRequest
        print(bookRequest)
    }
    
    var body: some View {
        HStack {
//            if let imageUrlString = bookRequest.bookImageUrl, let imageURL = URL(string: imageUrlString){
//                            AsyncImage(url:imageURL) { phase in
//                                if let image = phase.image {
//                                    image
//                                        .resizable() // Make the image resizable
//                                        .aspectRatio(contentMode: .fit) // Maintain aspect ratio
//                                        .frame(width: 50, height: 80) // Set frame size
//                                        .cornerRadius(5)
//                                } else if phase.error != nil {
//                                    // Handle error
//                                    Text("Failed to load image")
//                                        .foregroundColor(.red)
//                                } else {
//                                    // Placeholder while loading
//                                    ProgressView()
//                                }
//                            }
//                        }
            
            VStack(alignment: .leading) {
                Text(bookRequest.bookName)
                    .font(.headline)
                Text("Member Name - \(bookRequest.userName)")
                Text("Status - \(bookRequest.status)")
                Text("ISBN - \(bookRequest.bookIsbn)")
            }
        }
    }
    
}
