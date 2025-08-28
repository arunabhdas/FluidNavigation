//
//  StateBasedNavigationManager.swift
//  StateBasedNavigationManager
//
//  Created by Arunabh Das on 8/28/25.
//

import SwiftUI

// Optional: State-based navigation manager if you want a separate class
public struct StateBasedNavigationManager {
    public var navigationStack: [AnyView]
    public var isAnimating: Bool
    
    public init() {
        self.navigationStack = []
        self.isAnimating = false
    }
    
    public var canGoBack: Bool {
        !navigationStack.isEmpty && !isAnimating
    }
}
