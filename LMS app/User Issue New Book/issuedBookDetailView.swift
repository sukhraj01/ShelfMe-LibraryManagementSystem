
import Foundation
import SwiftUI

struct issuedBookDetailView: View {
    var issueBookDetails: userIssueBookRequest
    var bookID: String // Add book ID parameter
    
    @State private var renewals = 0
    @State private var isRenewed = false
    @State private var renewalDate = Date() // Initial renewal date
    
    var body: some View {
        VStack(spacing: 20) {
            
            
            // Replace Image with actual image asset using book imageURL
            if let imageUrlString = issueBookDetails.image, let imageURL = URL(string: imageUrlString){
                AsyncImage(url:imageURL) { phase in
                    if let image = phase.image {
                        image
                            .resizable() // Make the image resizable
                            .aspectRatio(contentMode: .fit) // Maintain aspect ratio
                            .frame(width: 100, height: 150) // Set frame size
                            .cornerRadius(5)
                    } else if phase.error != nil {
                        // Handle error
                        Text("Failed to load image")
                            .foregroundColor(.red)
                    } else {
                        // Placeholder while loading
                        ProgressView()
                    }
                }
            }
            
            VStack(spacing: 7) {
                Text(issueBookDetails.title) // Use book properties
                    .font(.title2)
                    .fontWeight(.semibold)
                
                // Display author or any other information from book object
                Text("By Author Name")
                    .foregroundColor(.gray)
            }
            
            VStack(spacing: 10) {
                HStack {
                    Text("Issued on")
                    Spacer()
                    Text(issueBookDetails.time ?? "Unknown") // Provide default value if nil
                        .foregroundColor(.gray)
                }
                Divider() // Add divider line
                HStack {
                    Text("Due date")
                    Spacer()
                    Text(issueBookDetails.dueDate ?? "Unknown") // Provide default value if nil
                        .foregroundColor(.gray)
                }
                Divider() // Add divider line
                HStack {
                    Text("Overdue")
                    Spacer()
                    // Calculate overdue days based on return date and current date
                    Text("\(calculateOverdueDays()) days")
                        .foregroundColor(.gray)
                }
                Divider() // Add divider line
                HStack {
                    Text("Renewals")
                    Spacer()
                    Text("\(renewals)")
                        .foregroundColor(.gray)
                }
                if isRenewed {
                    Divider() // Add divider line
                    HStack {
                        Text("Renewal Date")
                        Spacer()
                        Text("\(formattedDate(date: renewalDate))")
                            .foregroundColor(.black)
                    }
                }
            }
            
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                renewBook()
            }) {
                Text("Renew")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
        .navigationBarTitle(bookID)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func calculateOverdueDays() -> Int {
        // Implement logic to calculate overdue days based on return date and current date
        return 2 // Placeholder value, replace with actual logic
    }
    
    func renewBook() {
        renewals += 1
        isRenewed = true
        renewalDate = Date() // Update renewal date to current date
    }
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
struct issuedBookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        issuedBookDetailView(issueBookDetails: userIssueBookRequest(title: "Sample Book", requestId: "#12345", status: .accepted, dueDate: "2024-06-12", time: "2024-06-05", image: "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1670718519i/65146478.jpg"), bookID: "#12345")
    }
}


