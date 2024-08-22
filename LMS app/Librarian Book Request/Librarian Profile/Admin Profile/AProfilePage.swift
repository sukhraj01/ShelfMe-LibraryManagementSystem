//
//  AProfilePage.swift
//  AdminProfile
//
//  Created by PRIYANSHU MISHRA on 13/06/24.
//

import SwiftUI

struct AProfilePage: View {
    @State private var showingAccountView = false

    var body: some View {
        VStack {
            Button("Show Account") {
                showingAccountView.toggle()
            }
            .sheet(isPresented: $showingAccountView) {
                AdAccountView()
            }
        }
    }
}

struct LProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        AProfilePage()
    }
}
