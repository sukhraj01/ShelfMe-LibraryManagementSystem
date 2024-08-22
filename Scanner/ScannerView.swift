import SwiftUI
import AVKit

class QRScannerDelegate: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    @Published var scannedCode: String?
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metaObject = metadataObjects.first {
            guard let readableObject = metaObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let scannedCode = readableObject.stringValue else { return }
            // Pass the scanned code to the next page within the app
            self.scannedCode = scannedCode
        }
    }

}

struct ScannerView: View {
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
    
    /// Navigation state
    @State private var isDetailViewActive: Bool = false
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
                
                /// NavigationLink to DetailView
                NavigationLink(
                    destination: DetailView(scannedCode: scannedCode),
                    isActive: $isDetailViewActive
                ) {
                    EmptyView()
                }
                .hidden()
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
                    // Navigate to the next page within your app using the scanned code
                    isDetailViewActive = true
                }
            }

        }
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

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
    }
}
