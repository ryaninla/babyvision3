//
//  MotionProcessor.swift
//  BabyVision3
//
//  Created by Ryan Faucett on 10/23/24.
//

import GPUImage
import CoreMotion

class MotionProcessor {
    private let motionBlur: GaussianBlur
    private let stabilizationFilter: ColorMatrixFilter
    private let motionManager: CMMotionManager
    
    private var lastUpdateTime: TimeInterval = 0
    private var motionSensitivity: Float = 1.0
    
    init() {
        motionBlur = GaussianBlur()
        stabilizationFilter = ColorMatrixFilter()
        motionManager = CMMotionManager()
        
        setupMotionTracking()
        motionBlur --> stabilizationFilter
    }
    
    private func setupMotionTracking() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
                guard let self = self,
                      let motion = motion else { return }
                self.processMotionUpdate(motion)
            }
        }
    }
    
    private func processMotionUpdate(_ motion: CMDeviceMotion) {
        let currentTime = Date().timeIntervalSince1970
        let timeDelta = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        // Calculate motion intensity from rotation rate
        let rotation = motion.rotationRate
        let motionIntensity = Float(
            sqrt(
                pow(rotation.x, 2) +
                pow(rotation.y, 2) +
                pow(rotation.z, 2)
            )
        )
        
        // Apply motion blur based on movement intensity and sensitivity
        let blurAmount = motionIntensity * (1.0 - motionSensitivity) * 5.0
        motionBlur.blurRadiusInPixels = blurAmount
        
        // Update stabilization by modifying the color matrix filter's individual components
        updateStabilization(with: motion, timeDelta: timeDelta)
    }
    
    private func updateStabilization(with motion: CMDeviceMotion, timeDelta: TimeInterval) {
        // Adjust stabilization directly without using a matrix
        let attitude = motion.attitude
        
        // Directly adjust color based on rotation (e.g., could apply slight color shift based on angles)
        let yawFactor = Float(attitude.yaw) * 0.1 // Adjust the factor to taste
        let pitchFactor = Float(attitude.pitch) * 0.1
        let rollFactor = Float(attitude.roll) * 0.1
        
        // Modify the color channels slightly based on device movement to simulate stabilization
        stabilizationFilter.colorMatrix = Matrix4x4(rowMajorValues: [
            1.0 + yawFactor, 0.0, 0.0, 0.0,
            0.0, 1.0 + pitchFactor, 0.0, 0.0,
            0.0, 0.0, 1.0 + rollFactor, 0.0,
            0.0, 0.0, 0.0, 1.0
        ])
    }
    
    func updateMotionSensitivity(_ sensitivity: Float) {
        motionSensitivity = sensitivity
    }
    
    func addTarget(_ target: ImageConsumer) {
        stabilizationFilter --> target
    }
    
    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
}
