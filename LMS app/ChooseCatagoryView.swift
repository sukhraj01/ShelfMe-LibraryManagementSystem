//import SwiftUI
//
//struct ChooseCatagoryView: View {
//    
//
//    @State private var selectedCategories: [String] = []
//    @State private var navigateToHome: Bool = false
//    @EnvironmentObject var dataManager: DataManager
// 
//    
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("Choose 3 or more")
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .multilineTextAlignment(.leading)
//                    .padding(.leading, -100)
//                
//                Text("books you like.")
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .multilineTextAlignment(.leading)
//                    .padding(.leading, -125)
//                
//                FlowLayout(categories: userCategories, selectedCategories: $selectedCategories)
//                    .padding()
//                
//                if selectedCategories.count >= 3 {
//                    if let user = dataManager.user {
//                                            NavigationLink(destination: UserTabBarView(user: user), isActive: $navigateToHome) {
//                                                EmptyView()
//                                            }
//                                        }
//                    
//                    Button(action: {
//                        navigateToHome = true
//                    }) {
//                        Text("Next")
//                            .font(.title2)
//                            .fontWeight(.bold)
//                            .frame(minWidth: 0, maxWidth: 260)
//                            .padding()
//                            .background(Color.black)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                            .padding()
//                    }
//                }
//            }
//            .navigationTitle("")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Skip") {
//                        // Handle skip action here
//                        print("Skip button tapped")
//                    }
//                    .fontWeight(.bold)
//                    .foregroundColor(.black)
//                    .cornerRadius(10)
//                }
//            }
//        }.navigationBarBackButtonHidden(true)
//
//    }
//}
//
//struct FlowLayout: View {
//    let categories: [String]
//    @Binding var selectedCategories: [String]
//
//    var body: some View {
//        GeometryReader { geometry in
//            self.createLayout(in: geometry)
//        }
//    }
//
//    private func createLayout(in geometry: GeometryProxy) -> some View {
//        var width: CGFloat = 0
//        var height: CGFloat = 0
//        var currentRow: [String] = []
//        var rows: [[String]] = []
//
//        for category in categories {
//            let categoryWidth = category.widthOfString(usingFont: .systemFont(ofSize: UIFont.systemFontSize)) + 40 // Add padding
//            if width + categoryWidth > geometry.size.width {
//                width = 0
//                height += 50 // Assuming a fixed height for simplicity
//                rows.append(currentRow)
//                currentRow = []
//            }
//            currentRow.append(category)
//            width += categoryWidth
//        }
//        rows.append(currentRow)
//
//        return VStack(alignment: .leading, spacing: 10) {
//            ForEach(rows, id: \.self) { row in
//                HStack(spacing: 10) { // Add spacing between category buttons
//                    ForEach(row, id: \.self) { category in
//                        self.categoryButton(for: category)
//                    }
//                }
//                .padding(.bottom, 10) // Add vertical spacing between rows
//            }
//        }
//        .frame(width: geometry.size.width, alignment: .topLeading)
//    }
//
//    private func categoryButton(for category: String) -> some View {
//        Button(action: {
//            self.toggleCategorySelection(category)
//        }) {
//            Text(category)
//                .padding()
//                .foregroundColor(self.selectedCategories.contains(category) ? .white : .black)
//                .background(self.selectedCategories.contains(category) ? Color.black : Color.white.opacity(0.2))
//                .cornerRadius(10)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.black, lineWidth: 2)
//                )
//                .lineLimit(1) // Ensure text stays in a single line
//        }
//    }
//
//    private func toggleCategorySelection(_ category: String) {
//        if let index = self.selectedCategories.firstIndex(of: category) {
//            self.selectedCategories.remove(at: index)
//        } else {
//            self.selectedCategories.append(category)
//        }
//    }
//}
//
//
//extension String {
//    func widthOfString(usingFont font: UIFont) -> CGFloat {
//        let fontAttributes = [NSAttributedString.Key.font: font]
//        let size = self.size(withAttributes: fontAttributes)
//        return size.width
//    }
//}
