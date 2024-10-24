//
//  LearningModules.swift
//  BabyVision3
//
//  Created by Ryan Faucett on 10/23/24.
//

import SwiftUI

struct LearningModules: View {
    @State private var selectedModule: EducationalContent.LearningModule?
    
    var body: some View {
        List(EducationalContent.modules) { module in
            ModuleRow(module: module)
                .onTapGesture {
                    selectedModule = module
                }
        }
        .sheet(item: $selectedModule) { module in
            ModuleDetailView(module: module)
        }
    }
}

struct ModuleRow: View {
    let module: EducationalContent.LearningModule
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(module.title)
                .font(.headline)
            
            HStack {
                ModuleTypeTag(type: module.difficulty)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
}

struct ModuleTypeTag: View {
    let type: EducationalContent.LearningModule.Difficulty
    
    var body: some View {
        Text(String(describing: type).capitalized)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(tagColor.opacity(0.2))
            .foregroundColor(tagColor)
            .cornerRadius(4)
    }
    
    var tagColor: Color {
        switch type {
        case .beginner: return .blue
        case.intermediate: return .orange
        case .advanced: return .purple
        case .professional: return .green
        }
    }
}

struct ModuleDetailView: View {
    let module: EducationalContent.LearningModule
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(module.sections) { section in
                        SectionView(section: section)
                    }
                    
                    if !module.interactiveElements.isEmpty {
                        Text("Activities")
                            .font(.title2)
                            .padding(.top)
                        
                        ForEach(module.interactiveElements) { activity in
                            ActivityView(activity: activity)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(module.title)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct SectionView: View {
    let section: EducationalContent.ModuleSection // Use ModuleSection instead of ContentSection

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(section.title)
                .font(.title3)
                .bold()
            
            Text(section.content)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
    }
}

struct ActivityView: View {
    let activity: EducationalContent.InteractiveElement // Replace Activity with InteractiveElement

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(activity.title)
                .font(.headline)
            
            Text(activity.description)
                .foregroundColor(.secondary)
            
            Text("Content: \(activity.content)") // Displaying content instead of ageRange
                .font(.caption)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
