//
//  DepthProcessor.swift
//  BabyVision3
//
//  Created by Ryan Faucett on 10/23/24.
//

import GPUImage

class DepthProcessor {
    private let blurFilter = GaussianBlur()
    
    init() {
        // Initialize with default settings
    }
    
    func updateDepthPerception(focusRange: DepthRange, depthSensitivity: Float) {
        blurFilter.blurRadiusInPixels = (1.0 - depthSensitivity) * 10.0
    }
    
    func addTarget(_ target: ImageConsumer) {
        blurFilter.addTarget(target)
    }
}
