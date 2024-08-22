import SwiftUI

struct EventDetailView: View {
    var event: Event
    var onDelete: () -> Void
    @State private var showingAlert = false // State variable to control the alert

    var body: some View {
        
        VStack {
            AsyncImage(url: URL(string: event.imageName)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 227, height: 164)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 227, height: 164)
                        .clipped()
                        .cornerRadius(10)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 227, height: 164)
                        .clipped()
                        .cornerRadius(10)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            
        }

        List {
            // Event Name
            Section {
                HStack {
                    Text("Title") // changed from Name to Title
                    Spacer()
                    Text(event.name) // changed from Name to Title
                        .foregroundColor(.gray)
                        .padding(.leading,60)
                }
                .padding(.vertical, 1)
                
                HStack {
                    Text("Start Date")
                    Spacer()
                    Text(formattedDate(event.startDate))
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 1)
                
                HStack {
                    Text("End Date")
                    Spacer()
                    Text(formattedDate(event.endDate))
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 1)
                
                HStack {
                    Text("Total Days")
                    Spacer()
                    Text("\(totalDays(event.startDate, event.endDate))")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 1)
            }
            
            Section {
                HStack {
                    Text("Time")
                    Spacer()
                    Text(event.time)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 1)
                
                HStack {
                    Text("Language")
                    Spacer()
                    Text(event.language)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 1)
                
                HStack {
                    Text("Genre")
                    Spacer()
                    Text(event.genre)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 1)
            }
            
            Section {
                Text(event.description)
                    .foregroundColor(.primary)
                    .padding(.vertical, 1)
                
            }
            Button(action: {
                // Show the alert when the button is tapped
                showingAlert = true
            }) {
                Text("Delete Event")
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 20)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding()
            }
            .frame(height: 20)
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Event Deleted Successfully"),
                    message: nil,
                    dismissButton: .default(Text("OK")) {
                        // Call onDelete closure when OK is tapped
                        onDelete()
                    }
                )
            }
        }
        .navigationBarTitle("Event Details", displayMode: .inline)
      
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func totalDays(_ startDate: Date, _ endDate: Date) -> Int {
        Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
    }
}

struct EventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailView(event: Event(id: "1", imageName: "eventImage", name: "Sample Event", startDate: Date(), endDate: Date(), time: "8:00 AM", language: "English", genre: "Comedy", description: "Sample Description"), onDelete: {})
    }
}


