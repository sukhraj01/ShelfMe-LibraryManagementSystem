import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var emailWarning = ""
    @State private var passwordWarning = ""
    @State private var errorMessage: String = ""
    @State private var navigateToHome = false
    @EnvironmentObject var dataManager: DataManager
    @State private var navigateToLibrarianView = false
    @State private var navigateToTabBar = false
    @State private var navigateToAdmin = false
    @State private var navigateToSignUp = false
    @State private var fetchedData: FetchedDataResponse?
    
    @State private var token: String? {
        didSet {
            if let token = token {
                UserDefaults.standard.set(token, forKey: "userToken")
                
            } else {
                UserDefaults.standard.removeObject(forKey: "userToken")
            }
        }
    }
    
    // Storing UserDatabase Id
    @State private var DatabaseId: String? {
        didSet {
            if let DatabaseId = DatabaseId {
                UserDefaults.standard.set(DatabaseId, forKey: "userDatabaseBaseId")
            } else {
                UserDefaults.standard.removeObject(forKey: "userDatabaseBaseId")
            }
        }
    }
    
    // Storing UserName
    @State private var LoggedInMemeberName: String? {
        didSet {
            if let memberName = LoggedInMemeberName {
                UserDefaults.standard.set(memberName, forKey: "memberName")
            } else {
                UserDefaults.standard.removeObject(forKey: "memberName")
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                
                VStack(alignment: .leading) {
                    Text("Email")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    TextField("Your email", text: $email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5.0)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.bottom, 5)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    if !emailWarning.isEmpty {
                        Text(emailWarning)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.bottom, 20)
                    } else {
                        Spacer().frame(height: 20)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Password")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5.0)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.bottom, 5)
                    
                    if !passwordWarning.isEmpty {
                        Text(passwordWarning)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.bottom, 20)
                    } else {
                        Spacer().frame(height: 20)
                    }
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        // Action for forgot password
                    }) {
                        Text("Forgot Password?")
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.bottom, 40)
                
                Button(action: {
                    fetchData()
                    
                    validateInputs()
                    if emailWarning.isEmpty && passwordWarning.isEmpty {
                        login()
                    }
                }) {
                    Text("Next")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(5.0)
                        .font(.headline)
                }
                .padding(.bottom, 20)
                if let user = dataManager.user{
                    NavigationLink(destination: UserTabBarView(user: user ), isActive: $navigateToTabBar) {
                        EmptyView()
                    }
                }
                
                if let user = dataManager.user{
                    NavigationLink(destination: LibrarianTabBarView(user: user), isActive: $navigateToLibrarianView) {
                        EmptyView()
                    }
                }
                if let user = dataManager.user{
                    NavigationLink(destination: AdminTabBarView(user: user), isActive: $navigateToAdmin) {
                        EmptyView()
                    }
                }
                
                
                
                
                HStack {
                    Divider()
                        .frame(width: 100, height: 1)
                    Text("or")
                        .foregroundColor(.gray)
                    Divider()
                        .frame(width: 100, height: 1)
                }
                .padding(.bottom, 20)
                
                Button(action: {
                    // Action for login with Google
                }) {
                    HStack {
                        Image(systemName: "globe")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Log in with Google")
                            .font(.headline)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.black)
                    .cornerRadius(5.0)
                }
                .padding(.bottom, 20)
                
                //                Spacer() // Push content to the top
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                    NavigationLink(destination: SignUPUIView(), isActive: $navigateToSignUp) {
                        Button(action: {
                            navigateToSignUp = true
                        }) {
                            Text("Sign Up")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding(.bottom, 20)
                
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if let savedToken = UserDefaults.standard.string(forKey: "userToken") {
                token = savedToken
                navigateToHome = true
            }
            
            if let savedUserDatabaseID = UserDefaults.standard.string(forKey: "userDatabaseBaseId") {
                DatabaseId = savedUserDatabaseID
                fetchUserDetails(userId: savedUserDatabaseID)
                print("User Data Base Id : \(String(describing: DatabaseId))")
            }
        }
    }
    
    func fetchUserDetails(userId:String) {
        
        guard let url = URL(string: "https://lms-hgdf.onrender.com/api/v1/auth/\(userId)") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    //                    print("JSON Response: \(json)")
                    
                    if let name = json["name"] as? String {
                        print("Logged In Username: \(name)")
                        
                        self.LoggedInMemeberName = name;
                        
                    } else {
                        print("No Name")
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    // Fetching Book Data
    func fetchData() {
        guard let url = URL(string: "https://lms-hgdf.onrender.com/api/v1/book/all") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        
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
                    let fetchedData = try JSONDecoder().decode(FetchedDataResponse.self, from: data)
                    DispatchQueue.main.async {
                        
                        self.fetchedData = fetchedData
                        self.dataManager.fetchedData = fetchedData
                        //                        print(self.dataManager.fetchedData)
                        // Handle fetched data
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error decoding response: \(error.localizedDescription)"
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
    
    // Login The User
    func login() {
        guard let url = URL(string: "https://lms-hgdf.onrender.com/api/v1/auth/login") else {
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
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                    DispatchQueue.main.async {
                        if loginResponse.success {
                            
                            print(loginResponse.user)
                            
                            self.dataManager.user = loginResponse.user
                            
                            
                            
                            if loginResponse.user.accountType == "Librarian" {
                                self.navigateToLibrarianView = true
                            } else if(loginResponse.user.accountType == "User") {
                                self.navigateToTabBar = true
                            }
                            else if(loginResponse.user.accountType == "Admin"){
                                self.navigateToAdmin = true
                            }
                            self.token = loginResponse.user.token
                            self.DatabaseId = loginResponse.user._id
                            self.navigateToHome = true
                            
                            if let savedUserDatabaseID = UserDefaults.standard.string(forKey: "userDatabaseBaseId") {
                                DatabaseId = savedUserDatabaseID
                                
                                print("User Data Base Id : \(String(describing: savedUserDatabaseID))")
                            }
                            
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
    
    func validateInputs() {
        if email.isEmpty {
            emailWarning = "Email cannot be empty"
        } else if !isValidEmail(email) {
            emailWarning = "Invalid email format"
        } else {
            emailWarning = ""
        }
        
        if password.isEmpty {
            passwordWarning = "Password cannot be empty"
        } else {
            passwordWarning = ""
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}




struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
