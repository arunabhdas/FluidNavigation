
import SwiftUI

public struct FluidNavigationStack<Root: View>: View {
    private let rootView: Root
    private let enableSwipeBack: Bool
    
    @State private var navigationStack: [AnyView] = []
    @State private var isAnimating = false
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false
    
    private let swipeThreshold: CGFloat = 100
    private let animationDuration: Double = 0.3
    
    public init(enableSwipeBack: Bool = true, @ViewBuilder root: () -> Root) {
        self.rootView = root()
        self.enableSwipeBack = enableSwipeBack
    }
    
    public var body: some View {
        _FluidNavigationStackBody(
            rootView: rootView,
            enableSwipeBack: enableSwipeBack,
            navigationStack: $navigationStack,
            isAnimating: $isAnimating,
            dragOffset: $dragOffset,
            isDragging: $isDragging
        )
    }
}

private struct _FluidNavigationStackBody<Root: View>: View {
    let rootView: Root
    let enableSwipeBack: Bool
    
    @Binding var navigationStack: [AnyView]
    @Binding var isAnimating: Bool
    @Binding var dragOffset: CGSize
    @Binding var isDragging: Bool
    
    private let swipeThreshold: CGFloat = 100
    private let animationDuration: Double = 0.3
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                rootView
                    .environment(\.navigationActions, NavigationActions(
                        push: push,
                        pop: pop,
                        popToRoot: popToRoot,
                        canGoBack: canGoBack
                    ))
                    .opacity(navigationStack.isEmpty ? 1 : 0)
                    .offset(x: navigationStack.isEmpty ? 0 : -geometry.size.width * 0.3)
                
                ForEach(0..<navigationStack.count, id: \.self) { index in
                    let isTopView = index == navigationStack.count - 1
                    
                    navigationStack[index]
                        .environment(\.navigationActions, NavigationActions(
                            push: push,
                            pop: pop,
                            popToRoot: popToRoot,
                            canGoBack: canGoBack
                        ))
                        .offset(x: isTopView ? dragOffset.width : 0)
                        .opacity(isTopView ? (isDragging ? max(0.3, 1 - abs(dragOffset.width) / geometry.size.width) : 1) : 0)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .trailing)
                        ))
                        .gesture(
                            enableSwipeBack && isTopView ? swipeGesture(geometry: geometry) : nil
                        )
                }
            }
            .clipped()
        }
    }
    
    private var canGoBack: Bool {
        !navigationStack.isEmpty && !isAnimating
    }
    
    private func push(_ view: AnyView, _ transition: NavigationTransition) {
        guard !isAnimating else { return }
        
        isAnimating = true
        
        withAnimation(.easeInOut(duration: animationDuration)) {
            navigationStack.append(view)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            self.isAnimating = false
        }
    }
    
    private func pop() {
        guard !isAnimating, !navigationStack.isEmpty else { return }
        
        isAnimating = true
        
        withAnimation(.easeInOut(duration: animationDuration)) {
            navigationStack.removeLast()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            self.isAnimating = false
        }
    }
    
    private func popToRoot() {
        guard !isAnimating, !navigationStack.isEmpty else { return }
        
        isAnimating = true
        
        withAnimation(.easeInOut(duration: animationDuration)) {
            navigationStack.removeAll()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            self.isAnimating = false
        }
    }
    
    private func swipeGesture(geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { value in
                guard value.translation.x > 0 && canGoBack else { return }
                isDragging = true
                dragOffset = value.translation
            }
            .onEnded { value in
                if value.translation.x > swipeThreshold {
                    pop()
                } else {
                    withAnimation(.spring()) {
                        dragOffset = .zero
                    }
                }
                isDragging = false
            }
    }
}
