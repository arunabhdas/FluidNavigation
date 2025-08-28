//
//  NavigationActions.swift
//  FluidNavigation
//
//  Created by Arunabh Das on 8/27/25.
//
import SwiftUI

public struct NavigationActions {
    public let push: (AnyView, NavigationTransition) -> Void
    public let pop: () -> Void
    public let popToRoot: () -> Void
    public let canGoBack: Bool
    
    public func push<Content: View>(_ view: Content, transition: NavigationTransition = .slide) {
        push(AnyView(view), transition)
    }
    
    public init(
        push: @escaping (AnyView, NavigationTransition) -> Void,
        pop: @escaping () -> Void,
        popToRoot: @escaping () -> Void,
        canGoBack: Bool
    ) {
        self.push = push
        self.pop = pop
        self.popToRoot = popToRoot
        self.canGoBack = canGoBack
    }
}

public struct NavigationActionsKey: EnvironmentKey {
    public static var defaultValue: NavigationActions {
        NavigationActions(
            push: { _, _ in },
            pop: {},
            popToRoot: {},
            canGoBack: false
        )
    }
}

public extension EnvironmentValues {
    var navigationActions: NavigationActions {
        get { self[NavigationActionsKey.self] }
        set { self[NavigationActionsKey.self] = newValue }
    }
}
