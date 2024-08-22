
import SwiftUI

struct AccountView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAccountSettings = false
    @State private var selectedImage: UIImage? = nil
    @EnvironmentObject var dataManager: DataManager
    @State private var isSignedOut = false
    
    var user : LoggedInUser
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationLink(destination: ProfileDetailView(selectedImage: $selectedImage, user: user)) {
                        ProfileRowView(image: selectedImage, user : user)
                    }
                }
                
                Section(header: Text("Membership")) {
                    HStack {
                        Text("Membership id")
                        Spacer()
                        Text("12345")
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("QR code")) {
                    NavigationLink(destination: QRCodeView(inputText: dataManager.user?._id ?? "abc")) {
                        Text("QR code")
                    }
                }
                
                Section(header: Text("Notifications")) {
                    NavigationLink(destination: NotificationsView()) {
                        Text("Notifications")
                    }
                }
                
                Section(header: Text("History")) {
                    NavigationLink(destination: HistoryView()) {
                        Text("History")
                    }
                }
                
                Section(header: Text("Analytics")) {
                    NavigationLink(destination: AnalyticsView()) {
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
