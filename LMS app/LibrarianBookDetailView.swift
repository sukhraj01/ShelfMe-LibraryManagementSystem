import SwiftUI

struct LibrarianBookDetailView: View {
    var book: Book
    
    
    
    @State private var showingEditBook = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
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
            
            
            
            
            
            
            // Book title and author
            VStack(alignment: .center, spacing: 5) {
                Text(book.name)
                    .font(.title)
                    .fontWeight(.bold)
                Text(book.author)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.top, 10)
            
//            Button(action: {
//                            print("Book Details: \(book)")
////                            print("Title: \(book.name)")
////                            print("Author: \(book.author)")
////                            print("ISBN: \(book.isbn)")
//                            // Print other details as needed
//                        }) {
//                            Text("Print Book Details")
//                        }
            
            // Book details
            Form {
                Section {
                    HStack {
                        Text("ISBN Number")
                        Spacer()
                        Text("\(book.isbn)")
                            .foregroundColor(.gray)
                    }

                    HStack {
                        Text("Category")
                        Spacer()
                        Text(book.category)
                            .foregroundColor(.gray)
                    }

                    HStack {
                        Text("Quantity")
                        Spacer()
                        Text("1")
                            .foregroundColor(.gray)
                    }

                    HStack {
                        Text("Amount")
                        Spacer()
                        Text("\(book.price)")
                            .foregroundColor(.gray)
                    }

                    HStack {
                        Text("Shelf")
                        Spacer()
                        Text("\(book.rackNo)")
                            .foregroundColor(.gray)
                    }

                    VStack(alignment: .leading) {
                        Text("Notes")
                        Text(book.description)
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                    }
                }
            }
            
            Spacer()
            
            // Delete button
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                
                // delete button action
                
//                if let index = books.firstIndex(where: { $0.id == book2.id }) {
//                    books2.remove(at: index)
//                    presentationMode.wrappedValue.dismiss()
//                }
            }) {
                Text("Delete Book")
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .navigationTitle("Books Details")
        .navigationBarItems(trailing: Button("Edit") {
            showingEditBook = true
        })
        .sheet(isPresented: $showingEditBook) {
            LibrarianBookEditView(book: book)
        }
        // Update book object when changes are made in EditBookView
//        .onChange(of: book) { newValue in
//            if let index = books.firstIndex(where: { $0.id == newValue.id }) {
//                books[index] = newValue
//            }
//        }
        
        
    }
    
    
}
