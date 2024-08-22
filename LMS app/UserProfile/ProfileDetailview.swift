
import SwiftUI

// Color extension for custom colors
extension Color {
    static let customDarkGray = Color(hex: "#a9abaf")
    static let backColor = Color(hex: "D3D3D3")
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xff0000) >> 16) / 0xff
        let green = Double((rgbValue & 0x00ff00) >> 8) / 0xff
        let blue = Double(rgbValue & 0x0000ff) / 0xff
        
        self.init(red: red, green: green, blue: blue)
    }
}

// ProfileDetailView with image picker functionality
struct ProfileDetailView: View {
    @State private var isImagePickerPresented = false
    @Binding var selectedImage: UIImage?
    
    var user : LoggedInUser
    
    var body: some View {
        VStack(spacing: 0) {
            // Top half
            VStack {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding()
                        .background(Color.customDarkGray)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.customDarkGray)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Text("Profile") // Initials of the contact
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.white)
                        )
                        .padding()
                        .background(Color.customDarkGray)
                        .clipShape(Circle())
                    Text(user.name)
                        .font(.title)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backColor)
            .onTapGesture {
                isImagePickerPresented = true
            }
            
            // Bottom half
            Form {
                Section(header: Text("Profile Information")) {
                    HStack {
                        Text("Member Id")
                        Spacer()
                        Text("\(user._id)")
                            .foregroundColor(.gray)
                    }
                }
                Section {
                    HStack {
                        Text("Email")
                        Spacer()
                        Text("\(user.email)")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Phone Number")
                        Spacer()
                        Text("9876543210")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Gender")
                        Spacer()
                        Text("Male")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("D.O.B")
                        Spacer()
                        Text("17/08/1999")
                            .foregroundColor(.gray)
                    }
                }
                Section {
                    HStack {
                        Text("Password")
                        Spacer()
                        Text("*******")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Account Creation Date")
                        Spacer()
                        Text("\(user.createdAt)")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .navigationBarTitle("Profile")
        .navigationBarItems(trailing: Button(action: {
            // Edit action
        }) {
            Text("Edit")
        })
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $selectedImage)
        }
    }
}

// ImagePicker implementation
struct ImagePickers: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickers

        init(parent: ImagePickers) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

// Preview for ProfileDetailView
//struct ProfileDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileDetailView(selectedImage: .constant(nil))
//    }
//}
