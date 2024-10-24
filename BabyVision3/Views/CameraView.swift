//
//  CameraView.swift
//  BabyVision3
//
//  Created by Ryan Faucett on 10/23/24.
//

import SwiftUI
import GPUImage

struct CameraView: UIViewRepresentable {
    let visionProcessor: VisionProcessor
    
    func makeUIView(context: Context) -> RenderView {
        let renderView = RenderView(frame: .zero)
        visionProcessor.setRenderView(renderView)
        return renderView
    }
    
    func updateUIView(_ uiView: RenderView, context: Context) {
        // Updates are handled by GPUImage
    }
}

// Camera preview with controls overlay
struct CameraPreviewView: View {
    @ObservedObject var visionProcessor: VisionProcessor
    @State private var selectedAge: Double = 0.0
    @State private var showingInfoPanel = false
    @State private var isAutoPlaying = false
    private let autoPlayTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Camera feed
            CameraView(visionProcessor: visionProcessor)
                .edgesIgnoringSafeArea(.all)
            
            // UI Overlay
            VStack {
                // Top toolbar
                TopToolbar(showingInfoPanel: $showingInfoPanel)
                
                Spacer()
                
                // Age description
                if let stage = visionProcessor.currentStage {
                    Text(stage.description)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                        .padding()
                }
                
                // Bottom controls
                ControlPanel(
                    selectedAge: $selectedAge,
                    isAutoPlaying: $isAutoPlaying,
                    onAgeChanged: { age in
                        visionProcessor.updateVisionParameters(forAge: age)
                    }
                )
            }
        }
        
        .onReceive(autoPlayTimer) { _ in
            if isAutoPlaying && selectedAge < 12.0 {
                selectedAge += 0.1
                visionProcessor.updateVisionParameters(forAge: selectedAge)
            } else if selectedAge >= 12.0 {
                isAutoPlaying = false
            }
        }
    }
}

struct TopToolbar: View {
    @Binding var showingInfoPanel: Bool
    
    var body: some View {
        HStack {
            Button(action: { showingInfoPanel.toggle() }) {
                Image(systemName: "info.circle")
                    .font(.title)
                    .foregroundColor(.white)
            }
            .padding()
            
            Spacer()
        }
        .background(Color.black.opacity(0.3))
    }
}

struct ControlPanel: View {
    @Binding var selectedAge: Double
    @Binding var isAutoPlaying: Bool
    let onAgeChanged: (Double) -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            // Age display and auto-play button
            HStack {
                Text("\(String(format: "%.1f", selectedAge)) months")
                    .foregroundColor(.white)
                    .font(.title3)
                
                Spacer()
                
                Button(action: { isAutoPlaying.toggle() }) {
                    Image(systemName: isAutoPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            
            // Age slider
            Slider(
                value: $selectedAge,
                in: 0...12,
                step: 0.1
            )
            .onChange(of: selectedAge) { oldValue, newValue in
                onAgeChanged(newValue)
            }
            
            // Quick select buttons
            HStack {
                ForEach([0.0, 2.0, 4.0, 6.0, 12.0], id: \.self) { age in
                    Button(action: {
                        selectedAge = age
                        onAgeChanged(age)
                    }) {
                        Text("\(Int(age))m")
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(selectedAge == age ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(15)
        .padding()
    }
}
