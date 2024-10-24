//
//  ContentView.swift
//  BabyVision3
//
//  Created by Ryan Faucett on 10/23/24.
//

import SwiftUI
import GPUImage
import AVFoundation

struct MainView: View {
    @StateObject private var visionProcessor = VisionProcessor()
    @State private var selectedAge: Double = 0.0
    @State private var showingEducationalView = false
    @State private var showingSettings = false
    @State private var viewMode: SettingsView.ViewMode = .standard
    @AppStorage("showTooltips") private var showTooltips = true
    
    var body: some View {
        ZStack {
            // Main Camera View
            CameraPreviewView(visionProcessor: visionProcessor)
                .edgesIgnoringSafeArea(.all)
            
            // Top Navigation Bar
            VStack {
                TopNavigationBar(
                    showingEducationalView: $showingEducationalView,
                    showingSettings: $showingSettings,
                    viewMode: $viewMode
                )
                
                if showTooltips {
                    TooltipView(text: "Tap the book icon to learn about baby vision development")
                        .padding()
                }
                
                Spacer()
                
                // Bottom Age Control Panel
                if viewMode == .standard {
                    ControlPanel(
                        selectedAge: $selectedAge,
                        isAutoPlaying: .constant(false), // We'll implement this later
                        onAgeChanged: { age in
                            visionProcessor.updateVisionParameters(forAge: age)
                        }
                    )
                }
            }
        }
        .sheet(isPresented: $showingEducationalView) {
            EducationalView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .onAppear {
            visionProcessor.startProcessing()
            checkCameraAuthorization()
        }
        .onDisappear {
            visionProcessor.stopProcessing()
        }
    }
    
    private func checkCameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break // Camera is already authorized
        case .notDetermined:
            // Request camera access
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if !granted {
                    // Handle case where user denies camera access
                    print("Camera access denied")
                }
            }
        case .denied, .restricted:
            // Handle case where camera access is denied or restricted
            print("Camera access denied or restricted")
        @unknown default:
            break
        }
    }
}

struct TopNavigationBar: View {
    @Binding var showingEducationalView: Bool
    @Binding var showingSettings: Bool
    @Binding var viewMode: SettingsView.ViewMode
    
    var body: some View {
        HStack {
            // Educational Button
            Button(action: { showingEducationalView.toggle() }) {
                Image(systemName: "book.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44) // Minimum tap target size
            }
            .padding(.horizontal)
            
            Spacer()
            
            // View Mode Picker
            Picker("View Mode", selection: $viewMode) {
                ForEach(SettingsView.ViewMode.allCases, id: \.self) { mode in
                    Image(systemName: mode.icon)
                        .tag(mode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(maxWidth: 200)
            
            Spacer()
            
            // Settings Button
            Button(action: { showingSettings.toggle() }) {
                Image(systemName: "gear")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44) // Minimum tap target size
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.7))
    }
}

struct TooltipView: View {
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: "info.circle.fill")
                .foregroundColor(.blue)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(10)
    }
}

#Preview {
    MainView()
}
