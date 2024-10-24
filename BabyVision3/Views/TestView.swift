//
//  TestView.swift
//  BabyVision3
//
//  Created by Ryan Faucett on 10/23/24.
//

import SwiftUI
import GPUImage

struct ProcessorTestView: View {
    @StateObject private var visionProcessor = VisionProcessor()
    @State private var selectedAge: Double = 0.0
    @State private var showDebugInfo = false
    
    var body: some View {
        ZStack {
            // Camera View
            if visionProcessor.isProcessing {
                CameraTestView(visionProcessor: visionProcessor)
                    .edgesIgnoringSafeArea(.all)
                
                // Debug Overlay
                if showDebugInfo {
                    debugOverlay
                }
                
                // Controls
                VStack {
                    Spacer()
                    
                    // Age Slider
                    VStack {
                        Text("Age: \(String(format: "%.1f", selectedAge)) months")
                            .foregroundColor(.white)
                        
                        Slider(value: $selectedAge, in: 0...12, step: 0.1)
                            .padding()
                            .onChange(of: selectedAge) { newValue in
                                visionProcessor.updateVisionParameters(forAge: newValue)
                            }
                        
                        // Debug Toggle
                        Toggle("Show Debug Info", isOn: $showDebugInfo)
                            .padding()
                    }
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    .padding()
                }
            } else {
                Text("Initializing Camera...")
            }
        }
        .onAppear {
            visionProcessor.startProcessing()
        }
        .onDisappear {
            visionProcessor.stopProcessing()
        }
    }
    
    private var debugOverlay: some View {
        VStack(alignment: .leading) {
            if let stage = visionProcessor.currentStage {
                Text("Current Stage Parameters:")
                    .font(.headline)
                Text("Visual Acuity: \(String(format: "%.2f", stage.visualAcuity))")
                Text("Blur Radius: \(String(format: "%.2f", stage.characteristics.blurRadius))")
                Text("Saturation: \(String(format: "%.2f", stage.characteristics.saturation))")
                Text("Contrast: \(String(format: "%.2f", stage.characteristics.contrast))")
                Text("Depth Perception: \(String(format: "%.2f", stage.characteristics.depthPerception))")
                Text("Motion Sensitivity: \(String(format: "%.2f", stage.characteristics.motionSensitivity))")
            }
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding()
        .position(x: UIScreen.main.bounds.width * 0.2,
                 y: UIScreen.main.bounds.height * 0.2)
    }
}

// Camera view using GPUImage
struct CameraTestView: UIViewRepresentable {
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
