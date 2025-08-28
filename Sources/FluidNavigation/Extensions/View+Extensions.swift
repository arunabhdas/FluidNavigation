//
//  View+Extensions.swift
//  FluidNavigation
//
//  Created by Arunabh Das on 8/27/25.
//

import SwiftUI

public extension View {
    func fluidNavigationBar<Leading: View, Center: View, Trailing: View>(
        backgroundColor: Color = Color(.systemBackground),
        showBackButton: Bool = true,
        @ViewBuilder leading: () -> Leading = { EmptyView() },
        @ViewBuilder center: () -> Center = { EmptyView() },
        @ViewBuilder trailing: () -> Trailing = { EmptyView() }
    ) -> some View {
        VStack(spacing: 0) {
            FluidNavigationBar(
                backgroundColor: backgroundColor,
                showBackButton: showBackButton,
                leading: leading,
                center: center,
                trailing: trailing
            )
            self
            Spacer(minLength: 0)
        }
    }
    
    func fluidNavigationTitle(_ title: String) -> some View {
        fluidNavigationBar {
            // Leading
        } center: {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
        } trailing: {
            // Trailing
        }
    }
}
