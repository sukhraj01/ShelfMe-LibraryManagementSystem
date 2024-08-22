//
//  OnboardingScreen.swift
//  LMSaPP
//
//  Created by Khushi Verma on 29/05/24.
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    @State private var currentIndex = 0
    
    let onboardingScreens = [
        OnboardingScreen(imageName: "screen1", text: "Discover endless books\nat your fingertips."),
        OnboardingScreen(imageName: "screen2", text: "Search and explore\nendless genres!")
    ]
    
    var body: some View {
        VStack {
            TabView(selection: $currentIndex) {
                ForEach(0..<onboardingScreens.count, id: \.self) { index in
                    VStack {
                        Image(onboardingScreens[index].imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 300, maxHeight: 600)
                        
                        Text(onboardingScreens[index].text)
                            .font(.caption)
                            .padding()
                            .multilineTextAlignment(.center)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            
            HStack {
                ForEach(0..<onboardingScreens.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.black : Color.gray)
                        .frame(width: 10, height: 10)
                        .padding(.horizontal, 4)
                }
            }
            .padding(.top)
        }
        .navigationBarHidden(true)
        .overlay(
            NavigationLink(destination: SignUPUIView()){
                        Text("done")
                            .foregroundColor(.blue)
                            .padding()
                    }
                    .padding([.top, .trailing], -10)
                    .opacity(currentIndex == 1 ? 1 : 0) // Show only on the second screen
                    , alignment: .topTrailing
                )
            }
        }
        


struct OnboardingScreen {
    let imageName: String
    let text: String
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
