//
//  StringExt.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 02.03.2026.
//

import SwiftUI

extension String {
    func toColor() -> Color {
        switch self.lowercased() {
        case "blue":   return .blue
        case "red":    return .red
        case "green":  return .green
        case "orange": return .orange
        case "purple": return .purple
        case "yellow": return .yellow
        case "gray":   return .gray
        default:
            print("⚠️ DatabaseSeeder: неизвестный цвет '\(self)', используем .gray")
            return .gray
        }
    }
}

extension String {
    func toMotivationIntensity() -> MotivationIntensity {
        switch self.lowercased() {
        case "positive": return .positive
        case "negative": return .negative
        default:         return .any
        }
    }
}
