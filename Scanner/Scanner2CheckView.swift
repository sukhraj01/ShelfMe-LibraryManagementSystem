import SwiftUI
import AVKit

struct Scanner2CheckView: View {
    @EnvironmentObject var dataManager: DataManager
    /// QR Code Scanner properties
    @State private var isScanning: Bool = false
    @State private var session: AVCaptureSession = .init()
    @State private var cameraPermission: Permission = .idle
    
    /// QR scanner AV Output
    @State private var qrOutput: AVCaptureMetadataOutput = .init()
    
    /// Error properties
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @Environment(\.openURL) private var openURL
    
    /// Camera QR Output delegate
    @StateObject private var qrDelegate = QRScannerDelegate()
    
    /// Popup state
    @State private var showPopup: Bool = false
    @State private var scannedCode: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                Text("Place the QR code inside the area")
                    .font(.title3)
                    .foregroundColor(.black.opacity(0.8))
                    .padding(.top, 20)
                
                Text("Scanning will start automatically")
                    .font(.callout)
                    .foregroundColor(.gray)
                
                Spacer(minLength: 0)
                
                /// Scanner
                GeometryReader { geometry in
                    let size = geometry.size
                    ZStack {
                        CameraView(frameSize: CGSize(width: size.width, height: size.width), session: $session)
                            .scaleEffect(0.97)
                        ForEach(0...4, id: \.self) { index in
                            let rotation = Double(index) * 90
                            
                            RoundedRectangle(cornerRadius: 2, style: .circular)
                                .trim(from: 0.61, to: 0.64)
                                .stroke(.black, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                .rotationEffect(.init(degrees: rotation))
                        }
                    }
                    .frame(width: size.width, height: size.width)
                    .overlay(alignment: .top) {
                        Rectangle()
                            .fill(.black)
                            .frame(height: 2.5)
                            .shadow(color: .black.opacity(0.8), radius: 8, x: 0, y: isScanning ? 15 : -15)
                            .offset(y: isScanning ? size.width : 0)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding(.horizontal, 45)
                
                Spacer(minLength: 15)
                Button {
                    if !session.isRunning && cameraPermission == .approved {
                        reactivateCamera()
                        activateScannerAnimation()
                    }
                } label: {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
                
                Spacer(minLength: 45)
            }
            .padding(15)
            .onAppear(perform: checkCameraPermission)
            .alert(errorMessage, isPresented: $showError) {
                if cameraPermission == .denied {
                    Button("Settings") {
                        let settingString = UIApplication.openSettingsURLString
                        if let settingURL = URL(string: settingString) {
                            openURL(settingURL)
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                }
            }
            .onDisappear {
                session.stopRunning()
            }
            .onChange(of: qrDelegate.scannedCode) { newValue in
                if let code = newValue {
                    scannedCode = code
                    session.stopRunning()
                    deActivateScannerAnimation()
                    qrDelegate.scannedCode = nil
                    
                    checkinout()
                    
                    // Show the popup
                    showPopup = true
                }
            }
            .sheet(isPresented: $showPopup) {
                PopupView(isPresented: $showPopup, scannedCode: scannedCode, onClose: {
                    // Reset states and resume scanning when popup is closed
                    reactivateCamera()
                    activateScannerAnimation()
                })
            }
        }
    }
    
//    func checkinout() {
//        guard let url = URL(string: "https://lms-hgdf.onrender.com/api/v1/library/libraryaction") else {
//            return
//        }
//
//        let credentials = ["userID": scannedCode]
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        guard let httpBody = try? JSONSerialization.data(withJSONObject: credentials, options: []) else {
//            return
//        }
//
//        request.httpBody = httpBody
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    self.errorMessage = error?.localizedDescription ?? "Unknown error"
//                }
//                return
//            }
//            if let httpResponse = response as? HTTPURLResponse,
//               (200...299).contains(httpResponse.statusCode) {
//                do {
//                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
//                    DispatchQueue.main.async {
//                        // Handle success response if needed
//                        
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        self.errorMessage = "Error decoding response"
//                    }
//                }
//            } else {
//                if let errorDataString = String(data: data, encoding: .utf8) {
//                    DispatchQueue.main.async {
//                        self.errorMessage = errorDataString
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        self.errorMessage = "Unknown error"
//                    }
//                }
//            }
//        }.resume()
//    }
    
    
//    func checkinout() {
//        print("first")
//        guard let url = URL(string: "https://lms-hgdf.onrender.com/api/v1/library/libraryaction") else {
//            return
//        }
//
//        let credentials = ["userID": scannedCode]
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        guard let httpBody = try? JSONSerialization.data(withJSONObject: credentials, options: []) else {
//            return
//        }
//
//        request.httpBody = httpBody
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    self.errorMessage = error?.localizedDescription ?? "Unknown error"
//                }
//                return
//            }
//            
//            print("saaaaaaaaaa")
//            if let httpResponse = response as? HTTPURLResponse,
//               (200...299).contains(httpResponse.statusCode) {
//                do {
//                    let libraryData = try JSONDecoder().decode(LibraryData.self, from: data)
//                    DispatchQueue.main.async {
//                        self.dataManager.libraryData = libraryData // Store library data in DataManager
//                        print("printttttyteufgjegrjfgjerfgjergfjgfkhkergjgejfrgjregjk")
//                        print(self.dataManager.libraryData)
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        self.errorMessage = "Error decoding response"
//                    }
//                }
//            } else {
//                if let errorDataString = String(data: data, encoding: .utf8) {
//                    DispatchQueue.main.async {
//                        self.errorMessage = errorDataString
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        self.errorMessage = "Unknown error"
//                    }
//                }
//            }
//        }.resume()
//    }
    
    
    
    func checkinout() {
        guard let url = URL(string: "https://lms-hgdf.onrender.com/api/v1/library/libraryaction") else {
            return
        }

        let credentials = ["userID": scannedCode]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let httpBody = try? JSONSerialization.data(withJSONObject: credentials, options: []) else {
            return
        }

        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = error?.localizedDescription ?? "Unknown error"
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               (200...299).contains(httpResponse.statusCode) {
                do {
                    let libraryData = try JSONDecoder().decode(LibraryData.self, from: data)
                    DispatchQueue.main.async {
//                        self.dataManager.libraryData = libraryData // Store library data in DataManager
                        print("Library Data:")
                        print(libraryData) // Print library data to console
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error decoding response"
                    }
                }
            } else {
                if let errorDataString = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.errorMessage = errorDataString
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Unknown error"
                    }
                }
            }
        }.resume()
    }


    
    func reactivateCamera() {
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
    }
    
    func activateScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85).delay(0.1).repeatForever(autoreverses: true)) {
            isScanning = true
        }
    }
    
    func deActivateScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85)) {
            isScanning = false
        }
    }
    
    func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                cameraPermission = .approved
                if session.inputs.isEmpty {
                    setupCamera()
                } else {
                    reactivateCamera()
                }
            case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video) {
                    cameraPermission = .approved
                    setupCamera()
                } else {
                    cameraPermission = .denied
                    presentError("Please provide access to camera for scanning codes")
                }
            case .denied, .restricted:
                cameraPermission = .denied
            default: break
            }
        }
    }
    
    func setupCamera() {
        do {
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInUltraWideCamera, .builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
                presentError("UNKNOWN DEVICE ERROR")
                return
            }
            
            let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input), session.canAddOutput(qrOutput) else {
                presentError("UNKNOWN INPUT/OUTPUT ERROR")
                return
            }
            
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)
            qrOutput.metadataObjectTypes = [.qr]
            qrOutput.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            session.commitConfiguration()
            
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
            activateScannerAnimation()
        } catch {
            presentError(error.localizedDescription)
        }
    }
    
    func presentError(_ message: String) {
        errorMessage = message
        showError.toggle()
    }
}

struct PopupView: View {
    @Binding var isPresented: Bool
    let scannedCode: String
    let onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Success")
                .font(.headline)
                .padding()
            Button("Done") {
                onClose()
                isPresented = false
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 8)
        .onDisappear {
            // Additional cleanup if needed
        }
    }
}
