import SwiftUI

struct AdminTabBarView: View {
    
    var user : LoggedInUser
    
    var body: some View {
        TabView {
            HomeAnalyticsView()
                .tabItem {
                    Label("Home", systemImage: "house")
                    
                }
            
            AdminLibrarianManagementView()
                .tabItem {
                    Label("Add", systemImage: "plus.square")
                    
                }
            
            LendingPolicyView()
                .tabItem {
                    Label("Policies", systemImage: "pencil.and.list.clipboard")
                }
            
            
            AdminEventsView()
                .tabItem {
                    Label("Events", systemImage: "plus.viewfinder")
                }
            
            
            
        }
        .navigationBarBackButtonHidden(true)
    }
}
