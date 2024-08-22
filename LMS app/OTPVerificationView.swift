import SwiftUI



struct OTPVerificationView: View {
    @State private var otp = ["", "", "", ""]
    @State private var timer = 60
    @State private var isTimerActive = true
    @State private var isResendEnabled = false
    @State private var errorMessage: String = ""
    @State private var showOTPView: Bool = false
    @State private var registrationSuccessful: Bool = false
    @State private var finalOTP: Int = 0
    @State private var navigateToHome: Bool = false
    
    let name: String
    let email: String
    let password: String

    var body: some View {
        NavigationView {
            VStack {
                Text("OTP Verification")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40) // Add some padding to the top
                    .padding(.bottom, 20)

                Text("Your verification code has been sent to")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(email) // Display the email passed from the sign-up view
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)

                HStack {
                                    ForEach(0..<4, id: \.self) { index in
                                        TextField("", text: $otp[index])
                                            .frame(width: 50, height: 50)
                                            .multilineTextAlignment(.center)
                                            .background(Color.white)
                                            .cornerRadius(5)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.gray, lineWidth: 1)
                                            )
                                            .keyboardType(.numberPad)
                                    }
                                }
                                .padding(.bottom, 20)

                // Timer and resend OTP code button code...

                Button(action: {
                    // Verify OTP action
                    convertotp()
                    register()
                }) {
                    Text("Verify")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(5.0)
                        .font(.headline)
                }
                NavigationLink("", destination: LoginView(), isActive: $navigateToHome)
                                    .hidden()

                Spacer()
            }
            .padding()
            
        }.navigationBarBackButtonHidden(true)
        .onAppear {
            print(name)
            print(password)
            print("Email from sign-up:", email) // Print the email into the console
        }
    }
    
    func convertotp(){
        let otpString = otp.joined()
                if let otpValue = Int(otpString) {
                    finalOTP = otpValue
                    print("Final OTP:", finalOTP)
                    // Proceed with the OTP verification or other actions
                } else {
                    errorMessage = "Invalid OTP"
                }
    }
    
    func register() {
        
        guard let url = URL(string: "https://lms-hgdf.onrender.com/api/v1/auth/signup") else {
            return
        }

        var credentials: [String: Any] = [:]
                    credentials["name"] = name
                    credentials["email"] = email
                    credentials["password"] = password
                    credentials["otp"] = finalOTP

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
            
            if let jsonString = String(data: data, encoding: .utf8) {
                        print("Received JSON data: \(jsonString)")
                    }

            if let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) {
                do {
                    let statusCode = httpResponse.statusCode
                    print(statusCode)
                    
                    let registrationResponse = try JSONDecoder().decode(UserRegistrationResponse.self, from: data)
                    print("printttttt ottpppppppp")
                    print(registrationResponse)
                    DispatchQueue.main.async {
                        self.errorMessage = registrationResponse.message
                        
                        self.showOTPView = self.registrationSuccessful // Update showOTPView based on registrationSuccessful
                        if statusCode == 200 {
                                                self.navigateToHome = true // Set navigateToHome to true if status code is 200
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
    
}

struct OTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        OTPVerificationView(name: "John Doe", email: "sample@example.com", password: "password123")
    }
}
