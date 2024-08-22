import SwiftUI

struct LibrarianTabBarView: View {
    var user : LoggedInUser
    
    var body: some View {
        TabView {
            BookRequestView(user: user)
                .tabItem {
                    Label("Requests", systemImage: "externaldrive.badge.plus")
                    
                }
            
            
            LibrarianBookCatView()
                .tabItem {
                    Label("Books", systemImage: "books.vertical")
                }
            
            
            ScannerView()
                .tabItem {
                    Label("Return", systemImage: "return")
                }
            Scanner2CheckView()
                .tabItem {
                    Label("In Out", systemImage: "doc.viewfinder.fill")
                }
            
            
            
        }
        .navigationBarBackButtonHidden(true)
    }
}
