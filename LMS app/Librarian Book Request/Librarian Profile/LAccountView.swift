//
//  LAccountView.swift
//  LibraryProfile
//
//  Created by PRIYANSHU MISHRA on 13/06/24.
//



import SwiftUI

struct LAccountView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAccountSettings = false
    @State private var selectedImage: UIImage? = nil
    @State private var isSignedOut = false
    
    var user : LoggedInUser

    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationLink(destination: LProfileDetailView(selectedImage: $selectedImage)) {
                        LProfileRowView(image: selectedImage)
                    }
                }
                
                Section {
                    HStack {
                        Text("Librarian id")
                        Spacer()
                        Text("\(user._id)")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Position")) {
                    HStack{
                        Text("Designation")
                        Spacer()
                        Text("\(user.accountType)")
                            .foregroundStyle(.secondary)
                    }
                }
                
                Section(header: Text("Notifications")) {
                    NavigationLink(destination: LNotificationsView()) {
                        Text("Notifications")
                    }
                }
                
                Section {
                    NavigationLink(destination: LShiftView()) {
                        Text("Shift")
                    }
                    HStack{
                        Text("Joining Date")
                        Spacer()
                        Text("21 June 2024")
                            .foregroundStyle(.secondary)
                    }
                }
                
                Section(header: Text("Analytics")) {
                    NavigationLink(destination: LAnalyticsView()) {
                        Text("Analytics")
                    }
                }
                
                Section(header: Text("Account Settings")) {
                    Button(action: {
                        showingAccountSettings.toggle()
                    }) {
                        Text("Account Settings")
                    }
                }
                
                Section {
                    Button(action: {
                        handleSignOut()
                    }) {
                        Text("Sign out")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Account", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $showingAccountSettings) {
                AccountSettingsView()
            }
            .fullScreenCover(isPresented: $isSignedOut) {
                LoginView()
            }
        }
    }
    
    private func handleSignOut() {
        // Handle any sign out logic here, such as clearing user data
        isSignedOut = true
    }
}
