//
//  LShiftView.swift
//  LibraryProfile
//
//  Created by PRIYANSHU MISHRA on 13/06/24.
//

import SwiftUI

struct LShiftView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                // Date of Shift Section
                Section(header: Text("Current Date")) {
                    HStack {
                        Text("5 June 2024")
                        Spacer()
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                    }
                }

                Section(header: Text("Details").font(.title2).bold().foregroundStyle(.black)) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                        VStack(alignment: .leading) {
                            Text("Date of shift")
                                .font(.headline)
                            Text("June 5, 2024")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                        VStack(alignment: .leading) {
                            Text("Duration of Shift")
                                .font(.headline)
                            Text("10:00 AM - 8:00 PM")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    
                    HStack {
                        Image(systemName: "house")
                            .foregroundColor(.gray)
                        VStack(alignment: .leading) {
                            Text("Location")
                                .font(.headline)
                            Text("Reading Hall")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationBarTitle("Account", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct LShiftDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LShiftView()
    }
    
}




