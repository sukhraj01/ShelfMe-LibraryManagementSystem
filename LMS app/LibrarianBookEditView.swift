import SwiftUI

struct LibrarianBookEditView: View {
    @Environment(\.presentationMode) var presentationMode
    var book: Book
    
    var name: String // Change 'let' to 'var'
        var author: String // Change 'let' to 'var'
        var category: String
        var price: Int
        var rackNo: Int
        var description: String
    
    @State private var editedName: String
        @State private var editedAuthor: String
        @State private var editedCategory: String
    @State private var editedPrice: String
        @State private var editedRackNo: String // Changed to String
        @State private var editedDescription: String
    
    init(book: Book) {
            self.book = book
            self.name = book.name
            self.author = book.author 
        self.price = book.price
            self.category = book.category
            self.rackNo = book.rackNo
            self.description = book.description
        
        self._editedName = State(initialValue: book.name)
            self._editedAuthor = State(initialValue: book.author)
            self._editedCategory = State(initialValue: book.category)
            self._editedPrice = State(initialValue: "\(book.price)")
            self._editedRackNo = State(initialValue: "\(book.rackNo)")
            self._editedDescription = State(initialValue: book.description)
        }
    

    
    // Other state variables
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var navigateToContentView = false
    
    
    
    var body: some View {
        NavigationView {
            Form {
                // Existing code for book cover
                Section(header: Text("Book Cover")) {
                    HStack {
                        Spacer()
                        VStack {
                            if let imageUrlString = book.imageUrl,
                               let imageUrl = URL(string: imageUrlString) {
                                AsyncImage(url: imageUrl) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 200 , height: 200)
                                    case .success(let image):
                                        image.resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 150, height: 150)
                                            .clipped()
                                            .cornerRadius(10)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 150, height: 150)
                                            .clipped()
                                            .cornerRadius(10)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 150)
                                    .clipped()
                                    .cornerRadius(10)
                            }
                            
                            Button(action: {
                                self.showingImagePicker = true
                            }) {
                                Text("Change Photo")
                            }
                        }
                        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                            ImagePicker(image: self.$inputImage)
                        }
                        Spacer()
                    }
                }
                
                Section(header: Text("Book Details")) {
                    TextField("Title", text: $editedName)
                    TextField("Author", text: $editedAuthor)
                }
                
                Section(header: Text("Additional Information")) {
                    TextField("Category", text: $editedCategory)
//                    Stepper(value: 1, in: 1...100) {
                        Text("Quantity: \(1)")
//                    }
                    TextField("Amount", value: $editedPrice, formatter: NumberFormatter())
                    TextField("Shelf", text: $editedRackNo)
                }
                
                Section(header: Text("Notes")) {
                    TextField("Notes", text: $editedDescription)
                }
            }
            .navigationTitle("Edit Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // Update the book object with edited values
                        
                        
                        
                        print("updateddddddddddddddd")
                        print(book)
                        print(editedName)
//
                        
                        // Dismiss view
                        presentationMode.wrappedValue.dismiss()
                        navigateToContentView = true
                    }
                }
            }
        }
    }
    
    // Function to handle image loading
    func loadImage() {
        guard let inputImage = inputImage else { return }
        // You can handle loading the image here
    }
}


