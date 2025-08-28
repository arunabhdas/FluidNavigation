//
//  NavigationTransition.swift
//  FluidNavigation
//
//  Created by Arunabh Das on 8/27/25.
//

import SwiftUI

// MARK: - Navigation Transitions
public enum NavigationTransition: Equatable {
    case slide
    case fade
    case scale
    case slideUp
    case fullScreenCover
    case sheet
    case custom(AnyTransition)
    
    public static func == (lhs: NavigationTransition, rhs: NavigationTransition) -> Bool {
        switch (lhs, rhs) {
        case (.slide, .slide),
             (.fade, .fade),
             (.scale, .scale),
             (.slideUp, .slideUp),
             (.fullScreenCover, .fullScreenCover),
             (.sheet, .sheet):
            return true
        case (.custom, .custom):
            // Custom transitions are considered equal if they're both custom
            // (we can't compare AnyTransition directly)
            return true
        default:
            return false
        }
    }
    
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
        case .fullScreenCover:
            return .asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .move(edge: .bottom).combined(with: .opacity)
            )
        case .sheet:
            return .asymmetric(
                insertion: .move(edge: .bottom),
                removal: .move(edge: .bottom)
            )
        case .custom(let transition):
            return transition
        }
    }
    
    var isModal: Bool {
        switch self {
        case .fullScreenCover, .sheet:
            return true
        default:
            return false
        }
    }
}
