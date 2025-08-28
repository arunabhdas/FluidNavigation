import SwiftUI


// NavigationManager with iOS version compatibility
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@Observable
public class ModernNavigationManager {
    private(set) var navigationStack: [AnyView] = []
    private(set) var isAnimating = false
    
    private var animationDuration: Double = 0.3
    
    public init() {}
    
    public func push<Content: View>(_ view: Content, transition: NavigationTransition = .slide) {
        guard !isAnimating else { return }
        
        isAnimating = true
        
        withAnimation(.easeInOut(duration: animationDuration)) {
            navigationStack.append(AnyView(view))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            self.isAnimating = false
        }
    }
    
    public func pop() {
        guard !isAnimating, !navigationStack.isEmpty else { return }
        
        isAnimating = true
        
        withAnimation(.easeInOut(duration: animationDuration)) {
            navigationStack.removeLast()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            self.isAnimating = false
        }
    }
    
    public func popToRoot() {
        guard !isAnimating, !navigationStack.isEmpty else { return }
        
        isAnimating = true
        
        withAnimation(.easeInOut(duration: animationDuration)) {
            navigationStack.removeAll()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            self.isAnimating = false
        }
    }
    
    public var canGoBack: Bool {
        !navigationStack.isEmpty && !isAnimating
    }
}

// Legacy NavigationManager for older iOS versions (iOS 15-16)
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public class LegacyNavigationManager: ObservableObject {
    @Published private(set) var navigationStack: [AnyView] = []
    @Published private(set) var isAnimating = false
    
    private var animationDuration: Double = 0.3
    
    public init() {}
    
    public func push<Content: View>(_ view: Content, transition: NavigationTransition = .slide) {
        guard !isAnimating else { return }
        
        isAnimating = true
        
        withAnimation(.easeInOut(duration: animationDuration)) {
            navigationStack.append(AnyView(view))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            self.isAnimating = false
        }
    }
    
    public func pop() {
        guard !isAnimating, !navigationStack.isEmpty else { return }
        
        isAnimating = true
        
        withAnimation(.easeInOut(duration: animationDuration)) {
            navigationStack.removeLast()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            self.isAnimating = false
        }
    }
    
    public func popToRoot() {
        guard !isAnimating, !navigationStack.isEmpty else { return }
        
        isAnimating = true
        
        withAnimation(.easeInOut(duration: animationDuration)) {
            navigationStack.removeAll()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            self.isAnimating = false
        }
    }
    
    public var canGoBack: Bool {
        !navigationStack.isEmpty && !isAnimating
    }
}
