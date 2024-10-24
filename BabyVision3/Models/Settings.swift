//
//  Settings.swift
//  BabyVision3
//
//  Created by Ryan Faucett on 10/23/24.
//

import Foundation
import SwiftUI
import AVFoundation

class SettingsManager: ObservableObject {
    @Published var showDataOverlay: Bool {
        didSet {
            UserDefaults.standard.set(showDataOverlay, forKey: "showDataOverlay")
        }
    }
    
    @Published var showTooltips: Bool {
        didSet {
            UserDefaults.standard.set(showTooltips, forKey: "showTooltips")
        }
    }
    
    @Published var enableAdvancedFeatures: Bool {
        didSet {
            UserDefaults.standard.set(enableAdvancedFeatures, forKey: "enableAdvancedFeatures")
        }
    }
    
    @Published var selectedViewMode: ViewMode {
        didSet {
            UserDefaults.standard.set(selectedViewMode.rawValue, forKey: "viewMode")
        }
    }
    
    @Published var cameraSettings: CameraSettings // Moved to the main body of the class
    @Published var processingSettings: ProcessingSettings // Moved to the main body of the class
    
    enum ViewMode: String, CaseIterable {
        case standard
        case splitScreen
        case comparison
        case scientific
        
        var description: String {
            switch self {
            case .standard: return "Standard View"
            case .splitScreen: return "Split Screen"
            case .comparison: return "Comparison"
            case .scientific: return "Scientific Data"
            }
        }
    }
    
    // Initializer
    init() {
        self.showDataOverlay = UserDefaults.standard.bool(forKey: "showDataOverlay")
        self.showTooltips = UserDefaults.standard.bool(forKey: "showTooltips")
        self.enableAdvancedFeatures = UserDefaults.standard.bool(forKey: "enableAdvancedFeatures")
        if let savedMode = UserDefaults.standard.string(forKey: "viewMode"),
           let mode = ViewMode(rawValue: savedMode) {
            self.selectedViewMode = mode
        } else {
            self.selectedViewMode = .standard
        }
        
        self.cameraSettings = CameraSettings() // Initialize cameraSettings
        self.processingSettings = ProcessingSettings() // Initialize processingSettings
    }
}

// Camera settings struct moved outside the extension
struct CameraSettings {
    var resolution: AVCaptureSession.Preset = .high
    var frameRate: Int = 60
    var stabilization: Bool = true
}

// Processing settings struct moved outside the extension
struct ProcessingSettings {
    var useHighQualityProcessing: Bool = true
    var enableDepthMapping: Bool = true
    var enableMotionTracking: Bool = true
}
