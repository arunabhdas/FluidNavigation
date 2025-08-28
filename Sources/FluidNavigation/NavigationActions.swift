//
//  NavigationActions.swift
//  FluidNavigation
//
//  Created by Arunabh Das on 8/27/25.
//

import SwiftUI

// Environment-based Navigation Actions (works on all iOS versions)
public struct NavigationActions: @unchecked Sendable {
    public let push: (AnyView, NavigationTransition) -> Void
    public let pop: () -> Void
    public let popToRoot: @Sendable () -> Void
    public let canGoBack: Bool
    
    public func push<Content: View>(_ view: Content, transition: NavigationTransition = .slide) {
        push(AnyView(view), transition)
    }
    
    public init(
        push: @escaping @Sendable (AnyView, NavigationTransition) -> Void,
        pop: @escaping @Sendable () -> Void,
        popToRoot: @escaping @Sendable () -> Void,
        canGoBack: Bool
    ) {
        self.push = push
        self.pop = pop
        self.popToRoot = popToRoot
        self.canGoBack = canGoBack
    }
    
    // Make the empty instance nonisolated to avoid concurrency warnings
    nonisolated public static let empty = NavigationActions(
        push: { _, _ in },
        pop: {},
        popToRoot: {},
        canGoBack: false
    )
}

public struct NavigationActionsKey: EnvironmentKey {
    public static let defaultValue = NavigationActions.empty
}

public extension EnvironmentValues {
    var navigationActions: NavigationActions {
        get { self[NavigationActionsKey.self] }
        set { self[NavigationActionsKey.self] = newValue }
    }
}
