//
//  FluidNavigation.swift
//  FluidNavigation
//
//  Created by Arunabh Das on 8/28/25.
//

import SwiftUI

public struct FluidNavigationStack<Root: View>: View {
    private let rootView: Root
    private let enableSwipeBack: Bool
    
    @State private var navigationStack: [AnyView] = []
    @State private var modalStack: [ModalPresentation] = []
    @State private var isAnimating = false
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false
    
    private let swipeThreshold: CGFloat = 100
    private let animationDuration: Double = 0.3
    
    private struct ModalPresentation: Identifiable {
        let id = UUID()
        let view: AnyView
        let transition: NavigationTransition
    }
    
    public init(enableSwipeBack: Bool = true, @ViewBuilder root: () -> Root) {
        self.rootView = root()
        self.enableSwipeBack = enableSwipeBack
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                rootView
                    .environment(\.navigationActions, navigationActions)
                    .opacity(navigationStack.isEmpty ? 1 : 0)
                    .offset(x: navigationStack.isEmpty ? 0 : -geometry.size.width * 0.3)
                
                ForEach(0..<navigationStack.count, id: \.self) { index in
                    let isTopView = index == navigationStack.count - 1
                    
                    navigationStack[index]
                        .environment(\.navigationActions, navigationActions)
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
        .fullScreenCover(
            isPresented: .constant(!modalStack.isEmpty && modalStack.last?.transition == .fullScreenCover),
            onDismiss: { dismissModal() }
        ) {
            if let modal = modalStack.last, modal.transition == .fullScreenCover {
                modal.view
                    .environment(\.navigationActions, modalNavigationActions)
            }
        }
        .sheet(
            isPresented: .constant(!modalStack.isEmpty && modalStack.last?.transition == .sheet),
            onDismiss: { dismissModal() }
        ) {
            if let modal = modalStack.last, modal.transition == .sheet {
                modal.view
                    .environment(\.navigationActions, modalNavigationActions)
            }
        }
    }
    
    // Simple computed property that creates NavigationActions
    private var navigationActions: NavigationActions {
        NavigationActions(
            push: pushAction,
            pop: popAction,
            popToRoot: popToRootAction,
            canGoBack: canGoBack
        )
    }
    
    private var canGoBack: Bool {
        !navigationStack.isEmpty && !isAnimating
    }
    
    // These are just simple function references - no complex closures
    private func pushAction(_ view: AnyView, _ transition: NavigationTransition) {
        performPush(view, transition: transition)
    }
    
    private func popAction() {
        performPop()
    }
    
    private func popToRootAction() {
        performPopToRoot()
    }
    
    // The actual implementation functions
    private func performPush(_ view: AnyView, transition: NavigationTransition = .slide) {
        guard !isAnimating else { return }
        
        isAnimating = true
        
        withAnimation(.easeInOut(duration: animationDuration)) {
            navigationStack.append(view)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            self.isAnimating = false
        }
    }
    
    private func performPop() {
        guard !isAnimating, !navigationStack.isEmpty else { return }
        
        isAnimating = true
        
        withAnimation(.easeInOut(duration: animationDuration)) {
            navigationStack.removeLast()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            self.isAnimating = false
        }
    }
    
    private func performPopToRoot() {
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
                // Use .width instead of .x for CGSize
                guard value.translation.width > 0 && canGoBack else { return }
                isDragging = true
                dragOffset = value.translation
            }
            .onEnded { value in
                // Use .width instead of .x for CGSize
                let dragDistance = value.translation.width
                
                if dragDistance > swipeThreshold {
                    performPop()
                } else {
                    withAnimation(.spring()) {
                        dragOffset = .zero
                    }
                }
                
                isDragging = false
            }
    }
    
    private var modalNavigationActions: NavigationActions {
        NavigationActions(
            push: modalPushAction,
            pop: modalPopAction,
            popToRoot: modalPopToRootAction,
            canGoBack: modalCanGoBack
        )
    }
    
    private var modalCanGoBack: Bool {
        !modalStack.isEmpty && !isAnimating
    }
    
    private func modalPushAction(_ view: AnyView, _ transition: NavigationTransition) {
        performModalPush(view, transition: transition)
    }
    
    private func modalPopAction() {
        performModalPop()
    }
    
    private func modalPopToRootAction() {
        performModalPopToRoot()
    }
    
    private func performModalPush(_ view: AnyView, transition: NavigationTransition) {
        guard !isAnimating else { return }
        
        isAnimating = true
        
        withAnimation(.easeInOut(duration: animationDuration)) {
            modalStack.append(ModalPresentation(view: view, transition: transition))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            self.isAnimating = false
        }
    }
    
    private func performModalPop() {
        guard !isAnimating, !modalStack.isEmpty else { return }
        
        isAnimating = true
        
        withAnimation(.easeInOut(duration: animationDuration)) {
            modalStack.removeLast()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            self.isAnimating = false
        }
    }
    
    private func performModalPopToRoot() {
        guard !isAnimating, !modalStack.isEmpty else { return }
        
        isAnimating = true
        
        withAnimation(.easeInOut(duration: animationDuration)) {
            modalStack.removeAll()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            self.isAnimating = false
        }
    }
    
    private func dismissModal() {
        performModalPop()
    }
}
