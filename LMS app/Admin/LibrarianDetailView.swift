import SwiftUI

struct LibrarianDetailView: View {
    @State private var isAccountActive = true
    @State private var showAlert = false
    @State private var navigateToAdminLibrarianManagement = false
    @State private var isEditing = false // Track whether editing mode is active
    @State private var shift = Shift(date: Date(), startTime: Date(), finishTime: Date(), location: "Reading Hall", days: "Monday to Friday") // Track shift information

    @State private var editedLibrarian: Librarian // Track changes in a separate state
    @State private var displayedLibrarian: Librarian // Track displayed librarian

    init(librarian: Librarian) {
        self._displayedLibrarian = State(initialValue: librarian)
        self._editedLibrarian = State(initialValue: librarian)
    }

    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack {
                    if let profilePic = displayedLibrarian.profilePic {
                        Image(uiImage: profilePic)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 150, height: 150)
                            .padding(.top, 20)
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                    }

                    Text(displayedLibrarian.name)
                        .font(.title)
                        .padding(.top, 10)
                        .foregroundColor(Color.black)
                        .padding(.bottom, 30)

                    VStack {
//                        ListItem(title: "Librarian Id", value: editedLibrarian.librarianID)
                    }
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 10)

                    VStack {
                        ListItem(title: "Library email Id", value: editedLibrarian.email)
                        ListItem(title: "Phone Number", value: editedLibrarian.phoneNumber ?? "No Phone Number")
                        
                        // LibrarianDetailView
                        ListItem(title: "Address", value: editedLibrarian.address)

                        // LibrarianDetailView
                        ListItem(title: "Gender", value: editedLibrarian.gender)

                    }
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 10)

                    VStack {
                        ListItem(title: "Personal email Id", value: editedLibrarian.email)
                        ListItem(title: "Password", value: "123456")
                        ListItem(title: "Account creation Date", value: DateFormatter.localizedString(from: editedLibrarian.accountCreationDate, dateStyle: .medium, timeStyle: .none))
                        HStack {
                            Text("Status")
                            Spacer()
                            Toggle("", isOn: $isAccountActive)
                                .labelsHidden()
                        }
                        .padding(.vertical, 8)
                        Divider()
                    }
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 10)

                    VStack {
                        NavigationLink(destination: ShiftDetailsView()) {
                            HStack {
                                Text("Shift")
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 10)

                    Spacer()

                    if isEditing {
                        // Save Button
                        Button(action: {
                            // Save the changes
                            displayedLibrarian = editedLibrarian
                            isEditing.toggle()
                        }) {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                                .padding(.horizontal, 20)
                        }
                        .padding(.bottom, 20)
                    } else {
                        // Delete Librarian Button
                        Button(action: {
                            showAlert = true
                        }) {
                            Text("Delete Librarian")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.red)
                                .cornerRadius(8)
                                .padding(.horizontal, 20)
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Confirm Deletion"),
                                  message: Text("Are you sure you want to delete this librarian?"),
                                  primaryButton: .destructive(Text("Delete")) {
                                      // Handle deletion
                                      navigateToAdminLibrarianManagement = true
                                  },
                                  secondaryButton: .cancel())
                        }
                        .padding(.bottom, 20)
                    }
                }
                .padding()
                .navigationBarTitle("")
                .navigationBarItems(trailing:
                    Button(action: {
                        isEditing.toggle() // Toggle editing mode
                    }) {
                        Text(isEditing ? "Done" : "Edit") // Change button text based on editing mode
                            .bold()
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .cornerRadius(6)
                            .foregroundColor(Color.blue)
                    }
                )
            }
        }
    }
}

struct ListItem: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                Spacer()
                Text(value)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
            Divider()
        }
    }
}

struct LibrarianDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LibrarianDetailView(librarian: Librarian(
            username: "ybansal",
            name: "Yogesh Bansal",
            email: "ybansal@gmail.com",
            librarianID: "56723",
            role: "Librarian",
            isActive: true,
            password: "123456",
            isPasswordSet: true,
            profilePic: UIImage(systemName: "person.crop.circle"),
            phoneNumber: "9678906321",
            accountCreationDate: Date(),
            gender: "Male", // Provide a dummy gender value
            address: "Sample Address" // Provide a dummy address value
        ))
    }
}

