import SwiftUI

struct LaunchScreenView: View {
    @State private var navigateToLogin = false
    @State private var animate = false

    var body: some View {
        if navigateToLogin {
            
            FrontPageView()
        } else {
            VStack {
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 500, height: 400)
                    .scaleEffect(animate ? 1 : 0.5) // Scale effect
                    .opacity(animate ? 1 : 0) // Opacity effect
                    .animation(.easeInOut(duration: 2), value: animate) // Combined animation
            }
            .onAppear {
                startAnimationSequence()
            }
        }
    }

    func startAnimationSequence() {
        animate = true // Trigger the combined animation

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            navigateToLogin = true
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
