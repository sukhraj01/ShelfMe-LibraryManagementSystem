//
//  MainDoctorView.swift
//  Hospital-Management-System
//
//  Created by MACBOOK on 30/05/24.
//

import SwiftUI

struct UserTabBarView: View {
//    @EnvironmentObject var dataManager: DataManager
    
    var user : LoggedInUser
    
    var body: some View {
        TabView {
            HomeUIView(user : user )
                .tabItem {
                    Label("Home", systemImage: "house")
                    
                }
            
            SearchView()
                .tabItem {
                    Label("Discover", systemImage: "magnifyingglass")
                    
                }
            
            IssuedBookRequest()
                .tabItem {
                    Label("Dashboard", systemImage: "books.vertical")
                }
            
            
            BookIssueView()
                .tabItem {
                    Label("Request Book", systemImage: "book.closed.fill")
                }
            
            
            
        }
        .navigationBarBackButtonHidden(true)
    }
}

