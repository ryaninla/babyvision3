//
//  ControlsView.swift
//  BabyVision3
//
//  Created by Ryan Faucett on 10/23/24.
//

import SwiftUI

struct ControlsView: View {
    @ObservedObject var visionProcessor: VisionProcessor
    @State private var selectedViewMode: ViewMode = .standard
    @State private var showingSettings = false
    
    enum ViewMode {
        case standard
        case splitScreen
        case comparison
    }
    
    var body: some View {
        VStack {
            // View mode selector
            Picker("View Mode", selection: $selectedViewMode) {
                Image(systemName: "camera").tag(ViewMode.standard)
                Image(systemName: "square.split.2x1").tag(ViewMode.splitScreen)
                Image(systemName: "arrow.left.and.right.circle").tag(ViewMode.comparison)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // Settings button
            Button(action: { showingSettings.toggle() }) {
                Image(systemName: "gear")
                    .font(.title)
                    .foregroundColor(.white)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(15)
    }
}


