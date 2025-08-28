#!/bin/bash

# Create FluidNavigation Package Setup Script
PACKAGE_NAME="FluidNavigation"
GITHUB_USERNAME="yourusername"

echo "🚀 Creating Swift Package: $PACKAGE_NAME"

# Create package
swift package init --type library --name $PACKAGE_NAME
cd $PACKAGE_NAME

# Create proper directory structure
mkdir -p Sources/$PACKAGE_NAME/Extensions
mkdir -p Tests/${PACKAGE_NAME}Tests
mkdir -p Documentation/$PACKAGE_NAME.docc/Tutorials

echo "📁 Directory structure created"

# Initialize git
git init
echo ".DS_Store" > .gitignore
echo "/.build" >> .gitignore
echo "/Packages" >> .gitignore
echo "xcuserdata/" >> .gitignore
echo "*.xcodeproj" >> .gitignore

echo "🔧 Git initialized with .gitignore"

# Create README template
cat > README.md << EOL
# $PACKAGE_NAME

A SwiftUI library that brings UIKit-style navigation with smooth animations.

## Installation

\`\`\`swift
.package(url: "https://github.com/$GITHUB_USERNAME/$PACKAGE_NAME", from: "1.0.0")
\`\`\`

## Usage

\`\`\`swift
import $PACKAGE_NAME

// Your usage example here
\`\`\`

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

## License

MIT License
EOL

echo "📝 README.md created"

# Generate and open Xcode project
swift package generate-xcodeproj
open $PACKAGE_NAME.xcodeproj

echo "✅ Package setup complete! Xcode project opened."
