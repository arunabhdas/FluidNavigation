//
//  FluidNavigationBar.swift
//  FluidNavigation
//
//  Created by Coder on 8/28/25.
//

import SwiftUI

public struct FluidNavigationBar<Leading: View, Center: View, Trailing: View>: View {
    @Environment(\.navigationActions) private var navigationActions
    
    private let leading: Leading
    private let center: Center
    private let trailing: Trailing
    private let backgroundColor: Color
    private let showBackButton: Bool
    
    public init(
        backgroundColor: Color = Color(.systemBackground),
        showBackButton: Bool = true,
        @ViewBuilder leading: () -> Leading = { EmptyView() },
        @ViewBuilder center: () -> Center = { EmptyView() },
        @ViewBuilder trailing: () -> Trailing = { EmptyView() }
    ) {
        self.backgroundColor = backgroundColor
        self.showBackButton = showBackButton
        self.leading = leading()
        self.center = center()
        self.trailing = trailing()
    }
    
    public var body: some View {
        HStack {
            HStack {
                if showBackButton && navigationActions.canGoBack {
                    Button(action: {
                        navigationActions.pop()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.primary)
                    }
                    .transition(.opacity)
                }
                leading
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            center
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            
            trailing
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal)
        .frame(height: 44)
        .background(backgroundColor)
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color(.separator)),
            alignment: .bottom
        )
    }
}
