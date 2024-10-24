//
//  InteractiveContent.swift
//  BabyVision3
//
//  Created by Ryan Faucett on 10/23/24.
//

import SwiftUI

struct InteractiveContent: View {
    @State private var selectedAge: Double = 0.0
    @State private var showingComparison = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Interactive Vision Simulator
            VisionSimulatorView(age: $selectedAge)
            
            // Age Selection
            VStack {
                Text("Adjust age to see vision changes")
                    .font(.headline)
                
                Slider(value: $selectedAge, in: 0...12, step: 0.5)
                    .padding(.horizontal)
                
                Text("\(String(format: "%.1f", selectedAge)) months")
                    .font(.subheadline)
            }
            .padding()
            
            // Compare Button
           
            }
        }
    }


struct VisionSimulatorView: View {
    @Binding var age: Double
    
    var body: some View {
        // Placeholder for vision simulation
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(height: 300)
            .overlay(
                Text("Vision Simulation")
                    .font(.headline)
            )
    }
}


