//
//  AdAccountView.swift
//  AdminProfile
//
//  Created by PRIYANSHU MISHRA on 13/06/24.
//

import SwiftUI

struct AdAccountView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAccountSettings = false
    @State private var isSignedOut = false


    var body: some View {
        NavigationView {
            Form {
                Section {
                    AdProfileRowView()
                }
                
//                Section(header: Text("Email")) {
//                    HStack {
//                        Text("Email")
//                        Spacer()
//                        Text("khushiverma@gmail.com")
//                            .foregroundColor(.secondary)
//                    }
//                }
                
                Section {
                    HStack{
                        Text("Phone Number")
                        Spacer()
                        Text("9876543219")
                            .foregroundStyle(.secondary)
                    }
                    HStack{
                        Text("Location")
                        Spacer()
                        Text("Mysore,Karnataka")
                            .foregroundStyle(.secondary)
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
