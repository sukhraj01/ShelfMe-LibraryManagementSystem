import SwiftUI



struct SignUPUIView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showWarning: Bool = false
    @State private var warningMessage: String = ""
    @State private var errorMessage: String = ""
    @State private var showOTPView: Bool = false
    @State private var showLoginView: Bool = false
    @State private var registrationSuccessful: Bool = false

    

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()

                VStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Sign up to unlock")
                            .font(.largeTitle)
                            .bold()
                            .multilineTextAlignment(.leading)
                            .alignmentGuide(.leading) { _ in 350 }

                        Text("stories")
                            .font(.largeTitle)
                            .bold()
                            .multilineTextAlignment(.leading)
                            .alignmentGuide(.leading) { _ in 350 }
                    }
                    .padding(.bottom, 20)

                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Name")
                                .font(.headline)
                            TextField("Your name", text: $name)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }

                        VStack(alignment: .leading, spacing: 5) {
                            Text("Email")
                                .font(.headline)
                            ZStack(alignment: .leading) {
                                if email.isEmpty {
                                    Text("name@domain.com")
                                        .foregroundColor(Color(.placeholderText)) // Use system placeholder color
                                        .padding(.leading, 8)
                                }
                                TextField("Your email", text: $email)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                            }
                        }

                        VStack(alignment: .leading, spacing: 5) {
                            Text("Create a Password")
                                .font(.headline)
                            SecureField("Password", text: $password)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 20)

                    // Reserve space for the warning message
                    VStack {
                        if showWarning {
                            Text(warningMessage)
                                .foregroundColor(.red)
                                .padding(.horizontal, 20)
                        } else {
                            Spacer()
                                .frame(height: 20) // Fixed height to reserve space for the warning
                        }
                    }
                    
                    
                    NavigationLink(destination:OTPVerificationView(name:name, email: email, password: password), isActive: $registrationSuccessful) {
                                            EmptyView()
                                        }
                                        .hidden()

                  Button(action: {
                    if name.isEmpty || email.isEmpty || password.isEmpty {
                      warningMessage = "All fields are required"
                      showWarning = true
                    } else if !isValidEmail(email) {
                      warningMessage = "Please enter a valid email address"
                      showWarning = true
                    } else {
                        showWarning = false
                        // Perform navigation only if all fields are filled
                        if !name.isEmpty && !email.isEmpty && !password.isEmpty {
                            register()
                            registrationSuccessful = true // Trigger navigation
                        }
                    }
                  }) {
                    Text("Sign Up")
                      .bold()
                      .frame(maxWidth: .infinity)
                      .padding()
                      .background(Color.black)
                      .foregroundColor(.white)
                      .cornerRadius(8)
                  }
                  .padding(.horizontal, 20)


                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)
                            .padding(.leading, 20)

                        Text("or")
                            .foregroundColor(.gray)

                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)
                            .padding(.trailing, 20)
                    }

                    VStack(spacing: 10) {
                     
                        Button(action: {
                            // Handle Google sign-up
                        }) {
                            HStack {
                                Image(systemName: "globe")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("Sign up with Google")
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 20)

                    Spacer()

                    HStack {
                        Text("Already have an account?")
                        NavigationLink(
                                                   destination: LoginView(),
                                                   isActive: $showLoginView
                                               )
                      {
                            Text("Log in here")
                                .underline()
                        }
                    }
                    .padding(.bottom, 20)
                }
                .padding(.top, 50) // Add top padding here
            }
        }.navigationBarBackButtonHidden(true)
    }

    func register() {
        guard let url = URL(string: "https://lms-hgdf.onrender.com/api/v1/auth/sendotp") else {
            return
        }

        let credentials = ["email": email, "password": password]

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
                    self.errorMessage = error?.localizedDescription ?? "Unknown error"
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) {
                do {
//                    let registrationResponse = try JSONDecoder().decode(UserRegistrationResponse.self, from: data)
//
//                    DispatchQueue.main.async {
//                        self.errorMessage = registrationResponse.message

//                    }
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

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
}

struct SignUPUIView_Previews: PreviewProvider {
    static var previews: some View {
        SignUPUIView()
    }
}
