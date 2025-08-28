//
//  NavigationTransition.swift
//  FluidNavigation
//
//  Created by Arunabh Das on 8/27/25.
//

import SwiftUI

// MARK: - Navigation Transitions
public enum NavigationTransition {
    case slide
    case fade
    case scale
    case slideUp
    case custom(AnyTransition)
    
    var transition: AnyTransition {
        switch self {
        case .slide:
            return .asymmetric(
                insertion: .move(edge: .trailing),
                removal: .move(edge: .leading)
            )
        case .fade:
            return .opacity
        case .scale:
            return .asymmetric(
                insertion: .scale(scale: 0.8).combined(with: .opacity),
                removal: .scale(scale: 1.2).combined(with: .opacity)
            )
        case .slideUp:
            return .asymmetric(
                insertion: .move(edge: .bottom),
                removal: .move(edge: .top)
            )
        case .custom(let transition):
            return transition
        }
    }
}
