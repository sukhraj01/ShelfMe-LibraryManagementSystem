

import SwiftUI

struct LibrarianBookCatView: View {
    
    
    // Define constants for image and text sizes
    let imageWidth: CGFloat = 100
    let imageHeight: CGFloat = 100
    let textSize: CGFloat = 15
    
    @State private var selectedLanguage = "English"
    
    var categories: [(String, String)] {
        switch selectedLanguage {
        case "Spanish":
            return categoriesSpanish
        case "Hindi":
            return categoriesHindi
        case "Punjabi":
            return categoriesPunjabi
        case "Sanskrit":
            return categoriesSanskrit
        default:
            return categoriesEnglish
        }
    }
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Text("Books")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading)
                        .foregroundColor(.black) // Set text color to black
                    Spacer()
                    Button(action: {
                        // Action for add button
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .padding(.trailing)
                    }
                }
                .padding(.top, 10)
                
                HStack {
                    TextField("Search", text: .constant(""))
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.leading)
                    
                    Button(action: {
                        // Action for microphone button
                    }) {
                        Image(systemName: "mic.fill")
                            .padding(.trailing)
                    }
                }
                .padding(.top, 10)
                
                HStack {
                    Spacer()
                    Menu {
                        Button("English", action: {
                            selectedLanguage = "English"
                        })
                        Button("Spanish", action: {
                            selectedLanguage = "Spanish"
                        })
                        Button("Hindi", action: {
                            selectedLanguage = "Hindi"
                        })
                        Button("Punjabi", action: {
                            selectedLanguage = "Punjabi"
                        })
                        Button("Sanskrit", action: {
                            selectedLanguage = "Sanskrit"
                        })
                        // Add more languages here
                    } label: {
                        HStack {
                            Text(selectedLanguage)
                                .foregroundColor(.black) // Set text color to black
                            Image(systemName: "chevron.down")
                        }
                        .padding(.trailing)
                    }
                }
                .padding(.top, 10)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem()], spacing: 20) {
                        ForEach(categories, id: \.0) { category in
                            NavigationLink(destination: LibrarianBookListView()) {
                                ZStack {
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Text(category.0)
                                                .font(.system(size: textSize))
                                                .padding([.leading, .bottom], 10)
                                                .foregroundColor(.black) // Set text color to black
                                            Spacer()
                                        }
                                    }
                                    HStack {
                                        Spacer()
                                        Image(category.1)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: imageWidth, height: imageHeight)
                                            .padding(.trailing)
                                    }
                                }
                                .frame(width: 160, height: 120)
                                .background(Color(.systemGray6))
                                .cornerRadius(20)
                            }
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .white
                appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
                
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().tintColor = .black
            }
        }
    }
}

struct LibrarianBookCat_Previews: PreviewProvider {
    static var previews: some View {
        LibrarianBookCatView()
    }
}
