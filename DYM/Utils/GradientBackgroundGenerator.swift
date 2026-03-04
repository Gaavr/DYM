//
//  BackgroundGenerator.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 24.02.2026.
//

import Foundation
import SwiftUI

struct GradientBackgroundGenerator {
    
    static func makeView(
        base: Color,
        secondary1: Color,
        secondary2: Color,
        kind: GradientKind,
        direction: GradientDirection,
        radialStart: CGFloat = 20,
        radialEnd: CGFloat = 420
    ) -> AnyView {
        
        let colors = [secondary1, base, secondary2]
        let gradient = Gradient(colors: colors)
        
        switch kind {
        case .linear:
            return AnyView(
                LinearGradient(
                    gradient: gradient,
                    startPoint: direction.startPoint,
                    endPoint: direction.endPoint
                )
            )
        case .radial:
            return AnyView(
                RadialGradient(
                    gradient: gradient,
                    center: .center,
                    startRadius: radialStart,
                    endRadius: radialEnd
                )
            )
        case .angular:
            return AnyView(
                AngularGradient(
                    gradient: gradient,
                    center: .center
                )
            )
        }
    }
    
    // MARK: - Random helpers
    static func randomSecondaryPair() -> (Color, Color) {
        let presets: [(Color, Color)] = [
            (.purple, .black),
            (.cyan, .purple),
            (.orange, .yellow),
            (.mint, .blue),
            (.pink, .indigo),
            (.teal, .black)
        ]
        return presets.randomElement() ?? (.purple, .black)
    }
    
    static func randomKind() -> GradientKind {
        GradientKind.allCases.randomElement() ?? .linear
    }
    
    static func randomDirection() -> GradientDirection {
        GradientDirection.allCases.randomElement() ?? .topLeadingToBottomTrailing
    }
    
    static func randomRadialRadii(for size: CGSize) -> (start: CGFloat, end: CGFloat) {
        let minSide = min(size.width, size.height)
        let start = CGFloat.random(in: minSide * 0.01 ... minSide * 0.06)
        let end   = CGFloat.random(in: minSide * 0.90 ... minSide * 1.35)
        return (start, end)
    }
}

enum GradientKind: CaseIterable {
    case linear
    case radial
    case angular
}

enum GradientDirection: CaseIterable {
    case topToBottom
    case bottomToTop
    case leftToRight
    case rightToLeft
    case topLeadingToBottomTrailing
    case bottomLeadingToTopTrailing
    
    var startPoint: UnitPoint {
        switch self {
        case .topToBottom: return .top
        case .bottomToTop: return .bottom
        case .leftToRight: return .leading
        case .rightToLeft: return .trailing
        case .topLeadingToBottomTrailing: return .topLeading
        case .bottomLeadingToTopTrailing: return .bottomLeading
        }
    }
    
    var endPoint: UnitPoint {
        switch self {
        case .topToBottom: return .bottom
        case .bottomToTop: return .top
        case .leftToRight: return .trailing
        case .rightToLeft: return .leading
        case .topLeadingToBottomTrailing: return .bottomTrailing
        case .bottomLeadingToTopTrailing: return .topTrailing
        }
    }
}
