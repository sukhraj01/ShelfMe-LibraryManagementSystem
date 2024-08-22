import SwiftUI

struct EventCellView: View {
    var event: Event
    
    var body: some View {
        VStack {
//            if let imageName = event.imageName {
//                Image(imageName) // Use the imageName directly
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 230, height: 170)
//                    .cornerRadius(8)
//            } else {
//                Image("defaultImage") // Ensure you have a default image in your assets
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 230, height: 170)
//                    .cornerRadius(8)
//            }
            Text(event.name) // Use name instead of title
                .font(.headline)
                .foregroundColor(.black)
            Text(event.startDate, style: .date)
                .font(.subheadline)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

struct EventCellView_Previews: PreviewProvider {
    static var previews: some View {
        EventCellView(event: Event(
            id: "1",
            imageName: "eventImage",
            name: "Sample Event", // Use name instead of title
            startDate: Date(),
            endDate: Date(),
            time: "8:00 AM",
            language: "English",
            genre: "Comedy",
            description: "Sample Description"
        ))
    }
}
