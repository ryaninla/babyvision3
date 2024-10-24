//
//  TimelineView.swift
//  BabyVision3
//
//  Created by Ryan Faucett on 10/23/24.
//

import SwiftUI

struct TimelineView: View {
    let milestones = VisionCharacteristics.developmentStages
    @State private var selectedMilestone: VisionCharacteristics?
    @State private var showingFullDetail = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Vision Development Timeline")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                
                // Main Timeline
                VStack(spacing: 0) {
                    ForEach(milestones) { milestone in
                        TimelineItem(
                            milestone: milestone,
                            isSelected: selectedMilestone?.id == milestone.id,
                            onTap: {
                                withAnimation {
                                    if selectedMilestone?.id == milestone.id {
                                        selectedMilestone = nil
                                    } else {
                                        selectedMilestone = milestone
                                    }
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .sheet(isPresented: $showingFullDetail) {
            if let milestone = selectedMilestone {
                MilestoneDetailSheet(milestone: milestone)
            }
        }
    }
}

struct TimelineItem: View {
    let milestone: VisionCharacteristics
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Timeline node and line
            HStack(spacing: 0) {
                // Left date column
                Text("\(Int(milestone.ageInMonths)) months")
                    .font(.headline)
                    .frame(width: 80, alignment: .trailing)
                    .padding(.trailing)
                
                // Timeline line and node
                VStack(spacing: 0) {
                    Circle()
                        .fill(isSelected ? Color.blue : Color.gray)
                        .frame(width: 12, height: 12)
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 2)
                        .frame(height: 60)
                }
                .padding(.trailing)
                
                // Content
                VStack(alignment: .leading, spacing: 8) {
                    Text(milestone.detailedInfo.title)
                        .font(.headline)
                    Text(milestone.detailedInfo.overview)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(isSelected ? nil : 2)
                    
                    if isSelected {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(milestone.detailedInfo.keyDevelopments, id: \.self) { development in
                                HStack(alignment: .top) {
                                    Image(systemName: "circle.fill")
                                        .font(.system(size: 6))
                                        .padding(.top, 6)
                                    Text(development)
                                        .font(.subheadline)
                                }
                            }
                        }
                        .padding(.top, 4)
                    }
                }
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}

struct MilestoneDetailSheet: View {
    let milestone: VisionCharacteristics
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Overview Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Overview")
                            .font(.headline)
                        Text(milestone.detailedInfo.overview)
                    }
                    
                    // Key Developments Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Key Developments")
                            .font(.headline)
                        ForEach(milestone.detailedInfo.keyDevelopments, id: \.self) { development in
                            HStack(alignment: .top) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text(development)
                            }
                        }
                    }
                    
                    // Parent Tips Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Parent Tips")
                            .font(.headline)
                        ForEach(milestone.detailedInfo.parentTips, id: \.self) { tip in
                            HStack(alignment: .top) {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(.yellow)
                                Text(tip)
                            }
                        }
                    }
                    
                    // Scientific Details Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Scientific Details")
                            .font(.headline)
                        Text(milestone.detailedInfo.scientificDetails)
                    }
                }
                .padding()
            }
            .navigationTitle("Age \(Int(milestone.ageInMonths)) Months")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

#Preview {
    TimelineView()
}
