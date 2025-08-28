//
//  ContentView.swift
//  FluidNavigationDemo
//
//  Created by Coder on 8/28/25.
//

import SwiftUI
import FluidNavigation


struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "swift")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("FluidNavigation Demo")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Tap the buttons below to explore different navigation transitions!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(spacing: 16) {
                // Create destination views separately to help type inference
                FluidNavigationButton(
                    destination: DetailView(
                        title: "Slide Animation",
                        description: "This demonstrates the classic slide transition, similar to UINavigationController.",
                        color: .blue
                    ),
                    transition: .slide
                ) {
                    DemoButtonView(
                        title: "Slide Transition",
                        subtitle: "Classic slide animation",
                        systemImage: "arrow.right",
                        color: .blue
                    )
                }
                
                FluidNavigationButton(
                    destination: DetailView(
                        title: "Fade Animation",
                        description: "A smooth fade transition that's perfect for subtle navigation changes.",
                        color: .green
                    ),
                    transition: .fade
                ) {
                    DemoButtonView(
                        title: "Fade Transition",
                        subtitle: "Smooth opacity change",
                        systemImage: "sparkles",
                        color: .green
                    )
                }
                
                FluidNavigationButton(
                    destination: DetailView(
                        title: "Scale Animation",
                        description: "Scale transition with zoom effect - great for modal-like presentations.",
                        color: .orange
                    ),
                    transition: .scale
                ) {
                    DemoButtonView(
                        title: "Scale Transition",
                        subtitle: "Zoom in/out effect",
                        systemImage: "plus.magnifyingglass",
                        color: .orange
                    )
                }
                
                FluidNavigationButton(
                    destination: DetailView(
                        title: "Slide Up Animation",
                        description: "Slide up from bottom, perfect for sheet-like presentations.",
                        color: .purple
                    ),
                    transition: .slideUp
                ) {
                    DemoButtonView(
                        title: "Slide Up Transition",
                        subtitle: "Bottom sheet style",
                        systemImage: "arrow.up.square",
                        color: .purple
                    )
                }
            }
            
            Spacer()
        }
        .fluidNavigationTitle("FluidNavigation")
        .padding()
    }
}

struct DemoButtonView: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

struct DetailView: View {
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .overlay(
                        Image(systemName: "star.fill")
                            .font(.system(size: 40, weight: .medium))
                            .foregroundColor(.white)
                    )
                
                VStack(spacing: 12) {
                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text(description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                VStack(spacing: 16) {
                    InfoCard(
                        icon: "hand.draw",
                        title: "Swipe to Go Back",
                        description: "Try swiping from the left edge of the screen to navigate back!"
                    )
                    
                    InfoCard(
                        icon: "layers",
                        title: "Stack Navigation",
                        description: "Navigate deeper to see how the navigation stack manages multiple views."
                    )
                }
                
                FluidNavigationButton(
                    destination: NestedView(level: 2, color: color),
                    transition: .slide
                ) {
                    HStack {
                        Image(systemName: "arrow.down")
                            .font(.headline)
                        Text("Go Deeper")
                            .font(.headline)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(color)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Spacer(minLength: 50)
            }
        }
        .fluidNavigationTitle(title)
        .padding()
    }
}

struct InfoCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct NestedView: View {
    let level: Int
    let color: Color
    @Environment(\.navigationActions) private var navigation
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Level \(level)")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("You're \(level) levels deep in the navigation stack")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if level < 4 {
                FluidNavigationButton(
                    destination: NestedView(level: level + 1, color: color),
                    transition: .slide
                ) {
                    Text("Go to Level \(level + 1)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(color)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            
            Button(action: {
                navigation.popToRoot()
            }) {
                Text("Pop to Root")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .fluidNavigationTitle("Level \(level)")
        .padding()
    }
}

#Preview {
    ContentView()
}
