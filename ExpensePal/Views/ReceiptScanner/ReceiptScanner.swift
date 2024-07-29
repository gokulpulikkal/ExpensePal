//
//  ReceiptScanner.swift
//  ExpensePal
//
//  Created by Gokul P on 28/07/24.
//

import SwiftUI
import AVFoundation

struct ReceiptScanner: View {
    @State private var scannedImages: [UIImage] = []
    @State private var isShowingVNDocumentCameraView = false
    var body: some View {
        NavigationView {
            Grid {
                ForEach(scannedImages, id: \.self) { image in
                    VStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding()
                    }
                }
            }
            .sheet(isPresented: $isShowingVNDocumentCameraView) {
                VNDocumentViewControllerRepresentable(scanResult: $scannedImages)
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        Task {
                            await setUpCaptureSession()
                        }
                    } label: {
                        Image(systemName: "scanner")
                    }
                }
            }
        }
    }

    private func showVNDocumentCameraView() {
        isShowingVNDocumentCameraView = true
    }

    private func setUpCaptureSession() async {
        guard await isAuthorized else {
            return
        }
        showVNDocumentCameraView()
    }

    var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)

            // Determine if the user previously authorized camera access.
            var isAuthorized = status == .authorized

            // If the system hasn't determined the user's authorization status,
            // explicitly prompt them for approval.
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }

            return isAuthorized
        }
    }
}

#Preview {
    ReceiptScanner()
}
