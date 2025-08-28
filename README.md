# FluidNavigation

A SwiftUI library that brings UIKit-style navigation with smooth animations to pure SwiftUI apps.

## Features

- 🎯 UIKit-style navigation stack management
- ✨ Multiple transition animations (slide, fade, scale, slideUp)
- 👆 Swipe-back gesture support
- 🔧 Customizable navigation bars
- 📱 iOS 16+ support with backward compatibility

## Installation

### Swift Package Manager

Add FluidNavigation to your project:

1. In Xcode, go to File → Add Package Dependencies
2. Enter the repository URL: `https://github.com/yourusername/FluidNavigation`
3. Click Add Package

Or add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/FluidNavigation", from: "1.0.0")
]


### Quickstart

```
import SwiftUI
import FluidNavigation

struct ContentView: View {
    var body: some View {
        FluidNavigationStack {
            HomeView()
        }
    }
}

struct HomeView: View {
    var body: some View {
        VStack {
            FluidNavigationButton(
                destination: DetailView(),
                transition: .slide
            ) {
                Text("Navigate to Detail")
            }
        }
        .fluidNavigationTitle("Home")
    }
}

```
