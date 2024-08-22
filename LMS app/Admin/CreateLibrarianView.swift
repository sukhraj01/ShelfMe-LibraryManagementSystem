import SwiftUI
import UIKit

struct CreateLibrarianView: View {
    @Binding var librarians: [Librarian]
    @State private var profilePic: UIImage? = UIImage(named: "profilepic")
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var gender: String = ""
    @State private var phoneNumber: String = ""
    @State private var email: String = ""
    @State private var address: String = ""
    @State private var shift: String = ""
    @State private var librarianEmail: String = "" // Changed from librarianID
    @State private var libraryEmail: String = ""
    @State private var accountCreationDate: Date = Date()
    @State private var password: String = ""
    @State private var showingAlert = false
    @Environment(\.presentationMode) var presentationMode
    @State private var showImagePicker: Bool = false
    @State private var selectedGenderIndex = 0
    private let genders = ["Male", "Female", "Other"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text("Personal Information")
                    .bold()
                    .padding(.leading,-180)
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.top, 3)
                
                personalInformationSection
                
                Text("Contact Information")
                    .bold()
                    .padding(.leading,-180)
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.top, 16)
                
                contactInformationSection
                
                Text("Account Information")
                    .bold()
                    .padding(.leading,-180)
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.top, 16)
                
                accountInformationSection
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .navigationBarTitle("New Librarian Details", displayMode: .inline)
            .navigationBarItems(leading: cancelButton, trailing: doneButton)
            .sheet(isPresented: $showImagePicker) {
                //ImagePicker(image: $profilePic)
            }
        }
        .background(Color.white)
    }
    
    // Personal Information Section
    var personalInformationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack {
                HStack {
                    Text("First Name:")
                        .padding(.top,12)
                        .frame(width: 150, alignment: .leading)
                    TextField("Enter First Name", text: $firstName)
                        .padding(.top,12)
                        .padding(.leading,40)
                        .background(Color.white)
                        .cornerRadius(8)
                }
                Divider()
                
                HStack {
                    Text("Last Name:")
                        .frame(width: 150, alignment: .leading)
                    TextField("Enter Last Name", text: $lastName)
                        .padding(.leading,40)
                        .background(Color.white)
                        .cornerRadius(8)
                }
                Divider()
                
                HStack {
                    Text("Date Of Birth:")
                        .frame(width: 150, alignment: .leading)
                    DatePicker("", selection: $dateOfBirth, displayedComponents: .date)
                        .background(Color.white)
                        .cornerRadius(8)
                }
                Divider()
                
                HStack {
                    Text("Gender:")
                        .frame(width: 150, alignment: .leading)
                        .padding(.leading,-210)
                    Picker(selection: $selectedGenderIndex, label: Text("Gender")) {
                        ForEach(0 ..< genders.count) {
                            Text(self.genders[$0]).tag($0)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .padding(.leading,180)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
    }
    
    // Contact Information Section
    var contactInformationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack {
                HStack {
                    Text("Phone Number:")
                        .padding(.top,12)
                        .frame(width: 150, alignment: .leading)
                    TextField("Phone Number", text: $phoneNumber)
                        .padding(.leading,40)
                        .padding(.top,12)
                        .background(Color.white)
                        .cornerRadius(8)
                }
                Divider()
                
                HStack {
                    Text("Email:")
                        .frame(width: 150, alignment: .leading)
                    TextField("Enter Email", text: $email)
                        .padding(.leading,40)
                        .background(Color.white)
                        .cornerRadius(8)
                }
                Divider()
                
                HStack {
                    Text("Address:")
                        .frame(width: 150, alignment: .leading)
                    TextField("Enter Address", text: $address)
                        .padding(.leading,40)
                        .background(Color.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
    }
    
    // Account Information Section
    var accountInformationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack {
                HStack {
                    Text("Librarian Email:") // Changed from "Librarian ID"
                        .padding(.top,12)
                        .frame(width: 150, alignment: .leading)
                    TextField("Enter Librarian Email", text: $librarianEmail) // Changed from "Enter Librarian ID"
                        .padding(.leading,40)
                        .padding(.top,12)
                        .background(Color.white)
                        .cornerRadius(8)
                }
                Divider()
                
                HStack {
                    Text("Account Creation Date:")
                        .frame(width: 150, alignment: .leading)
                    DatePicker("", selection: $accountCreationDate, displayedComponents: .date)
                        .background(Color.white)
                        .cornerRadius(8)
                }
                Divider()
                
                HStack {
                    Text("Password:")
                        .frame(width: 150, alignment: .leading)
                    SecureField("Enter Password", text: $password)
                        .padding(.leading,40)
                        .background(Color.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
    }
    
    // Cancel Button
    var cancelButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Cancel")
                .foregroundColor(.red)
        }
    }
    
    // Done Button
    var doneButton: some View {
        Button(action: {
            createLibrarian()
            register()
        }) {
            Text("Create")
                .bold()
        }
    }
    
    func register() {
        
        guard let url = URL(string: "https://lms-hgdf.onrender.com/api/v1/auth/signup") else {
            return
        }
        
        var credentials: [String: Any] = [:]
        credentials["name"] = firstName
        credentials["email"] = librarianEmail
        credentials["password"] = password
        credentials["actType"] = "Librarian"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: credentials, options: []) else {
            return
        }
        
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
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
                    print(registrationResponse)
                    DispatchQueue.main.async {
                        
                        if statusCode == 200 {
                            print(registrationResponse)
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                    }
                } catch {
                    DispatchQueue.main.async {
                    }
                }
            } else {
                if let errorDataString = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                    }
                } else {
                    DispatchQueue.main.async {
                    }
                }
            }
        }.resume()
    }
    
    private func createLibrarian() {
        let newLibrarian = Librarian(
            id: UUID(),
            username: "\(firstName) \(lastName)",
            name: "\(firstName) \(lastName)",
            email: email,
            librarianID: librarianEmail,
            role: "Staff",
            isActive: true,
            password: password,
            isPasswordSet: true,
            profilePic: profilePic,
            phoneNumber: phoneNumber,
            accountCreationDate: accountCreationDate,
            gender: genders[selectedGenderIndex], // Assign the selected gender
            address: address // Assign the address
        )
        librarians.append(newLibrarian)
        presentationMode.wrappedValue.dismiss()
    }
}
    struct CreateLibrarianView_Previews: PreviewProvider {
        @State static var librarians = [Librarian]()
        static var previews: some View {
            CreateLibrarianView(librarians: $librarians)
        }
    }
