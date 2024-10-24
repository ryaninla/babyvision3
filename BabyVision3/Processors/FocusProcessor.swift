//
//  FocusProcessor.swift
//  BabyVision3
//
//  Created by Ryan Faucett on 10/23/24.
//

import GPUImage

class FocusProcessor {
    private let adaptiveFocus = GaussianBlur()
    
    init() {
        // Initialize with default settings
    }
    
    func updateFocus(visualAcuity: Float) {
        let blurAmount = (1.0 - visualAcuity) * 10.0
        adaptiveFocus.blurRadiusInPixels = blurAmount
    }
    
    func addTarget(_ target: ImageConsumer) {
        adaptiveFocus.addTarget(target)
    }
}
