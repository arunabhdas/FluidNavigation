//
//  FluidNavigationButton.swift
//  FluidNavigation
//
//  Created by Arunabh Das on 8/28/25.
//

import SwiftUI

// Navigation Button that works with environment approach
public struct FluidNavigationButton<Destination: View, Label: View>: View {
    @Environment(\.navigationActions) private var navigationActions
    
    private let destination: Destination
    private let transition: NavigationTransition
    private let label: Label
    
    public init(
        destination: Destination,
        transition: NavigationTransition = .slide,
        @ViewBuilder label: () -> Label
    ) {
        self.destination = destination
        self.transition = transition
        self.label = label()
    }
    
    public var body: some View {
        Button(action: {
            navigationActions.push(destination, transition: transition)
        }) {
            label
        }
    }
}
