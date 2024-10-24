//
//  VisionProcessor.swift
//  BabyVision3
//
//  Created by Ryan Faucett on 10/23/24.
//

import GPUImage
import CoreMotion
import SwiftUI

class VisionProcessor: ObservableObject {
    // Published properties for UI updates
    @Published var isProcessing = false
    @Published var currentStage: VisionCharacteristics?
    @Published var processingQuality: Float = 1.0
    
    // Camera components
    private var camera: Camera?
    private var renderView: RenderView?
    
    // Basic filters
    private var blurFilter: GaussianBlur?
    private var saturationFilter: SaturationAdjustment?
    private var contrastFilter: ContrastAdjustment?
    
    init() {
        setupVisionProcessing()
    }
    
    private func setupVisionProcessing() {
        do {
            camera = try Camera(sessionPreset: .high)
            
            // Initialize basic filters
            blurFilter = GaussianBlur()
            saturationFilter = SaturationAdjustment()
            contrastFilter = ContrastAdjustment()
            
            // Set up filter chain
            guard let camera = camera,
                  let blurFilter = blurFilter,
                  let saturationFilter = saturationFilter,
                  let contrastFilter = contrastFilter else {
                return
            }
            
            // Simple processing chain
            camera --> blurFilter
            blurFilter --> saturationFilter
            saturationFilter --> contrastFilter
            
            // Set initial parameters
            updateVisionParameters(forAge: 0)
        } catch {
            print("Failed to initialize camera: \(error)")
        }
    }
    
    func updateVisionParameters(forAge age: Double) {
        let stage = VisionCharacteristics.forAge(age)
        currentStage = stage
        
        let params = stage.characteristics
        
        // Update basic filters
        blurFilter?.blurRadiusInPixels = params.blurRadius
        saturationFilter?.saturation = params.saturation
        contrastFilter?.contrast = params.contrast
    }
    
    func setRenderView(_ view: RenderView) {
        renderView = view
        // Connect final filter to the render view
        contrastFilter?.addTarget(view)
    }
    
    func startProcessing() {
        camera?.startCapture()
        isProcessing = true
    }
    
    func stopProcessing() {
        camera?.stopCapture()
        isProcessing = false
    }
}
