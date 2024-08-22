
import SwiftUI

import Foundation
struct IssuedBookRequest: View {
    @State private var userData: User2?
    
    @State private var selectedTab = 0
    @State private var bookDatabaseID: String = "";
    
    
    @State private var requests: [IssuedBook2]?
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Dashboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading,-150)
                    .padding(.top,40)
                
                Picker(selection: $selectedTab, label: Text(""), content: {
                    Text("Request").tag(0)
                    Text("Issued Books").tag(1)
                })
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal) // Added horizontal padding
                .padding(.top, -10)
                
                ScrollView {
                    VStack(spacing: 10) {
                        if selectedTab == 0 {
                            if let requests = requests {
                                RequestView(requests: requests)
                            } else {
                                Text("Loading...")
                            }
                        } else {
                            if let requests = requests {
                                IssuedBooksView(requests: requests)
                            } else {
                                Text("Loading...")
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                .padding(.top, 10)
            }
            .background(Color(UIColor.systemGray6))
            .navigationBarHidden(true)
            .onAppear(){
                if let savedUserDatabaseID = UserDefaults.standard.string(forKey: "userDatabaseBaseId") {
                    print("User Data Base Id : \(String(describing: savedUserDatabaseID))")
                    
                    fetch(userID: savedUserDatabaseID)
                }
                
            }
        }
    }
    
    func fetch(userID: String){
        guard let url = URL(string: "https://lms-hgdf.onrender.com/api/v1/auth/\(userID)") else {
                return
            }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.requests = []
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse,
               (200...299).contains(httpResponse.statusCode) {
                do {
    
                    let fetchedData = try JSONDecoder().decode(User2.self, from: data)
                    DispatchQueue.main.async {
                        self.userData = fetchedData
                        self.requests = fetchedData.issuedBooks
                        
                        print("data from backedn")
                        print(fetchedData)
                        
                    }
                } catch {
                    print("Decoding error: \(error)")
                    DispatchQueue.main.async {

                    }
                }
            } else {
                if let errorDataString = String(data: data, encoding: .utf8) {
                    print("Server error: \(errorDataString)")
                    DispatchQueue.main.async {
                    }
                } else {
                    print("Unknown server error")
                    DispatchQueue.main.async {
                    }
                }
            }
        }.resume() 
    }
}


struct RequestView: View {
    var requests: [IssuedBook2]
    var body: some View {
        VStack {
            ForEach(requests.filter { $0.status == "pending" }, id: \.self._id) { request in
//                    Text("Title: \(request.bookName), Status: \(request.status)")
                    
                    HStack{
                        Image("book_cover_placeholder")
                            .resizable()
                            .frame(width: 50, height: 70)
                            .cornerRadius(5)
                        VStack(alignment: .leading) {
                            Text(request.bookName)
                                .font(.headline)
                            Text("\(request.bookIsbn)")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        
                        VStack(alignment: .trailing) {
                            Text("Statue")
                                .font(.subheadline)
                            Text("Pending")
                                .foregroundColor(.red)
                        }
                        
                    }
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.white) // Keep card background white
                    .cornerRadius(10) // Add corner radius for better appearance
                    .shadow(radius: 5) // Add shadow for better appearance
                    
                }
            }
            .onAppear {
                print("Requests: \(requests)")
            }
    }
}

struct IssuedBooksView: View {
    var requests: [IssuedBook2]

    var body: some View {
        VStack {
            ForEach(requests.filter { $0.status == "approved" }, id: \.self._id) { request in
//                    Text("Title: \(request.bookName), Status: \(request.status)")
                    
                    HStack{
                        Image("book_cover_placeholder")
                            .resizable()
                            .frame(width: 50, height: 70)
                            .cornerRadius(5)
                        VStack(alignment: .leading) {
                            Text(request.bookName)
                                .font(.headline)
                            Text("\(request.bookIsbn)")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        
                        VStack(alignment: .trailing) {
                            Text("Due Date")
                                .font(.subheadline)
                            Text("17/10/2025")
                                .foregroundColor(.red)
                        }
                        
                    }
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.white) // Keep card background white
                    .cornerRadius(10) // Add corner radius for better appearance
                    .shadow(radius: 5) // Add shadow for better appearance
                    
                }
            }
            .onAppear {
                print("Requests: \(requests)")
            }
    }
}
