import SwiftUI

struct AdminLibrarianManagementView: View {
    @State private var librarians: [Librarian] = []
//    @State private var librarians: [Librarian] = []
    @State private var showingCreateForm = false
    @State private var selectedSegment = 0
    @State private var showingPasswordAlert = false
    @State private var selectedLibrarian: Librarian? = nil
    @State private var showingPasswordUpdateForm = false
    @State private var searchQuery = ""
    @State private var isSearchActive = false
    var body: some View {
        ZStack {
            Color.gray
            
            NavigationView {
                VStack {
                    Text("Accounts")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                        .padding(.leading, -175)

                    // Native iOS search bar
                    AdminSearchBar(text: $searchQuery, isActive: $isSearchActive, placeholder: "Search...")
                        .padding(.top,-5)
                        .padding(.bottom, 10)

                    // Conditionally display the segmented control
                    if isSearchActive {
                        Picker(selection: $selectedSegment, label: Text("")) {
                            Text("Librarians").tag(0)
                            Text("Users").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    }
                    
                    // Display accounts based on selected segment
                    if selectedSegment == 0 {
                        List {
                            if librarians.isEmpty {
                                Text("No librarian accounts")
                                    .font(.title3)
                                    .padding(.top)
                                    .padding(.leading, 50)
                            } else {
                                ForEach(filteredLibrarians) { librarian in
                                    NavigationLink(destination: LibrarianDetailView(librarian: librarian)) {
                                        HStack {
                                            if let profilePic = librarian.profilePic {
                                                Image(uiImage: profilePic)
                                                    .resizable()
                                                    .clipShape(Circle())
                                                    .frame(width: 50, height: 50)
                                                    .padding(.trailing, 10)
                                            } else {
                                                Image(systemName: "person.crop.circle.fill")
                                                    .resizable()
                                                    .frame(width: 50, height: 50)
                                                    .foregroundColor(.gray)
                                                    .padding(.trailing, 10)
                                            }

                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(librarian.name)
                                                    .font(.title3)
                                                    .fontWeight(.bold)
                                            }
                                        }
                                        .padding(.vertical, 8)
                                        .background(Color.white)
                                        .cornerRadius(8)
                                    }
                                }
                                .onDelete(perform: deleteLibrarian)
                            }
                        }
                        .listStyle(PlainListStyle())
                        .padding(.horizontal, 10)
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                    } else {
                        // Show nothing for users segment
                        Text("No user accounts")
                            .font(.title3)
                            .padding(.top)
                            .padding(.leading, 50)
                    }

                    Spacer()
                        .alert(isPresented: $showingPasswordAlert) {
                            Alert(
                                title: Text("Password Sent"),
                                message: Text("Password: \(selectedLibrarian?.password ?? "N/A")"),
                                dismissButton: .default(Text("OK"), action: {
                                    showingPasswordUpdateForm = true
                                })
                            )
                        }
                        .sheet(isPresented: $showingPasswordUpdateForm, content: {
                            if let librarian = selectedLibrarian {
                                LibrarianPasswordUpdateView(librarian: Binding(
                                    get: { librarian },
                                    set: { newValue in
                                        if let index = librarians.firstIndex(where: { $0.id == librarian.id }) {
                                            librarians[index] = newValue
                                        }
                                    }
                                ))
                            }
                        })
                }
                .padding()
                .background(Color.white) // Ensure background color is white
                .navigationBarItems(trailing: Button(action: {
                    showingCreateForm.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.title3)
                        .foregroundColor(.black)
                        .bold()
                })
                .sheet(isPresented: $showingCreateForm) {
                    // CreateLibrarianView()
                  CreateLibrarianView(librarians: $librarians)
                }
            }.background(Color.gray)
        }
    }

    // Computed property to filter librarians based on search query
    var filteredLibrarians: [Librarian] {
        if searchQuery.isEmpty {
            return librarians
        } else {
            return librarians.filter { $0.name.lowercased().contains(searchQuery.lowercased()) || $0.email.lowercased().contains(searchQuery.lowercased()) || $0.librarianID.lowercased().contains(searchQuery.lowercased()) }
        }
    }

    private func deleteLibrarian(at offsets: IndexSet) {
        librarians.remove(atOffsets: offsets)
    }
}
struct AdminSearchBar: View {
    @Binding var text: String
    @Binding var isActive: Bool
    var placeholder: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        @Binding var isActive: Bool

        init(text: Binding<String>, isActive: Binding<Bool>) {
            _text = text
            _isActive = isActive
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }

        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            isActive = true
            searchBar.setShowsCancelButton(true, animated: true)
        }

        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            isActive = false
            searchBar.setShowsCancelButton(false, animated: true)
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            text = ""
            searchBar.resignFirstResponder()
            isActive = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, isActive: $isActive)
    }

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField(placeholder, text: $text)
                .padding(.vertical, 10)
                .padding(.horizontal, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            Button(action: {
                // Handle microphone button action
            }) {
                Image(systemName: "mic.fill")
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .onTapGesture {
            isActive = true
        
        }
    }
}

