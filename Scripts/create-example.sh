#!/bin/bash

set -e

EXAMPLE_DIR="Examples/FluidNavigationDemo"
PACKAGE_NAME="FluidNavigation"

echo "🚀 Creating FluidNavigation Example Project..."

# Create directory structure
mkdir -p "$EXAMPLE_DIR"/{Sources,Resources}

# Create project.yml for XcodeGen
cat > "$EXAMPLE_DIR/project.yml" << 'EOL'
name: FluidNavigationDemo
options:
  bundleIdPrefix: com.yourcompany.fluidnavigation
  deploymentTarget:
    iOS: "15.0"

targets:
  FluidNavigationDemo:
    type: application
    platform: iOS
    sources: [Sources]
    resources: [Resources]
    settings:
      PRODUCT_BUNDLE_IDENTIFIER: com.yourcompany.fluidnavigation.demo
      INFOPLIST_FILE: Resources/Info.plist
    dependencies:
      - package: FluidNavigation
        product: FluidNavigation

packages:
  FluidNavigation:
    path: ../../
EOL

# Create App.swift
cat > "$EXAMPLE_DIR/Sources/App.swift" << 'EOL'
import SwiftUI
import FluidNavigation

@main
struct FluidNavigationDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
EOL

# Create ContentView.swift with full demo content
# (Insert the ContentView.swift content from above)

# Create Info.plist
# (Insert the Info.plist content from above)

# Create README for example
cat > "$EXAMPLE_DIR/README.md" << EOL
# FluidNavigation Demo

This example app demonstrates the usage of FluidNavigation library.

## Features Demonstrated

- Multiple transition types (slide, fade, scale, slideUp)
- Swipe-back gesture support
- Deep navigation stacks
- Custom navigation bars
- Pop to root functionality

## Running the Demo

1. Open \`FluidNavigationDemo.xcodeproj\`
2. Build and run on simulator or device
3. Explore different transition animations
4. Try swiping from the left edge to go back

## Requirements

- iOS 15.0+
- Xcode 15.0+
EOL

cd "$EXAMPLE_DIR"

# Check if xcodegen is installed
if ! command -v xcodegen &> /dev/null; then
    echo "❌ XcodeGen not found. Install it with: brew install xcodegen"
    exit 1
fi

# Generate project
echo "📦 Generating Xcode project..."
xcodegen generate

echo "✅ Example project created successfully!"
echo "📂 Location: $EXAMPLE_DIR"
echo "🚀 Run: open $EXAMPLE_DIR/FluidNavigationDemo.xcodeproj"

# Optionally open the project
read -p "Open project in Xcode? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    open FluidNavigationDemo.xcodeproj
fi
