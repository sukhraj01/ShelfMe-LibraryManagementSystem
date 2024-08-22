import SwiftUI

struct VacantSeatModalView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var dataManager: DataManager // Inject DataManager
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    Text("Infosys, Mysore, DC")
                        .font(.title)
                        .padding(.bottom, 20)
                    
                    if let libraryData = dataManager.libraryData {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Vacant seats")
                                    .font(.headline)
                                Text("\((libraryData.capacity ?? 100) - (libraryData.present ?? 0))/\(libraryData.capacity)")
                                    .font(.largeTitle)
                                    .foregroundColor(.green)
                            }
                            Spacer()
                            CircularProgressView(vacantSeats: libraryData.present, totalSeats: libraryData.total)
                        }
                        .padding(.bottom, 20)
                        
                        HStack {
                            Text("Total seats")
                                .font(.headline)
                            Spacer()
                            Text("\(libraryData.capacity)")
                                .font(.title)
                        }
                        .padding(.bottom, 10)
                        
                        // You can add more details here as needed
                    } else {
                        Text("Loading...")
                    }
                    
                    HStack {
//                        Text("Total Attendance")
//                            .font(.headline)
//                        Spacer()
//                        Text("173")
//                            .font(.title)
                    }
                }
                .padding()
                
                Spacer()
            }
            .navigationBarTitle("Details", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                isPresented = false
            })
        }
    }
}


struct CircularProgressView: View {
    
    var vacantSeats: Int
    var totalSeats: Int
    @EnvironmentObject var dataManager: DataManager // Inject DataManager
    
    private var progress: Double {
        guard let libraryData = dataManager.libraryData else { return 0.0 }
        return Double(libraryData.present) / Double(libraryData.capacity)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 10) // Background circle
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(Color.green, lineWidth: 10)
                .rotationEffect(Angle(degrees: -90))
                .animation(.linear, value: progress)
            
            VStack {
                if let libraryData = dataManager.libraryData {
                    Text("\(libraryData.present)")
                        .font(.title)
                        .bold()
                        .foregroundColor(.green)
                    Text("/ \(libraryData.capacity)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(width: 100, height: 100)
    }
}

struct HalfSheet<SheetView: View>: ViewModifier {
    @Binding var isPresented: Bool
    let sheetView: SheetView
    
    func body(content: Content) -> some View {
        content
            .background(
                HalfSheetHelper(sheetView: sheetView, isPresented: $isPresented)
            )
    }
}

extension View {
    func halfSheet<SheetView: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> SheetView) -> some View {
        self.modifier(HalfSheet(isPresented: isPresented, sheetView: content()))
    }
}

struct HalfSheetHelper<SheetView: View>: UIViewControllerRepresentable {
    let sheetView: SheetView
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            let sheetController = UIHostingController(rootView: sheetView)
            sheetController.modalPresentationStyle = .pageSheet
            sheetController.presentationController?.delegate = context.coordinator
            
            uiViewController.present(sheetController, animated: true) {
                DispatchQueue.main.async {
                    if let sheetPresentationController = sheetController.presentationController as? UISheetPresentationController {
                        sheetPresentationController.detents = [.medium()]
                        sheetPresentationController.largestUndimmedDetentIdentifier = .medium
                        sheetPresentationController.prefersGrabberVisible = true
                    }
                }
            }
        } else {
            uiViewController.presentedViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isPresented: $isPresented)
    }
    
    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        @Binding var isPresented: Bool
        
        init(isPresented: Binding<Bool>) {
            _isPresented = isPresented
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            isPresented = false
        }
    }
}

// Wrapper for preview
struct VacantSeatModalViewPreviewWrapper: View {
    @State private var isPresented = true
    
    var body: some View {
        VacantSeatModalView(isPresented: $isPresented)
    }
}
