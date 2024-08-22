import SwiftUI
import UIKit

struct NewEventView: View {
    
    @State private var event = Event(
        id:"",
        imageName: "",
        name: "",
        startDate: Date(),
        endDate: Date().addingTimeInterval(60*60*24*14),
        time: "",
        language: "English",
        genre: "Comedy",
        description: ""
    )
    
    @State private var showPhotoPicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var showAlert = false
    @Binding var eventsCreated: [Event] // Binding to update eventsCreated in AdminEventsView
    
    var body: some View {
        NavigationView {
            
            ZStack {
                Color(.systemGray6).edgesIgnoringSafeArea(.all)
                
                VStack {
                    Button(action: {
                        showPhotoPicker = true
                    }) {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                        } else {
                            VStack{
                                Image(systemName: "plus.square")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .foregroundColor(.gray)
                                    .padding(.top,-20)
                                Text("Choose photo")
                                    .bold()
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: $showPhotoPicker) {
                        ImagePicker(image: $selectedImage)
                    }
                    
                    Form {
                        // First section with Title, Start Date, End Date
                        Section {
                            HStack {
                                Text("Title ")
                                TextField("Title of the Event", text: $event.name)
                                    .padding(.leading,130)
                            }
                            
                            DatePicker("Start Date", selection: $event.startDate, displayedComponents: .date)
                                .padding(.vertical,-5)
                            DatePicker("End Date", selection: $event.endDate, displayedComponents: .date)
                                .padding(.vertical,-5)
                        }
                        
                        // Second section with Time, Language, and Genre
                        Section {
                            HStack{
                                Text("Time ")
                                TextField("Time", text: $event.time)
                                    .padding(.vertical,-5)
                                    .padding(.leading,200)
                                    
                            }
                            
                            Picker("Language", selection: $event.language) {
                                ForEach(["English", "Spanish", "French", "German"], id: \.self) {
                                    Text($0)
                                }
                            }
                            .padding(.vertical,-5)
                            
                            Picker("Genre", selection: $event.genre) {
                                ForEach(["Comedy", "Drama", "Action", "Horror"], id: \.self) {
                                    Text($0)
                                }
                            }
                            .padding(.vertical,-5)
                        }
                    
                        Section {
                            TextEditor(text: $event.description)
                                .frame(height: 100)
                                .overlay(
                                    Text(event.description.isEmpty ? "Description" : "")
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 12),
                                    alignment: .topLeading
                                )
                        }
                    }
                    
                    Button(action: {
                        showAlert = true
                        createEvent()
                    }) {
                        Text("Create Event")
                            .frame(width:300)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Event Created Successfully"))
                    }
                    .padding()
                }
            }
        }
    }
    
    private func createEvent() {
        guard let url = URL(string: "https://lms-hgdf.onrender.com/api/v1/event/add") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        if let selectedImage = selectedImage,
           let imageData = selectedImage.jpegData(compressionQuality: 0.7) {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(imageData)
            body.append("\r\n")
        }
        
        let parameters: [String: Any] = [
            "title": event.name,
            "startDate": ISO8601DateFormatter().string(from: event.startDate),
            "endDate": ISO8601DateFormatter().string(from: event.endDate),
            "time": event.time,
            "language": event.language,
            "genre": event.genre,
            "description": event.description
        ]
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        body.append("--\(boundary)--\r\n")
        
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let responseObject = try JSONSerialization.jsonObject(with: data, options: [])
                print("Response: \(responseObject)")
                DispatchQueue.main.async {
                    self.showAlert = true
                    eventsCreated.append(event) // Add the new event to eventsCreated array
                }
            } catch {
                print("Error parsing response: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct NewEventView_Previews: PreviewProvider {
    static var previews: some View {
        NewEventView(eventsCreated: .constant([])) // Pass eventsCreated as a binding
    }
}

// Helper to append Data
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
