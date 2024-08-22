import SwiftUI

struct ProfileView: View {
    var body: some View {
        Text("Profile View")
            .font(.largeTitle)
    }
}

struct BookRequestView: View {
    @StateObject private var viewModel = BookRequestViewModel()
    @State private var isProfilePresented = false
    @State private var showVacantSeatsView = false
    
    var user : LoggedInUser
    
    var body: some View {
        NavigationView {
            VStack {
    
                List(viewModel.filteredBookRequests) { bookRequest in
                    NavigationLink(destination: BookAcceptView(bookRequest: bookRequest)) {
                        BookRequestRow(bookRequest: bookRequest)
                    }
                }
                }
                .navigationTitle("Book Request")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isProfilePresented.toggle()
                        }) {
                            Image(systemName: "person.crop.circle")
                        }
                        .sheet(isPresented: $isProfilePresented) {
                            LAccountView(user : user)
                        }
                        Button(action: {
                            showVacantSeatsView.toggle()
                        }) {
                            Image(systemName: "carseat.left.fill")
                                .foregroundColor(.black)
                        }
                        .sheet(isPresented: $showVacantSeatsView) {
                            
                                VacantSeatModalView(isPresented: $showVacantSeatsView)
                            
                        }
                    }
                
            }
                .onAppear {
                                viewModel.fetchData()
                            }
        }
    }
}
