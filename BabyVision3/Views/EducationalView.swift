//
//  EducationalView.swift
//  BabyVision3
//
//  Created by Ryan Faucett on 10/23/24.
//

import SwiftUI

struct EducationalView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom tab bar
                TabBarView(selectedTab: $selectedTab)
                
                TabView(selection: $selectedTab) {
                    DevelopmentGuideView()
                        .tag(0)
                    
                    ComparisonView()
                        .tag(1)
                    
                    ResourcesView()
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("Baby Vision Guide")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct TabBarView: View {
    @Binding var selectedTab: Int
    let tabs = ["Development", "Compare", "Resources"]
    
    var body: some View {
        HStack {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: { selectedTab = index }) {
                    VStack {
                        Text(tabs[index])
                            .font(.headline)
                            .foregroundColor(selectedTab == index ? .blue : .gray)
                        
                        Rectangle()
                            .fill(selectedTab == index ? Color.blue : Color.clear)
                            .frame(height: 2)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

struct DevelopmentGuideView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(VisionCharacteristics.developmentStages, id: \.ageInMonths) { stage in
                    DevelopmentCard(stage: stage)
                }
            }
            .padding()
        }
    }
}

struct DevelopmentCard: View {
    let stage: VisionCharacteristics
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: { isExpanded.toggle() }) {
                HStack {
                    Text("\(Int(stage.ageInMonths)) Months")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
            }
            .foregroundColor(.primary)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(stage.detailedInfo.keyDevelopments, id: \.self) { development in
                        HStack(alignment: .top) {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 8))
                                .padding(.top, 6)
                            Text(development)
                        }
                    }
                    
                    Text("Parent Tips")
                        .font(.headline)
                        .padding(.top)
                    
                    ForEach(stage.detailedInfo.parentTips, id: \.self) { tip in
                        HStack(alignment: .top) {
                            Image(systemName: "lightbulb.fill")
                                .font(.system(size: 12))
                                .padding(.top, 4)
                            Text(tip)
                        }
                    }
                }
                .padding(.top)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
        .animation(.spring(), value: isExpanded)
    }
}

struct ComparisonView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Vision Comparison")
                    .font(.title2)
                    .padding(.top)
                
                Text("Slide between different ages to see how infant vision develops over time.")
                    .padding(.horizontal)
                
                // Vision comparison cards would go here
                // This is a placeholder for future implementation
                Text("Coming Soon: Interactive Vision Comparison")
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ResourcesView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ResourceCard(
                    title: "Understanding Baby Vision",
                    description: "Learn about the stages of visual development",
                    icon: "eye.fill"
                )
                
                ResourceCard(
                    title: "Activities Guide",
                    description: "Age-appropriate activities to support vision development",
                    icon: "star.fill"
                )
                
                ResourceCard(
                    title: "Warning Signs",
                    description: "When to consult a pediatrician about vision concerns",
                    icon: "exclamationmark.triangle.fill"
                )
            }
            .padding()
        }
    }
}

struct ResourceCard: View {
    let title: String
    let description: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.blue)
                .frame(width: 50)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
