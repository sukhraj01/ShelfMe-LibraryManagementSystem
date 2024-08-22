//
//  NotificationsView.swift
//  NewProject
//
//  Created by PRIYANSHU MISHRA on 11/06/24.
//

import SwiftUI

struct UserNotificationsView: View {
    var body: some View {
        Form{
            Section(header: Text("New")){
                Text("Congratulations! Book is now issued  ✨")
                Text("Book is now live! 🥳 ")
            }
            Section(header: Text("Today")){
                Text("Fee pending for Atomic Habits 📕")
                Text("Congratulations! Book is now issued ✨")
                Text("Book is now live! 🥳")
            }
            Section(header: Text("Yesterday")){
                Text("Fee pending for It ends with us 📕")
                Text("Fee pending for Habits 📕")
                Text("Fee pending for Patience 📕")
                Text("Congratulations! Book is now issued ✨")
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct UserNotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        UserNotificationsView()
    }
}
