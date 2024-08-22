import SwiftUI

struct LibrarianPasswordUpdateView: View {
    @Binding var librarian: Librarian
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Update Password").font(.headline)) {
                    SecureField("New Password", text: $newPassword)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    SecureField("Confirm New Password", text: $confirmPassword)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }

                Section {
                    Button(action: {
                        if newPassword == confirmPassword && !newPassword.isEmpty {
                            librarian.password = newPassword
                            librarian.isPasswordSet = true
                            showingAlert = true
                        } else {
                            // Show error alert if passwords don't match or are empty
                            showingAlert = true
                        }
                    }) {
                        Text("Update Password")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationBarTitle("Update Password", displayMode: .inline)
            .alert(isPresented: $showingAlert) {
                if newPassword == confirmPassword && !newPassword.isEmpty {
                    return Alert(
                        title: Text("Success"),
                        message: Text("Password updated successfully."),
                        dismissButton: .default(Text("OK"))
                    )
                } else {
                    return Alert(
                        title: Text("Error"),
                        message: Text("Passwords do not match or are empty."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }
}

struct LibrarianPasswordUpdateView_Previews: PreviewProvider {
    @State static var librarian = Librarian(
        id: UUID(),
        username: "testUser",
        name: "Test Librarian",
        email: "test@example.com",
        librarianID: "lib123",
        role: "Staff",
        isActive: true,
        password: "",
        isPasswordSet: false,
        profilePic: nil,
        gender: "Male", // Placeholder value for gender
        address: "Sample Address" // Placeholder value for address
    )

    static var previews: some View {
        LibrarianPasswordUpdateView(librarian: $librarian)
    }
}

