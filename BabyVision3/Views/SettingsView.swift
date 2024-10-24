//
//  SettingsView.swift
//  BabyVision3
//
//  Created by Ryan Faucett on 10/23/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("showTooltips") private var showTooltips = true
    @AppStorage("enableAdvancedFeatures") private var enableAdvancedFeatures = false
    @AppStorage("preferredViewMode") private var preferredViewMode = ViewMode.standard.rawValue
    @AppStorage("autoPlayEnabled") private var autoPlayEnabled = true
    
    enum ViewMode: String, CaseIterable {
        case standard = "Standard"
        case splitScreen = "Split Screen"
        case scientific = "Scientific"
        
        var icon: String {
            switch self {
            case .standard: return "camera.fill"
            case .splitScreen: return "square.split.2x1"
            case .scientific: return "chart.bar.fill"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Display")) {
                    Toggle("Show Tooltips", isOn: $showTooltips)
                    Toggle("Advanced Features", isOn: $enableAdvancedFeatures)
                    
                    Picker("Default View Mode", selection: $preferredViewMode) {
                        ForEach(ViewMode.allCases, id: \.self) { mode in
                            Label(mode.rawValue, systemImage: mode.icon)
                                .tag(mode.rawValue)
                        }
                    }
                }
                
                Section(header: Text("Behavior")) {
                    Toggle("Enable Auto-Play", isOn: $autoPlayEnabled)
                }
                
                Section(header: Text("Information")) {
                    NavigationLink(destination: AboutView()) {
                        Label("About BabyVision", systemImage: "info.circle")
                    }
                    
                
                }
                
               
                
                Section(header: Text("About")) {
                    VStack(alignment: .leading) {
                        Text("BabyVision 3")
                            .font(.headline)
                        Text("Version 1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// Supporting views (implemented as needed)
struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("About BabyVision")
                    .font(.title)
                Text("BabyVision helps parents and caregivers understand how their babies see the world during different stages of development.")
                    .padding(.bottom)
                
                Text("Features")
                    .font(.headline)
                VStack(alignment: .leading, spacing: 10) {
                    FeatureRow("Real-time vision simulation")
                    FeatureRow("Age-based development tracking")
                    FeatureRow("Educational resources")
                    FeatureRow("Scientific accuracy")
                }
            }
            .padding()
        }
        .navigationTitle("About")
    }
}

struct FeatureRow: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text(text)
        }
    }
}

// Other supporting views would go here...
