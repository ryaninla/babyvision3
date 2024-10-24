//
//  ViewModifiers.swift
//  BabyVision3
//
//  Created by Ryan Faucett on 10/23/24.
//

import SwiftUI

// MARK: - Style Modifiers

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(radius: 2)
    }
}

struct ControlBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(15)
    }
}

struct TooltipStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .shadow(radius: 4)
    }
}

// MARK: - Animation Modifiers

struct SlideTransition: ViewModifier {
    let edge: Edge
    
    func body(content: Content) -> some View {
        content
            .transition(.move(edge: edge))
    }
}

struct FadeTransition: ViewModifier {
    func body(content: Content) -> some View {
        content
            .transition(.opacity.combined(with: .scale))
    }
}

// MARK: - Interactive Modifiers

struct TouchDownAction: ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        action()
                    }
            )
    }
}

// MARK: - View Extensions

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
    
    func controlBackground() -> some View {
        modifier(ControlBackground())
    }
    
    func tooltipStyle() -> some View {
        modifier(TooltipStyle())
    }
    
    func slideTransition(from edge: Edge) -> some View {
        modifier(SlideTransition(edge: edge))
    }
    
    func fadeTransition() -> some View {
        modifier(FadeTransition())
    }
    
    func onTouchDown(perform action: @escaping () -> Void) -> some View {
        modifier(TouchDownAction(action: action))
    }
}

// MARK: - Custom Navigation Bar Appearance
struct CustomNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(.systemBackground), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.gray.opacity(0.2))
            .foregroundColor(.primary)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

// MARK: - Additional View Extensions

extension View {
    func customNavigationBar() -> some View {
        modifier(CustomNavigationBar())
    }
    
    func primaryButton() -> some View {
        buttonStyle(PrimaryButtonStyle())
    }
    
    func secondaryButton() -> some View {
        buttonStyle(SecondaryButtonStyle())
    }
}

// MARK: - Conditional Modifier
extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
