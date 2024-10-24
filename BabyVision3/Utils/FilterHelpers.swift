//
//  FilterHelpers.swift
//  BabyVision3
//
//  Created by Ryan Faucett on 10/23/24.
//

import GPUImage

struct FilterHelpers {
    // MARK: - Vision Filter Calculations
    
    static func calculateBlurRadius(forAge age: Double) -> Float {
        // Blur decreases with age (15.0 at birth to 1.0 at 12 months)
        let maxBlur: Float = 15.0
        let minBlur: Float = 1.0
        let progress = Float(age / 12.0)
        return max(minBlur, maxBlur - (maxBlur - minBlur) * progress)
    }
    
    static func calculateSaturation(forAge age: Double) -> Float {
        // Saturation increases with age (0.0 at birth to 1.0 at 6 months)
        return min(1.0, Float(age / 6.0))
    }
    
    static func calculateContrast(forAge age: Double) -> Float {
        // Contrast normalizes with age (1.4 at birth to 1.0 at 12 months)
        let startContrast: Float = 1.4
        let endContrast: Float = 1.0
        let progress = Float(age / 12.0)
        return startContrast - (startContrast - endContrast) * progress
    }
    
    static func createFilterChain() -> (input: ImageProcessingOperation, output: ImageProcessingOperation) {
        let blurFilter = GaussianBlur()
        let saturationFilter = SaturationAdjustment()
        let contrastFilter = ContrastAdjustment()
        
        // Connect filters
        blurFilter --> saturationFilter --> contrastFilter
        
        return (blurFilter, contrastFilter)
    }
    
    // MARK: - Vision Effects
    
    static func applyDepthEffect(to filter: GaussianBlur, focusDistance: Float) {
        let blurAmount = (1.0 - focusDistance) * 10.0
        filter.blurRadiusInPixels = blurAmount
    }
    
    static func applyMotionEffect(to filter: GaussianBlur, sensitivity: Float) {
        filter.blurRadiusInPixels = 2.0 * sensitivity
    }
    
    // MARK: - Utility Functions
    
    static func lerp(_ a: Float, _ b: Float, _ t: Float) -> Float {
        return a + (b - a) * t
    }
    
    static func smoothStep(_ a: Float, _ b: Float, _ t: Float) -> Float {
        let x = max(0, min(1, (t - a) / (b - a)))
        return x * x * (3 - 2 * x)
    }
}

// MARK: - Filter Chain Builder
class FilterChainBuilder {
    private var filters: [ImageProcessingOperation] = []
    private var currentFilter: ImageProcessingOperation?
    
    @discardableResult
    func addBlur(radius: Float) -> FilterChainBuilder {
        let blur = GaussianBlur()
        blur.blurRadiusInPixels = radius
        appendFilter(blur)
        return self
    }
    
    @discardableResult
    func addSaturation(_ value: Float) -> FilterChainBuilder {
        let saturation = SaturationAdjustment()
        saturation.saturation = value
        appendFilter(saturation)
        return self
    }
    
    @discardableResult
    func addContrast(_ value: Float) -> FilterChainBuilder {
        let contrast = ContrastAdjustment()
        contrast.contrast = value
        appendFilter(contrast)
        return self
    }
    
    private func appendFilter(_ filter: ImageProcessingOperation) {
        if let current = currentFilter {
            current --> filter
        }
        currentFilter = filter
        filters.append(filter)
    }
    
    func build() -> (input: ImageProcessingOperation, output: ImageProcessingOperation)? {
        guard let firstFilter = filters.first,
              let lastFilter = filters.last else {
            return nil
        }
        return (firstFilter, lastFilter)
    }
}
