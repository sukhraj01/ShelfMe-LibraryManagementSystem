import SwiftUI

struct AdminEventsView: View {
    @State private var searchText = ""
    @State var eventsCreated: [Event] = []

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    searchBar
                    todaysEventsSection
                    upcomingEventsSection
                }
            }
            .navigationBarTitle("Events")
            .navigationBarItems(trailing:
                NavigationLink(destination: NewEventView(eventsCreated: $eventsCreated)) {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .padding()
                }
            ).onAppear {
                fetchAllEvents()
            }
        }
    }

    var searchBar: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray6))
                .frame(height: 36)
                .padding(.horizontal, 8)

            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                TextField("Search", text: $searchText)
                    .padding(.leading, 8)
                    .padding(.trailing, 32)

                Spacer()

                Button(action: {
                    // Action for microphone button
                }) {
                    Image(systemName: "mic.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                }
            }
            .padding(.horizontal)
        }
    }

    var todaysEventsSection: some View {
        VStack(alignment: .leading) {
            Text("Today's Events")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.top)

            if !todaysEvents.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(todaysEvents) { event in
                            EventRow(event: event)
                                .frame(width: 250)
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                Text("No events today")
                    .padding(.horizontal)
            }
        }
    }

    var upcomingEventsSection: some View {
        VStack(alignment: .leading) {
            Text("Upcoming Events")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.top)

            if !upcomingEvents.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(upcomingEvents) { event in
                            EventRow(event: event)
                                .frame(width: 250)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }

    var todaysEvents: [Event] {
        let today = Calendar.current.startOfDay(for: Date())
        return eventsCreated.filter { event in
            let startDate = Calendar.current.startOfDay(for: event.startDate)
            let endDate = Calendar.current.startOfDay(for: event.endDate)
            return startDate <= today && endDate >= today
        }
    }

    var upcomingEvents: [Event] {
        let today = Calendar.current.startOfDay(for: Date())
        return eventsCreated.filter { event in
            let startDate = Calendar.current.startOfDay(for: event.startDate)
            return startDate > today
        }
    }

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
                        eventsCreated = decodedEvents
//                        print("Events in Backend : \(self.eventsCreated)")
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }.resume()
    }
    
}

// Showing data
struct EventRow: View {
    var event: Event

    var body: some View {
        NavigationLink(destination: EventDetailView(event: event, onDelete: {})) {
            VStack(alignment: .leading) {
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

                VStack(alignment: .leading) {
                    Text(event.name)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 4)
                        .padding(.leading, 70)
                        .lineLimit(1)

                    Text(event.startDate, style: .date)
                        .font(.caption)
                        .padding(.leading, 70)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
        }
    }
}
