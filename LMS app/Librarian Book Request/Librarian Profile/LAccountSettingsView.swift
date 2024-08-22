//
//  LAccountSettingsView.swift
//  LibraryProfile
//
//  Created by PRIYANSHU MISHRA on 13/06/24.
//

import SwiftUI

struct LAccountSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var ActivityStatus = true

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Change password")
                }
                
                Section {
                    Text("Country/Region")
                    Text("Ratings and Reviews")
                }
                
                Section(header: Text("Activity Status")) {
                    Toggle(isOn: $ActivityStatus) {
                        Text("Activity Status")
                    }
                }
                
                Section {
                    Text("Privacy Policy")
                        .foregroundColor(.blue)
                }
                
                Section {
                    Text("Terms of service")
                        .foregroundColor(.blue)
                    Text("Manage accounts")
                        .foregroundColor(.blue)
                }
            }
            .navigationBarTitle("Account Settings", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct LAccountSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        LAccountSettingsView()
    }
}
