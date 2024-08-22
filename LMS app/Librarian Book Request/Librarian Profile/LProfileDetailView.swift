//
//  LProfileDetailView.swift
//  LibraryProfile
//
//  Created by PRIYANSHU MISHRA on 13/06/24.
//

import SwiftUI

// Color extension for custom colors
extension Color {
    static let customDarkGrays = Color(hexString: "#a9abaf")
    static let backColors = Color(hexString: "D3D3D3")
    
    init(hexString: String) {
        let scanner = Scanner(string: hexString)
        scanner.currentIndex = hexString.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xff0000) >> 16) / 0xff
        let green = Double((rgbValue & 0x00ff00) >> 8) / 0xff
        let blue = Double(rgbValue & 0x0000ff) / 0xff
        
        self.init(red: red, green: green, blue: blue)
    }
}

// ProfileDetailView with image picker functionality
struct LProfileDetailView: View {
    @State private var isImagePickerPresented = false
    @Binding var selectedImage: UIImage?
    
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
                            Text("KV") // Initials of the contact
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.white)
                        )
                        .padding()
                        .background(Color.customDarkGray)
                        .clipShape(Circle())
                    Text("Khushi Verma")
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
                        Text("Librarian Id")
                        Spacer()
                        Text("#56723")
                            .foregroundColor(.gray)
                    }
                }
                Section {
                    HStack {
                        Text("Email")
                        Spacer()
                        Text("khushiverma@gmail.com")
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
                        Text("Female")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("D.O.B")
                        Spacer()
                        Text("17/08/1999")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Address")
                        Spacer()
                        Text("Infosys,Banglore")
                            .foregroundColor(.gray)
                    }

                }
                Section {
                    HStack {
                        Text("Library Email")
                        Spacer()
                        Text("Khushiverma@infosys.com")
                            .foregroundColor(.gray)
                    }

                    HStack {
                        Text("Password")
                        Spacer()
                        Text("****")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Account Creation Date")
                        Spacer()
                        Text("1 June 2024")
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
struct ImagePickerss: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerss

        init(parent: ImagePickerss) {
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
struct LProfileDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LProfileDetailView(selectedImage: .constant(nil))
    }
}
