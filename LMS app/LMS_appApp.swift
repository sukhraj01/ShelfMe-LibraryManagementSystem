//
//  LMS_appApp.swift
//  LMS app
//
//  Created by Apple on 24/05/24.
//

import SwiftUI

class DataManager: ObservableObject {
    @Published var fetchedData: FetchedDataResponse?
    @Published var user: LoggedInUser?
    @Published var libraryData: LibraryDetail?
}

@main
struct LMS_appApp: App {
    @StateObject var dataManager = DataManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
            
        }
    }
}
