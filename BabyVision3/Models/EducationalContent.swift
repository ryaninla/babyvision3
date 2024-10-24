//
//  EducationalContent.swift
//  BabyVision3
//
//  Created by Ryan Faucett on 10/23/24.
//

import Foundation

struct EducationalContent {
    struct LearningModule: Identifiable {
        let id = UUID()
        let title: String
        let difficulty: Difficulty
        let sections: [ModuleSection]
        let interactiveElements: [InteractiveElement]
        
        enum Difficulty {
            case beginner
            case intermediate
            case advanced
            case professional
        }
    }
    
    struct ModuleSection: Identifiable {
        let id = UUID()
        let title: String
        let content: String
        let type: ContentType
        let media: [MediaItem]
        
        enum ContentType {
            case overview
            case detailed
            case scientific
            case practical
        }
    }
    
    struct MediaItem: Identifiable {
        let id = UUID()
        let type: MediaType
        let url: String
        let caption: String
        
        enum MediaType {
            case image
            case video
            case diagram
            case animation
        }
    }
    
    struct InteractiveElement: Identifiable {
        let id = UUID()
        let type: InteractionType
        let title: String
        let description: String
        let content: String
        
        enum InteractionType {
            case simulation
            case comparison
            case quiz
            case experiment
        }
    }
    
    // Static content
    static let modules: [LearningModule] = [
        LearningModule(
            title: "Understanding Newborn Vision",
            difficulty: .beginner,
            sections: [
                ModuleSection(
                    title: "First Month of Vision",
                    content: "In the first month, babies can only see 8-12 inches from their face...",
                    type: .overview,
                    media: []
                ),
                // Add more sections...
            ],
            interactiveElements: [
                InteractiveElement(
                    type: .simulation,
                    title: "Experience Newborn Vision",
                    description: "See the world through a newborn's eyes",
                    content: "simulation-newborn"
                )
                // Add more interactive elements...
            ]
        )
        // Add more modules...
    ]
}
