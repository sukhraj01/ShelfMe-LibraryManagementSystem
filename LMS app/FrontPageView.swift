import SwiftUI

struct FrontPageView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                // Central Image
                Image("AppLogo") // Ensure this matches your image name in assets
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .padding(.bottom, 20)
                
                // Welcome Text
                Text("Welcome to ShelfMe")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                    .padding(.horizontal, 0)
                
                Text("Welcome to your library adventure, where every book is a new journey waiting to be discovered")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                // Buttons
                VStack(spacing: 20) {
                    NavigationLink(destination: OnboardingView()) { // Replace Text("User view") with your destination view
                        Text("I'm a User")
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                            .padding(.horizontal, 50)
                    }
                    
                    NavigationLink(destination: LoginView())  {
                        Text("I'm a Staff")
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                            .padding(.horizontal, 50)
                    }
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

struct WelcomeMainView: View {
    var body: some View {
        FrontPageView()
    }
}

struct FrontPage_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeMainView()
    }
}
