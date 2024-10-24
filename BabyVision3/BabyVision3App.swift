//
//  BabyVision3App.swift
//  BabyVision3
//
//  Created by Ryan Faucett on 10/23/24.
//

import SwiftUI
import AVFoundation

@main
struct BabyVision3App: App {
    @StateObject private var permissionsManager = CameraPermissionsManager()
    
    var body: some Scene {
        WindowGroup {
            if permissionsManager.isCameraAuthorized {
                MainView()  // Make sure this changed from ContentView to MainView
            } else {
                CameraPermissionView(permissionsManager: permissionsManager)
            }
        }
    }
}

class CameraPermissionsManager: ObservableObject {
    @Published var isCameraAuthorized = false
    
    init() {
        checkCameraPermissions()
    }
    
    func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isCameraAuthorized = true
        case .notDetermined:
            requestCameraPermission()
        default:
            isCameraAuthorized = false
        }
    }
    
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                self?.isCameraAuthorized = granted
            }
        }
    }
}

struct CameraPermissionView: View {
    @ObservedObject var permissionsManager: CameraPermissionsManager
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "camera.fill")
                .font(.system(size: 50))
            
            Text("Camera Access Required")
                .font(.title2)
                .bold()
            
            Text("BabyVision needs camera access to simulate infant vision. Please grant access in Settings.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Check Permission") {
                permissionsManager.checkCameraPermissions()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
