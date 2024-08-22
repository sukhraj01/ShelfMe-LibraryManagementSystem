//
//  QRCodeView.swift
//  LMS app
//
//  Created by Khushi Verma on 11/06/24.
//

import Foundation

import SwiftUI

struct QRCodeView: View {
    var inputText: String
    @State private var qrCodeImage: UIImage?

    var body: some View {
        VStack {
            if let qrCodeImage = qrCodeImage {
                Image(uiImage: qrCodeImage)
                    .resizable()
                    .interpolation(.none) // To avoid blur
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: 200, height: 200)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onAppear {
            qrCodeImage = QRCodeGenerator.generateQRCode(from: inputText)
        }
        .navigationTitle("QR Code")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct QRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeView(inputText: "Sample QR Code")
    }
}
