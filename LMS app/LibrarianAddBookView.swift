
import SwiftUI

struct LibrarianAddBookView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var author = ""
    @State private var isbn = ""
    @State private var category = "None"
    @State private var quantity = 1
    @State private var amount = 0.0
    @State private var shelf = ""
    @State private var notes = ""
    @State private var errorMessage: String = ""
    
    @State private var isCategoryPickerPresented = false
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showAlert = false
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                // Image of the book
                if let inputImage = inputImage {
                    Image(uiImage: inputImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                        .padding()
                } else {
                    Image(systemName: "book")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                        .padding()
                }
                
                Button(action: {
                    self.showingImagePicker = true
                }) {
                    Text("Choose Image")
                }
                .padding()
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: self.$inputImage)
                }
                
                Form {
                    Section(header: Text("Basic Information")) {
                        TextField("Title", text: $title)
                        TextField("Author", text: $author)
                        TextField("ISBN Number", text: $isbn)
                    }
                    
                    Section(header: Text("Additional Information")) {
                        Button(action: {
                            isCategoryPickerPresented = true
                        }) {
                            HStack {
                                Text("Category")
                                Spacer()
                                Text(category)
                                    .foregroundColor(.gray)
                            }
                        }
                        .actionSheet(isPresented: $isCategoryPickerPresented) {
                            ActionSheet(title: Text("Select Category"), buttons: categories.map { category in
                                .default(Text(category)) {
                                    self.category = category
                                }
                            } + [.cancel()])
                        }
                        
                        Stepper(value: $quantity, in: 1...100) {
                            Text("Quantity: \(quantity)")
                        }
                        
                        HStack {
                            Text("Amount")
                            Spacer()
                            TextField("", value: $amount, formatter: NumberFormatter())
                                .keyboardType(.decimalPad)
                        }
                        
                        TextField("Shelf", text: $shelf)
                    }
                    
                    Section(header: Text("Notes")) {
                        TextField("Notes", text: $notes)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Add") {
                addBook()
                
                showAlert = true
            })
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("New Book")
                        .font(.headline)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Book Added"), message: Text("The book has been added successfully."), dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
    }
    func addBook() {
            guard let url = URL(string: "https://lms-hgdf.onrender.com/api/v1/book/add") else {
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let boundary = UUID().uuidString
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            var data = Data()

            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"title\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(title)\r\n".data(using: .utf8)!)

            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"author\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(author)\r\n".data(using: .utf8)!)

            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"isbn\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(isbn)\r\n".data(using: .utf8)!)

            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"category\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(category)\r\n".data(using: .utf8)!)

            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"quantity\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(quantity)\r\n".data(using: .utf8)!)

            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"amount\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(amount)\r\n".data(using: .utf8)!)

            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"shelf\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(shelf)\r\n".data(using: .utf8)!)

            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"notes\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(notes)\r\n".data(using: .utf8)!)

            if let image = inputImage, let imageData = image.jpegData(compressionQuality: 0.8) {
                data.append("--\(boundary)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"file\"; filename=\"book.jpg\"\r\n".data(using: .utf8)!)
                data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                data.append(imageData)
                data.append("\r\n".data(using: .utf8)!)
            }

            data.append("--\(boundary)--\r\n".data(using: .utf8)!)

            request.httpBody = data

            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.errorMessage = error?.localizedDescription ?? "Unknown error"
                    }
                    return
                }
                
                if let jsonString = String(data: data, encoding: .utf8) {
                            print("Received JSON data: \(jsonString)")
                        }

                if let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) {
                    do {
                        let statusCode = httpResponse.statusCode
                        print(statusCode)
                        let registrationResponse = try JSONDecoder().decode(UserRegistrationResponse.self, from: data)
                        
                        DispatchQueue.main.async {
                            self.errorMessage = registrationResponse.message
                            if httpResponse.statusCode == 200 {
                                
                                showAlert = true
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.errorMessage = "Error decoding response"
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
    
    func loadImage() {
        // Additional processing of the image can be done here if needed
    }
}



struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) { }
}
