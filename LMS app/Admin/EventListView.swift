import SwiftUI

struct EventListView: View {
    let title: String
    let events: [Event]
    let onDelete: (Event) -> Void // Adjust onDelete to accept a closure with an Event parameter
    
    var body: some View {
        VStack(alignment: .leading) {
            if !events.isEmpty { // Display the heading only if events are present
                Text(title)
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding(.leading)
            }
            
            if !events.isEmpty { // Display events only if there are events
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(events) { event in
                            NavigationLink(destination: EventDetailView(event: event, onDelete: {
                                onDelete(event) // Call onDelete with the event parameter
                            })) {
                                EventCardView(event: event)
                                    .foregroundColor(.black) // Set text color to black
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                Text("No Events")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
}

struct EventCardView: View {
    var event: Event
    
    var body: some View {
        VStack {
//            if let imageName = event.imageName {
//                Image(imageName)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 230, height: 170)
//                    .cornerRadius(10)
//                    .clipped()
//            } else {
//                Image("defaultImage") // Ensure you have a default image in your assets
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 300, height: 200)
//                    .cornerRadius(10)
//                    .clipped()
//            }
            Text(event.name) // Changed from title to name
                .font(.caption) // Increase font size
                .bold() // Make the name bold
            Text(event.startDate, style: .date)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.trailing)
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        EventListView(title: "Sample Events", events: [
            Event(id: "1", imageName: "eventImage", name: "Sample Event 1", startDate: Date(), endDate: Date(), time: "8:00 AM", language: "English", genre: "Comedy", description: "A fun event."),
            Event(id: "2", imageName: "eventImage", name: "Sample Event 2", startDate: Date(), endDate: Date(), time: "10:00 AM", language: "English", genre: "Poetry", description: "A beautiful event.")
        ], onDelete: {_ in })
    }
}
