//
//  VisionCharacteristics.swift
//  BabyVision3
//
//  Created by Ryan Faucett on 10/23/24.
//
import Foundation

// Defines the visual characteristics for a specific age
struct VisionCharacteristics: Identifiable {
    let id = UUID()
    let ageInMonths: Double
    let visualAcuity: Float        // 20/20 = 1.0, 20/400 = 0.05
    let characteristics: VisionParameters
    let description: String
    let detailedInfo: VisionStageInfo
}

// Core vision parameters that can be interpolated between stages
struct VisionParameters {
    let blurRadius: Float          // 0.0 to 15.0
    let saturation: Float          // 0.0 to 1.0
    let contrast: Float            // 0.8 to 1.4
    let colorSensitivity: ColorSensitivity
    let depthPerception: Float     // 0.0 to 1.0
    let lightSensitivity: Float    // 0.0 to 1.0
    let focusRange: DepthRange     // in meters
    let motionSensitivity: Float   // 0.0 to 1.0
}

struct ColorSensitivity {
    let red: Float    // 0.0 to 1.0
    let green: Float  // 0.0 to 1.0
    let blue: Float   // 0.0 to 1.0
    
    static let grayscale = ColorSensitivity(red: 0.0, green: 0.0, blue: 0.0)
    static let fullColor = ColorSensitivity(red: 1.0, green: 1.0, blue: 1.0)
}

struct DepthRange {
    let min: Float
    let max: Float
    
    static let newborn = DepthRange(min: 0.2, max: 0.3)  // 8-12 inches
    static let adult = DepthRange(min: 0.1, max: 6.0)    // 4 inches to 20 feet
}

struct VisionStageInfo {
    let title: String
    let overview: String
    let keyDevelopments: [String]
    let parentTips: [String]
    let scientificDetails: String
}

// Static vision development stages
extension VisionCharacteristics {
    static let developmentStages: [VisionCharacteristics] = [
        // Newborn (0 months)
        VisionCharacteristics(
            ageInMonths: 0,
            visualAcuity: 0.05,  // 20/400
            characteristics: VisionParameters(
                blurRadius: 15.0,
                saturation: 0.0,
                contrast: 1.4,
                colorSensitivity: .grayscale,
                depthPerception: 0.1,
                lightSensitivity: 0.3,
                focusRange: .newborn,
                motionSensitivity: 0.2
            ),
            description: "Newborn vision: Very blurry, mainly detecting light and movement",
            detailedInfo: VisionStageInfo(
                title: "Newborn Vision",
                overview: "Newborns can only see 8-12 inches from their face, primarily in black and white.",
                keyDevelopments: [
                    "Can detect large shapes and movement",
                    "Sensitive to high contrast patterns",
                    "Prefers human faces"
                ],
                parentTips: [
                    "Position your face 8-12 inches from baby",
                    "Use high contrast patterns and objects",
                    "Create simple black and white patterns"
                ],
                scientificDetails: "Newborn visual acuity is approximately 20/400. The retina is not fully developed, and color-sensing cone cells are immature."
            )
        ),
        
        // Add more stages here...
    ]
    
    // Helper method to get interpolated vision characteristics for any age
    static func forAge(_ age: Double) -> VisionCharacteristics {
        // Find the two closest stages and interpolate between them
        let laterStage = developmentStages.first { $0.ageInMonths >= age } ?? developmentStages.last!
        let earlierStage = developmentStages.last { $0.ageInMonths <= age } ?? developmentStages.first!
        
        // If age matches a stage exactly, return that stage
        if laterStage.ageInMonths == age { return laterStage }
        if earlierStage.ageInMonths == age { return earlierStage }
        
        // Otherwise interpolate between stages
        return interpolate(from: earlierStage, to: laterStage, at: age)
    }
    
    private static func interpolate(from: VisionCharacteristics, to: VisionCharacteristics, at age: Double) -> VisionCharacteristics {
        let progress = Float((age - from.ageInMonths) / (to.ageInMonths - from.ageInMonths))
        
        // Linear interpolation helper
        func lerp(_ a: Float, _ b: Float, _ t: Float) -> Float {
            return a + (b - a) * t
        }
        
        return VisionCharacteristics(
            ageInMonths: age,
            visualAcuity: lerp(from.visualAcuity, to.visualAcuity, progress),
            characteristics: VisionParameters(
                blurRadius: lerp(from.characteristics.blurRadius, to.characteristics.blurRadius, progress),
                saturation: lerp(from.characteristics.saturation, to.characteristics.saturation, progress),
                contrast: lerp(from.characteristics.contrast, to.characteristics.contrast, progress),
                colorSensitivity: ColorSensitivity(
                    red: lerp(from.characteristics.colorSensitivity.red, to.characteristics.colorSensitivity.red, progress),
                    green: lerp(from.characteristics.colorSensitivity.green, to.characteristics.colorSensitivity.green, progress),
                    blue: lerp(from.characteristics.colorSensitivity.blue, to.characteristics.colorSensitivity.blue, progress)
                ),
                depthPerception: lerp(from.characteristics.depthPerception, to.characteristics.depthPerception, progress),
                lightSensitivity: lerp(from.characteristics.lightSensitivity, to.characteristics.lightSensitivity, progress),
                focusRange: DepthRange(
                    min: lerp(from.characteristics.focusRange.min, to.characteristics.focusRange.min, progress),
                    max: lerp(from.characteristics.focusRange.max, to.characteristics.focusRange.max, progress)
                ),
                motionSensitivity: lerp(from.characteristics.motionSensitivity, to.characteristics.motionSensitivity, progress)
            ),
            description: to.description, // Use the next stage's description
            detailedInfo: to.detailedInfo // Use the next stage's detailed info
        )
    }
}
